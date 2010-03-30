require 'outpost/probe/status_handler'
require 'outpost/probe/rules_handlers'

include Outpost::Probe::RulesHandler

module Outpost
  module Probe
    class Base
    
      include StatusHandler

      register_rule_handlers ResponseTimeRulesHandler, ResponseCodeRulesHandler
    
    end
  end
end
