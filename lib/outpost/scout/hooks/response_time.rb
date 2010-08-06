module Scout
  module Hooks
    module ResponseTime
      def before_measurement
        puts "ResponseTime#before_measurement"
        @start_time = Time.now
        super
      end

      def after_measurement(response)
        puts "ResponseTime#after_measurement"
        @execution_time = Time.now - @start_time
        super(response)
      end

      def build_report(response, rules={})
        puts "ResponseTime#build_report"

        rules = rules.delete(:response_time)

        super(response, rules)
      end
    end
  end
end
