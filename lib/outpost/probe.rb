require 'outpost/probe/status_handler'
require 'outpost/probe/rule_handlers'


module Outpost
  module Probe

    # Outpost probes report statuses to their masters.
    #
    # When a probe is launched, it will poke the service in question
    # and will report a status to its master, defined by the +report+
    # rules.
    #
    # Examples:
    # class DatabaseProbe < Outpost::Probe::Base
    #   report :up,       :response_time => {:less_than => 3000}
    #   report :warning,  :response_time => {:more_than => 3000, :less_than => 5000}
    #   report :down,     :response_time => {:more_than => 5000}
    #   report :down,     :response_code => -1
    # end
    #
    # Available statuses are:
    # <tt>:up</tt> - Service up.
    # <tt>:warning</tt> - Service is up but something is not completely right.
    # <tt>:down</tt> - Service is down.
    #
    # Probes report statuses using a set of rules. Those rules are mainly the following:
    # <tt>:response_time</tt> - Measure a dummy request to a service
    # <tt>:response_code</tt> - Get the response code of a dummy request to a service
    #
    # See rules handlers for more information.
    #
    class Base
      include StatusHandler

      register_rule_handlers RuleHandlers::ResponseTimeHandler, RuleHandlers::ResponseCodeHandler

    end
  end
end
