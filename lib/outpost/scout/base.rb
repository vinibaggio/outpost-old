require 'outpost/scout/consolidation'
require 'outpost/scout/message'

module Scout
  class NoHooksError < StandardError; end

  class Base

    include Scout::Consolidation

    attr_accessor :message

    def self.add_hook(klass)
      @@hooks ||= []
      @@hooks << klass
    end

    def measure!
      raise NoHooksError if @hooks.nil?

      @hooks = @@hooks.map(&:new)

      @hooks.each do |hook|
        hook.before_measurement if hook.respond_to? :before_measurement
      end

      @response = execute

      @hooks.each do |hook|
        hook.after_measurement(@response) if hook.respond_to? :after_measurement
      end
    end

    def build_report(rules)
      return @force_status if @force_status

      all_reports = @hooks.map do |hook|
        hook.build_report(@response, rules)
      end.flatten.compact

      @status = consolidate(all_reports)
    end


    def message
      Message.new(self.class.name, @status, @message)
    end

    def down!
      @status = @force_status = :down
    end

  end
end
