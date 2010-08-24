require 'spec_helper'

describe Scout::Hooks::ResponseCode do

  class ResponseCodeTest
    include Scout::Hooks::ResponseCode

    def initialize
      @response = 200
    end

    def consolidate(status_list)
      status_list
    end
  end

  describe "#build_report" do
    context "rule match" do
      subject { ResponseCodeTest.new.build_report(:response_code => [{200 => :up}]) }
      it { should == [ :up ] }
    end

    context "rule doesn't match" do
      subject { ResponseCodeTest.new.build_report(:response_code => [{404 => :down}]) }
      it { should == [ nil ] }
    end

    context "multiple rules" do
      subject { ResponseCodeTest.new.build_report(:response_code => [{200 => :up, 404 => :down}]) }
      it { should == [ :up, nil ] }
    end

    context "doesn't recognize params" do
      subject { ResponseCodeTest.new.build_report(:response_code => [{{:less_than => 100} => :down}]) }
      it { should == [ nil ] }
    end

    context "doesn't have hook key" do
      subject { ResponseCodeTest.new.build_report(:response_time => [{10 => :down}]) }
      it { should be_nil }
    end
  end

end
