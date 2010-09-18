require 'outpost/scout/consolidation'

module Scout
  class Base
    include Scout::Consolidation

    def self.add_hook(klass)
      @@hooks ||= []
      @@hooks << klass
    end

    def measure!
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
      all_reports = @hooks.map do |hook|
        hook.build_report(@response, rules)
      end.flatten.compact

      consolidate(all_reports)
    end

  end
end
