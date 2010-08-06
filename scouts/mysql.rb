$LOAD_PATH.unshift File.expand_path('./lib')

require 'rubygems'
require 'outpost'
require 'mysql'

class MysqlScout < Scout::Base
  include Scout::Hooks::ResponseTime
  include Scout::Hooks::ResponseCode

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
      puts conn.client_info
    end
  end

  protected
  def connected(&block)
    conn = Mysql.connect(@host, @username, @password, @db, @port)
    yield conn
    conn.close
  end

end


scout = MysqlScout.new
scout.measure!
