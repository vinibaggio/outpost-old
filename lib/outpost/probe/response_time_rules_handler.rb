module Outpost
  module Probe
    module RulesHandler

      # The +ResponseTimeRulesHandler+ is capable of handling
      # statuses with :response_time rules.
      #
      # It will report based on a set of rules passed to it. The
      # rules are:
      #
      # <tt>:less_than</tt> reports on time being less than the one specified
      # <tt>:more_than</tt> reports on time being more than the one specified
      #
      # They also can be combined in an AND fashion to form intervals.
      #
      # Examples
      #
      # report :up,      :responde_time => {:less_than => 1000}
      # report :warning, :responde_time => {:more_than => 1000, :less_than => 5000}
      # report :down,    :response_time => {:more_than => 5000}
      #
      class ResponseTimeRulesHandler

        OPERATIONS = {:less_than => '<', 
                      :more_than => '>'}.freeze

        def self.handle(params, &block)
          before_timer = Time.now
          block.call
          total_time_in_ms = (Time.now - before_timer) * 1000
          handle_time_diff(total_time_in_ms, params)
        end

        def self.rule_name
          :response_time
        end

        private
          def self.handle_time_diff(diff, rules)
            rules.each do |rule, val|
              condition = diff.send(OPERATIONS[rule], val)
              # Shortcut when false
              return false if condition == false
            end
            true
          end
      end

    end
  end
end
