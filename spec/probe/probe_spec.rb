require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include Outpost
include Outpost::Probe::RulesHandler

describe Probe do

  class ProbeExample < Probe::Base; end


  describe "rules handlers" do

    class DummyHandler
      def self.handle
        yield
        true
      end

      def self.rules_name
        :dummy
      end
    end

    it "should have response time in default handlers" do
      ProbeExample.handlers.should include([ResponseTimeRulesHandler, ResponseCodeRulesHandler])
    end
    it "should have response code in default handlers"
    it "should ignore classes that doesn't respond to rules_name and handle"
    it "should accept classes that respond to rules_name and handle"
  end


  describe "reporting status" do
    it "should report :up when service is available"
    it "should report :warning when service is up but something's wrong"
    it "should report :down when service is not available" 
  end


end
