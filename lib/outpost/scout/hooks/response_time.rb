module Scout
  module Hooks
    module ResponseTime
      def before_measurement
        puts "ResponseTime#before_measurement"
        @start_time = Time.now
        super
      end

      def after_measurement
        puts "ResponseTime#after_measurement"
        @execution_time = Time.now - @start_time
        super
      end

      def build_report(all_rules)
        puts "ResponseTime#build_report"

        all_rules.each do |scout_hook|
          p scout_hook
        end

      end
    end
  end
end
