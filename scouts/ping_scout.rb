require 'outpost/scout/basic_hooks'

require 'net/ping'

class PingScout < Scout::Base

  def initialize(options = {})
    @host     = options[:host]     || 'localhost'
  end

  def execute(ping_service=Net::Ping::External)
    external = ping_service.new(@host)
    if external.ping
      @message = "Ping on host '#{@host}' successful, duration #{external.duration}"
      external.ping?
    else
      @message = "Ping on host '#{@host}' failed!"
      down!
    end

  end

end
