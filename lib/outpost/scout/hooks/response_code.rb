module Scout
  module Hooks
    module ResponseCode

      def before_measurement
        puts "ResponseCode#before_measurement"
      end

      def after_measurement
        puts "ResponseCode#after_measurement"
      end

      def build_report(all_rules={})
        rules = all_rules.delete(:response_code)
        status_list = []

        if rules
          rules.each do |rule_pair|
            status_list += rule_pair.map do |rule, status|
              status if rule == @response
            end
          end
          consolidate(status_list)
        end
      end

    end
  end
end
