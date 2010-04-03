require 'spec_helper'

include Outpost::Probe

describe Probe::Base do

  # Probe::Base has the following default rules handlers
  # ResponseCode, ResponseTime
  class ProbeExample < Probe::Base; end

  describe "when registering a new rules handler" do

    class DummyHandler
      def self.handle
        yield
        true
      end

      def self.rules_name
        :dummy
      end
    end

    it "should ignore classes that doesn't respond to rules_name" do
      (IncompleteDummyHandler = DummyHandler.dup).tap do |klass|
        remove_class_method(klass, :rules_name)
      end

      lambda {
        ProbeExample.register_rule_handler IncompleteDummyHandler
      }.should raise_error(InvalidHandlerError)

    end
    it "should ignore classes that doesn't respond to handle"
    it "should accept classes that respond to rules_name and handle"
  end

  describe "when registering default rules handlers" do
    subject {ProbeExample.handlers}

    it "should have response time in default handlers" do
      subject.should include({:response_time => RuleHandlers::ResponseTimeHandler})
    end

    it "should have response code in default handlers" do
      subject.should include({:response_code => RuleHandlers::ResponseCodeHandler})
    end
  end

  describe "reporting status" do
    it "should report :up when service is available"
    it "should report :warning when service is up but something's wrong"
    it "should report :down when service is not available"
  end

  def remove_class_method(klass, method_name)
    klass.instance_eval do
      class << self
        undef_method #{method_name}
      end
    end
  end
end
