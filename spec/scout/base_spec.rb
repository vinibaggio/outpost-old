require 'spec_helper'

module Scout
  describe Base do
    before { @base = Base.new }

    describe '.add_hook' do
      let(:hooks) { Base.class_variable_get(:@@hooks) }
      
      it "should return a empty array when not have hooks" do
        hooks.should == []
      end
      
      it "should add the hook class" do
        Base.add_hook(Scout::Hooks::ResponseTime)
        hooks.should == [Scout::Hooks::ResponseTime]
      end
      
    end

    describe '#measure!' do
      
      it "should call #execute method on Scout" do
        @base.should_receive(:execute).and_return(0)
        @base.measure!
      end
      
    end


    describe '#message' do
      
      it "should return a instance of Message" do
        @base.message.should be_instance_of(Message)
      end
      
    end
    
    describe '#down!' do
      
      it "should assign the :down status" do
        @base.down!
        @base.status.should equal :down
      end
      
      it "should assign force status" do
        @base.down!
        @base.force_status.should equal :down
      end
      
    end
    
  end
end