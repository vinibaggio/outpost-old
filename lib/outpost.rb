require 'outpost/scout'

class Outpost
  include Scout::Consolidation

  @@scouts = []
  @@reports = {}
  @@server_settings = {}

  class << self

    attr_accessor :reports

    def depends(dependencies, &block)
      dependencies.each do |scout, name|
        @@current_scout = scout
      end
      class_eval(&block)
      @@scouts << [@@current_scout, @@options]
    end

    def report(status, rules)
      @reports ||= {}
      @reports[rules.keys.first] = rules.values.inject({}) do |result, value|
        result[value] = status
        result
      end
    end

    def options(options={})
      @@options = options
    end
    
    def server(server_options={})
      @@server_settings = { :host => server_options[:host], :user => server_options[:user], :port => server_options[:port] }.reject { |k,v| v.nil? }
    end
    
    def server_settings
      @@server_settings
    end
    
  end

  def check!
    @scouts = []
    @@scouts.each do |(scout_class, options)|
      @scouts << scout_class.new(options).tap do |scout|
        scout.measure!
      end
    end
    consolidate(report_status)
  end

  def messages
    @scouts.collect { |scout| scout.message }
  end

  private

  def report_status
    statuses = @scouts.map do |scout|
      scout.build_report(self.class.reports.dup)
    end
  end

end
