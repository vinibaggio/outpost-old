require 'spec_helper'

module Server
  describe SSH do
  
    before do
      @server = server('outpost')
      @options = { :password => nil, :auth_methods => %w(publickey hostbased), :config => false }
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
    
  end
end