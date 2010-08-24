require 'outpost/scout/hooks/response_time'
require 'outpost/scout/hooks/response_code'
require 'outpost/scout/consolidation'

class Scout::Base
  include Scout::Consolidation

  def before_measurement
  end

  def measure!
    before_measurement
    @response = execute
    after_measurement
  end

  def after_measurement
  end

  def build_report(rules)
    raise NotImplementedError
  end
end
