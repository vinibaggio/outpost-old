module Outpost
  module Probe

    # General Outpost Error
    OutpostError        = Class.new(StandardError)
    InvalidStatusError  = Class.new(OutpostError)
  end
end
