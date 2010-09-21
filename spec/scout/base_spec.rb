require 'spec_helper'

module Scout
  describe Base do
    
    context '#down!' do
      before { @base = Base.new }
      
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