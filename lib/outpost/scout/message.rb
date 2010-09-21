module Scout
  class Message
    attr_accessor :scout_name, :status, :message

    def initialize(scout_name, status, message)
      @scout_name, @status, @message = scout_name, status, message
    end

  end
end
