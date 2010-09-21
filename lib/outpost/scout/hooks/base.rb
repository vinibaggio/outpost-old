module Scout::Hooks
  class Base
    include Scout::Consolidation

    protected

    def each_rule(all_rules, key)
      rules = all_rules.delete(key)
      status_list = []

      if rules
        status_list += rules.map do |rule, status|
          yield rule, status
        end

        status_list
      end
    end
  end
end
