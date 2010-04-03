module Outpost
  module Probe
    module RuleHandlers

      # The +ResponseCodeRuleHandler+ is capable of handling
      # statuses with :response_code rules.
      #
      # It will simply compare the return of the block with the
      # reported code, e.g.:
      #
      # report :up, :responde_code => 200
      #
      # If the measurement returns "200", an OK event will be reported.
      #
      # TODO: Maybe support response codes like the following:
      # :non_zero
      # :negative
      # :positive
      # ...
      #
      class ResponseCodeHandler

        def self.handle(param, &block)
          response = block.call
          response.to_s == param.to_s
        end

        def self.rule_name
          :response_code
        end

      end

    end
  end
end
