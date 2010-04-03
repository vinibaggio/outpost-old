require "spec_helper"

describe ResponseTimeRulesHandler do

  subject { ResponseTimeRulesHandler }

  describe "when expecting more than a value" do
    it "should report when time is over" do
      subject.handle({:more_than => 300}) {sleep 0.4}.should be_true
    end

    it "should not report when time is under" do
      subject.handle({:more_than => 2000}) {}.should be_false
    end
  end


  describe "when expecting less than a value" do
    it "should report when time is under" do
      subject.handle({:less_than => 1000}) {}.should be_true
    end

    it "should not report when time is over" do
      subject.handle({:less_than => 100}) {sleep 0.2}.should be_false
    end
  end

  describe "when combining rules and estabilishes an interval" do
    it "should report when time is in between" do
      subject.handle({:more_than => 100, :less_than => 300}) {sleep 0.2}.should be_true
      subject.handle({:less_than => 300, :more_than => 100}) {sleep 0.2}.should be_true
    end

    it "should not report when time is out of the interval" do
      subject.handle({:more_than => 100, :less_than => 200}) {sleep 0.3}.should be_false
      subject.handle({:more_than => 1000, :less_than => 2000}) {}.should be_false
    end
  end

  describe "when combining rules to form bizarre intervals" do
    it "should not report when time doesn't satisfy all rules" do
      subject.handle({:more_than => 1000, :less_than => -1000}) {}.should be_false
    end

    it "should not report when time satisfy one rule but not all" do
      subject.handle({:more_than => 100, :less_than => -1000}) {sleep 0.2}.should be_false
    end
  end

  it 'should return :response_time as rule name' do
    subject.rule_name.should == :response_time
  end
end
