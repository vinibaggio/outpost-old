require 'spec_helper'

module Server
  describe SSH do
  
    before do
      @server = server('@outpost')
      @options = { :password => nil, :auth_methods => %w(publickey hostbased), :config => false }
      Net::SSH.stub!(:configuration_for).and_return({})
    end
  
    it 'connect with the server should only do it once' do
      Net::SSH.should_receive(:start).with(@server.host, @server.user, @options).and_return(success=Object.new)
      Server::SSH.connect(@server).should == success
    end
    
    it "connect with server via public key should pass user to net ssh" do
      Net::SSH.should_receive(:start).with(@server.host, 'batman', @options).and_return(success=Object.new)
      Server::SSH.connect(@server, :user => 'batman').should == success
    end
    
    it "connect with user should pass user to net ssh" do
      server = server('joker@my_server.test')
      Net::SSH.should_receive(:start).with(server.host, 'joker', @options).and_return(success=Object.new)
      Server::SSH.connect(server).should == success
    end
    
    it "should pass port to net ssh" do
      server = server('joker@my_server:4050')
      Net::SSH.should_receive(:start).with(server.host, 'joker', @options.merge({:port => 4050})).and_return(sucess=Object.new)
      Server::SSH.connect(server).should == sucess
    end
    
    it "should pass port in ssh options" do
      @server.stub!(:user).and_return('default-user')
      Net::SSH.should_receive(:start).with(@server.host, 'default-user', @options.merge({:port => 4050})).and_return(sucess=Object.new)
      Server::SSH.connect(@server, :port => 4050).should == sucess
    end
    
    it "should try to connect with the server with the public and after failing should try password" do
      @server.stub!(:user).and_return('default-user')
      Net::SSH.stub!(:start).with(@server.host, "default-user", @options).and_raise(Net::SSH::AuthenticationFailed)
      Net::SSH.should_receive(:start).with(@server.host, "default-user", @options.merge(:password => "secret", :auth_methods => %w(password keyboard-interactive))).and_return(success = Object.new)
      Server::SSH.connect(@server, :password => "secret").should == success
    end
    
    it "should raise an error when failing all the auth methods" do
      @server.stub!(:user).and_return('default-user')
      Net::SSH.should_receive(:start).with(@server.host, "default-user", @options).and_raise(Net::SSH::AuthenticationFailed)
      Net::SSH.should_receive(:start).with(@server.host, "default-user", @options.merge(:password => "secret", :auth_methods => %w(password keyboard-interactive))).and_raise(Net::SSH::AuthenticationFailed)
      lambda { 
        Server::SSH.connect(@server, :password => "secret") 
      }.should raise_exception(Net::SSH::AuthenticationFailed)
    end
    
  end
end