require 'outpost/scout/basic_hooks'

require 'mysql'

class MysqlScout < Scout::Base
  add_hook Scout::Hooks::ResponseTime
  add_hook Scout::Hooks::ResponseCode

  attr_accessor :host, :username, :password, :db, :port

  def initialize(options = {})
    @host     = options[:host]     || 'localhost'
    @username = options[:username] || 'root'
    @password = options[:password] || ''
    @db       = options[:db]       || ''
    @port     = options[:port]     || 1186
  end

  def execute
    connected do |conn|
      @message = conn.client_info
    end
    0
  rescue StandardError => e
    down!
    @message = e.to_s
  end

  protected
  def connected(&block)
    conn = Mysql.connect(@host, @username, @password, @db, @port)
    yield conn
    conn.close
  end

end
