require 'outpost/scout/basic_hooks'

require 'net/http'

class WebScout < Scout::Base
  add_hook Scout::Hooks::ResponseTime
  add_hook Scout::Hooks::ResponseCode

  attr_accessor :host, :port

  def initialize(options = {})
    @host     = options[:host] || 'localhost'
    @path     = options[:path] || '/'
    @port     = options[:port] || 80
  end

  def execute
    @message = Net::HTTP.get_response(@host, @path, @port).code.to_i
  rescue StandardError => e
    down!
    @message = e.to_s
  end
end
