module Scout::Hooks
  class ResponseCode < Base

    def build_report(response, all_rules={})
      responses = each_rule(all_rules, :response_code) do |rule, status|
        if rule.is_a? Hash
          :unknown
        else
          status if rule == response
        end
      end
    end

  end
end
