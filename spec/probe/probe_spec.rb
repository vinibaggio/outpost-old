require 'spec_helper'

include Outpost::Probe

describe Probe::Base do

  # Probe::Base has the following default rules handlers
  # ResponseCode, ResponseTime
  class ProbeExample < Probe::Base;
    report :up, :response_code => 1
    report :warning, :response_code => 0
    report :down, :response_code => -1

    def measure(status)
      measure_status { status }
    end
  end

  describe "when registering a new rules handler" do

    class DummyHandler
      def handle(&block)
      end

      def rule_name
        :dummy
      end
    end

    it "should ignore classes that doesn't respond to rules_name" do
      class NoRulesNameDummyHandler; def handle(&block); end; end;

      lambda {
        ProbeExample.register_rule_handler NoRulesNameDummyHandler
      }.should raise_error(InvalidHandlerError)
    end

    it "should ignore classes that doesn't respond to handle" do
      class NoHandleDummyHandler; def rules_name; end; end;

      lambda {
        ProbeExample.register_rule_handler NoHandleDummyHandler
      }.should raise_error(InvalidHandlerError)
    end

    it "should accept classes that respond to rules_name and handle" do
      lambda {
        ProbeExample.register_rule_handler DummyHandler
      }.should_not raise_error(InvalidHandlerError)
      ProbeExample.handlers[:dummy].should be_instance_of(DummyHandler)
    end
  end

  describe "when registering default rules handlers" do
    subject {ProbeExample.handlers}

    it "should have response time in default handlers" do
      subject[:response_time].should be_instance_of(RuleHandlers::ResponseTimeHandler)
    end

    it "should have response code in default handlers" do
      subject[:response_code].should be_instance_of(RuleHandlers::ResponseCodeHandler)
    end
  end

  describe "when reporting status" do
    subject { ProbeExample.new }

    it "should report :up when service is available" do
      subject.measure(1).should be_up
    end

    it "should report :warning when service is up but something's wrong" do
      subject.measure(0).should be_warning
    end

    it "should report :down when service is not available" do
      subject.measure(-1).should be_down
    end

  end

end
