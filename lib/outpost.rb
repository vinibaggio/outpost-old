require 'rubygems'
require 'bundler/setup'

require 'outpost/scout'
require 'outpost/server'

begin
  require 'net/ssh'
rescue LoadError
  require 'rubygems'
  require 'net/ssh'  
end

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
      @reports ||= {}
      @reports[rules.keys.first] = rules.values.inject({}) do |result, value|
        result[value] = status
        result
      end
    end

    def options(options={})
      @@options = options
    end

    #
    # load any SSH configuration files that were specified in the SSH options. This
    # will load from ~/.ssh/config and /etc/ssh_config by default (see Net::SSH
    # for details). Merge the explicitly given ssh_options over the top of the info
    # from the config file.
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
      @server ||= Server.new(options[:serve])
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
