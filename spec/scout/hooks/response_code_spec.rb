require 'spec_helper'

describe Scout::Hooks::ResponseCode do

  let(:response_code) { 200 }
  let(:hook) { described_class.new }

  describe "#build_report" do
    subject { hook.build_report(response_code, rule_list) }

    context "rule match" do
      let(:rule_list) { { :response_code => {200 => :up} } }
      it { should == [ :up ] }
    end

    context "rule match when boolean" do
      let(:response_code) { true }
      let(:rule_list) { { :response_code => {true => :up} } }
      it { should == [ :up ] }
    end

    context "rule doesn't match" do
      let(:rule_list) { { :response_code => {404 => :down} } }
      it { should == [ nil ] }
    end

    context "multiple rules" do
      let(:rule_list) { { :response_code => {200 => :up, 404 => :down} } }
      it { should == [ :up, nil ] }
    end

    context "doesn't recognize params" do
      let(:rule_list) { { :response_code => {{:less_than => 100} => :down} } }
      it { should == [ :unknown ] }
    end

    context "doesn't have hook key" do
      let(:rule_list) { { :response_time => {10 => :down} } }
      it { should be_nil }
    end
  end

end
