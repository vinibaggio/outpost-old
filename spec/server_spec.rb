require 'spec_helper'

describe Server do
  
  describe '#initialize' do
    
    context 'when do not have credentials or port' do
      let(:server) { Server.new('www.outpost.test') }
      
      it { server.host.should == "www.outpost.test" }
      
      it { server.port.should be_nil }
      
      it { server.user.should be_nil }
    end
    
    context 'with user credentials' do
      let(:server) { Server.new('batman@www.outpost.test') }
      
      it { server.host.should == 'www.outpost.test' }
      
      it { server.user.should == 'batman'}
      
      it { server.port.should be_nil}
    end
    
    context 'with port and without a user' do
      let(:server) { Server.new('www.outpost.test:5080') }
      
      it { server.host.should == 'www.outpost.test' }
      
      it { server.user.should be_nil }
      
      it { server.port.should == 5080 }
      
    end
    
    context 'with user credentials and port' do
      let(:server) { Server.new('joker@www.gotham.test:8080')}
      
      it { server.host.should == 'www.gotham.test'}
      
      it { server.user.should == 'joker'}
      
      it { server.port.should == 8080 }
    end
    
    context 'with user as option' do
      let(:server) { Server.new('www.gotham.city', :user => 'harlequina')}
      
      it { server.host.should == 'www.gotham.city'}
      
      it { server.user.should == 'harlequina' }
      
      it { server.port.should be_nil }

    end
    
    context 'with port as option' do
      let(:server) { Server.new('gotham.city', :port => 3000)}
      
      it { server.host.should == 'gotham.city' }
      
      it { server.port.should == 3000 }
      
      it { server.user.should be_nil }
      
    end
    
  end
  
end