require 'spec_helper'

include Outpost
include Outpost::Probe::RulesHandler

describe Probe do

  # Probe::Base has the following default rules handlers
  # ResponseCodeRulesHandler, ResponseTimeRulesHandler
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

    it "should ignore classes that doesn't respond to rules_name"
    it "should ignore classes that doesn't respond to handle"
    it "should accept classes that respond to rules_name and handle"
  end

  describe "when registering default rules handlers" do
    subject {ProbeExample.handlers}

    it "should have response time in default handlers" do
      subject.should include({:response_time => ResponseTimeRulesHandler})
    end

    it "should have response code in default handlers" do
      subject.should include({:response_code => ResponseCodeRulesHandler})
    end
  end

  describe "reporting status" do
    it "should report :up when service is available"
    it "should report :warning when service is up but something's wrong"
    it "should report :down when service is not available"
  end

end
