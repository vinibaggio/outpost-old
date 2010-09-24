module Scout
  class NoHooksError < StandardError; end

  class Base

    include Scout::Consolidation
    @@hooks = []
    attr_accessor :message, :status, :force_status

    def self.add_hook(klass)
      @@hooks << klass
    end

    def measure!
      raise NoHooksError if @hooks.nil?
      @hooks = @@hooks.collect { |hook| hook.new }
      run_before_hooks!
      @response = execute
      run_after_hooks!
    end

    def build_report(rules)
      return @force_status if @force_status

      all_reports = @hooks.collect do |hook|
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

    def run_before_hooks!
      @hooks.each do |hook|
        hook.before_measurement if hook.respond_to? :before_measurement
      end
    end
    
    def run_after_hooks!
      @hooks.each do |hook|
        hook.after_measurement(@response) if hook.respond_to? :after_measurement
      end
    end

  end
end
