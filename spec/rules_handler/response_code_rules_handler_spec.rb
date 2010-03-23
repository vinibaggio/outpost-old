require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ResponseCodeRulesHandler do

  subject {ResponseCodeRulesHandler}

  it "should report when response code is equal to requested" do
    subject.handle(200) {200}.should be_true
  end

  it "should not report when response code is different to requested" do
    subject.handle(200) {500}.should be_false
  end

  it "should report type-agnostic" do
    subject.handle("200") {200}.should be_true
    subject.handle(200) {"200"}.should be_true
  end
  
  it "should return :response_code as rule name" do
    subject.rule_name.should == :response_code
  end

end
