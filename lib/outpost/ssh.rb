module Server
  class SSH
        
    def self.connect(server, options={})
      strategies(server, options) do |host, user, connection_strategy|
        Net::SSH.start(host, user, connection_strategy)
      end
    end

    # Load All strategies to connect
    # Code adapted from Capistrano::SSH
    #
    # Load any SSH configuration files that were specified in the SSH options. This
    # will load from ~/.ssh/config and /etc/ssh_config by default (see Net::SSH
    # for details). Merge the explicitly given ssh_options over the top of the info
    # from the config.
    #
    # See http://net-ssh.rubyforge.org/ssh/v2/api/index.html for more details.
    #
    def self.strategies(server, options, &block)
      auth_methods = [ %w(publickey hostbased), %w(password keyboard-interactive) ] # Methods to handle authentication (for now I'm only using the first element)
      user = server.user || options[:user]
      host = server.host
      port = server.port
      ssh_options = Net::SSH.configuration_for(server.host, options.fetch(:config, true)).merge(options)
      ssh_options.delete(:user) # Don't need user in this Hash
      ssh_options[:port] = port if port
      password = nil
      begin
        yield host, user, ssh_options.merge(:auth_methods => auth_methods.shift, :password => password, :config => false)
      rescue Net::SSH::AuthenticationFailed
        raise Net::SSH::AuthenticationFailed if auth_methods.empty?
        password = options[:password]
        retry
      end
    end
    
  end
end