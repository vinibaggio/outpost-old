module Server
  class Configuration
    attr_reader :host, :port, :user
  
    def initialize(server, options={})
      @user, @host, @port = server.match(/^(?:([^;,:=]+)@|)(.*?)(?::(\d+)|)$/)[1,3]
      @user = options[:user] || @user
      @port = options[:port] || @port
      @port = @port ? @port.to_i : nil
    end
  end  
end