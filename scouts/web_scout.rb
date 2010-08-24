$LOAD_PATH.unshift File.expand_path('./lib')

require 'rubygems'
require 'outpost'

require 'net/http'

class WebScout < Scout::Base
  include Scout::Hooks::ResponseTime
  include Scout::Hooks::ResponseCode

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

  protected
  def connected(&block)
    conn = Mysql.connect(@host, @username, @password, @db, @port)
    yield conn
    conn.close
  end

end


# scout = WebScout.new
# scout.measure!
