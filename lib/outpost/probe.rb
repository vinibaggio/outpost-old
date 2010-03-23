require 'outpost/probe/status_handler'
require 'outpost/probe/rules_handlers'


module Outpost
  module Probe
  
    class OutpostError < Exception; end
  
    class InvalidStatusError < OutpostError; end
  
    include RulesHandler

    class Base
    
      include StatusHandler
    
    end
  end
end
