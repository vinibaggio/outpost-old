module Scout::Hooks
  class ResponseTime < Base
    def before_measurement
      @start_time = Time.now
    end

    def after_measurement(result=nil)
      @execution_time = Time.now - @start_time
    end

    def build_report(response, all_rules)
      each_rule(all_rules, :response_time) do |rule, status|
        if rule.respond_to? :keys and rule.respond_to? :values
          status if test_time_intervals(rule.keys.first, rule.values.first)
        else
          :unknown
        end
      end
    end

    protected
      def test_time_intervals(rule, time)
        case rule
        when :less_than
          @execution_time < time
        when :more_than
          @execution_time > time
        else
          false
        end
      end
  end
end
