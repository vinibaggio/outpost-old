module Scout
  module Hooks
    module ResponseCode

      def after_measurement(response)
        @response_code = response
        super(response)
      end


      def build_report(response, rules={})
        super(response, rules)
      end
    end
  end
end
