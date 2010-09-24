require 'spec_helper'

describe Scout::Base do

  class ScoutTest < Scout::Base
  end

  subject { ScoutTest.new }

  describe "no hooks defined" do
    it "should raise NoHooksError" do
      lambda {
        subject.measure!
      }.should raise_error(Scout::NoHooksError)
    end
  end

end
