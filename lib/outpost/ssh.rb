module Server
  class SSH
    
    def self.connect(server, options={})
      strategies(server, options) do |host, user, connection_strategy|
        Net::SSH.start(host, user, connection_strategy)
      end
    end

    #
    # Load any SSH configuration files that were specified in the SSH options. This
    # will load from ~/.ssh/config and /etc/ssh_config by default (see Net::SSH
    # for details). Merge the explicitly given ssh_options over the top of the info
    # from the config file.
    #
    # See http://net-ssh.rubyforge.org/ssh/v2/api/index.html for more details.
    #
    def self.strategies(server, options, &block)
      auth_methods = [ %w(publickey hostbased), %w(password keyboard-interactive) ]
      ssh_options = Net::SSH.configuration_for(server.host, options.fetch(:config, true)).merge(options)
      user = server.user || options[:user]
      host = server.host
      port = server.port
      ssh_options.delete(:user) # Don't need user in this Hash
      ssh_options[:port] = port if port
      yield host, user, ssh_options.merge(:auth_methods => auth_methods.pop,
        :password => nil, :config => false)
    end
    
  end
end