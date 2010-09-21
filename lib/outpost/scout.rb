module Scout
  autoload :Base, 'outpost/scout/base'
  autoload :Message, 'outpost/scout/message'
  autoload :Consolidation, 'outpost/scout/consolidation'

  module Hooks
    autoload :Base, 'outpost/scout/hooks/base'
    autoload :ResponseCode, 'outpost/scout/hooks/response_code'
    autoload :ResponseTime, 'outpost/scout/hooks/response_time'
  end

end