require 'outpost/scout/hooks/base'

module Scout::Hooks
  class ResponseCode < Base

    def build_report(response, all_rules={})
      each_rule(all_rules, :response_code) do |rule, status|
        status if rule == response
      end
    end

  end
end
