module Outpost
  module Probe
    class OutpostError < StandardError; end

    class UnknownHandlerError < OutpostError; end
    class InvalidStatusError < OutpostError; end
  end
end
