module Outpost
  module Probe

    # General Outpost Error
    class OutpostError < StandardError; end

    class InvalidStatusError < OutpostError; end
  end
end
