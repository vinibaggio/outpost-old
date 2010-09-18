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
    Net::HTTP.get_response(@host, @path, @port).code.to_i
  rescue StandardError
    nil
  end
end