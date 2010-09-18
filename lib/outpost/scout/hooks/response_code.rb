require 'outpost/scout/hooks/base'

module Scout::Hooks
  class ResponseCode < Base

    def build_report(response, all_rules={})
      responses = each_rule(all_rules, :response_code) do |rule, status|
        if rule.is_a? Numeric or rule.is_a? String
          status if rule.to_i == response.to_i
        else
          :unknown
        end
      end
    end

  end
end
