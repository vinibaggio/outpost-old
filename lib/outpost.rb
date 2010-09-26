require 'rubygems'

require 'net/ssh'

require 'outpost/scout'
require 'outpost/server'
require 'outpost/ssh'


class Outpost
  include Scout::Consolidation

  @@scouts = []
  @@reports = {}

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
      response_pairs = rules.values.map do |value|
        [value, status]
      end

      @reports ||= {}
      @reports[rules.keys.first] = Hash[response_pairs]
    end

    def options(options={})
      @@options = options
    end

    #
    #
    # Set the server configuration in one string
    #
    #   on :server => 'batman@127.0.0.1:3000' do
    #      ... some code
    #   end
    #
    #
    def on(options, &block)
      @server ||= Server.new(options[:server])
      # yield
      # PENDING
    end

    def server
      @server
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
