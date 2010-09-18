require 'spec_helper'

describe Scout::Hooks::ResponseTime do

  class ResponseTimeTest < Scout::Hooks::ResponseTime
    def initialize(execution_time)
      @execution_time = execution_time
    end
  end

  let(:response_time) { 1000 }
  let(:hook) { ResponseTimeTest.new(response_time) }

  describe "#build_report" do
    subject { hook.build_report(nil, rule_list) }

    context "rule :less_than match" do
      let(:rule_list) { { :response_time => {{:less_than => 1500} => :up} } }
      it { should == [ :up ] }
    end

    context "rule :more_than match" do
      let(:rule_list) { { :response_time => {{:more_than => 500} => :down} } }
      it { should == [ :down ] }
    end

    context "rule doesn't match" do
      let(:rule_list) { { :response_time => {{:less_than => 500} => :up} } }
      it { should == [ nil ] }
    end

    context "multiple rules" do
      let(:rule_list) { {
        :response_time => {
          {:less_than => 1500} => :up,
          {:more_than => 2000} => :down
        }
      } }

      it { should == [ :up, nil ] }
    end

    context "doesn't recognize params" do
      let(:rule_list) { { :response_time => {:foo => :down} } }
      it { should == [ nil ] }
    end

    context "doesn't have hook key" do
      let(:rule_list) { { :response_code => {10 => :down} } }
      it { should be_nil }
    end
  end

end

