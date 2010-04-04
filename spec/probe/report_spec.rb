require 'spec_helper'

describe Outpost::Probe::Report do
  subject { Outpost::Probe::Report.new }

  describe "when reporting status with only one handler that returns true" do

    it "should report up" do
      subject.add(report_mock(:up), handler_mock)
      subject.should be_up
    end

    it "should report warning" do
      subject.add(report_mock(:warning), handler_mock)
      subject.should be_warning
    end

    it "should report down" do
      subject.add(report_mock(:down), handler_mock)
      subject.should be_down
    end
  end

  describe "when reporting status with multiple reports" do
    it "return warning status when having up and warning" do
      subject.add(report_mock(:warning), handler_mock)
      subject.add(report_mock(:up), handler_mock)
      subject.should be_warning
    end

    it "return warning status when having up and warning, changing the order" do
      subject.add(report_mock(:up), handler_mock)
      subject.add(report_mock(:warning), handler_mock)
      subject.should be_warning
    end

    it "should return down status when having up and down statuses" do
      subject.add(report_mock(:down), handler_mock)
      subject.add(report_mock(:up), handler_mock)
      subject.should be_down
    end

    it "should return down status when having up and down statuses, changing the order" do
      subject.add(report_mock(:up), handler_mock)
      subject.add(report_mock(:down), handler_mock)
      subject.should be_down
    end

    it "should return down status when having all statuses, independent of order" do
      subject.add(report_mock(:down), handler_mock)
      subject.add(report_mock(:warning), handler_mock)
      subject.add(report_mock(:up), handler_mock)
      subject.should be_down
    end
  end

  it "should ignore reports when handler does not pass" do
    subject.add(report_mock(:down), handler_mock(false))
    subject.should be_up
  end

  describe "when registering messages" do
    it "should store the message of the status" do
      subject.add(report_mock(:up), handler_mock(true, "response is ok"))
      subject.report_messages.should == ['response is ok']
    end

    it "should store the message of the worst status as report message" do
      subject.add(report_mock(:up), handler_mock(true, "response is ok"))
      subject.add(report_mock(:down), handler_mock(true, "system failure"))

      subject.report_messages.should == ['system failure']
    end

    it "should store all messages" do
      subject.add(report_mock(:up), handler_mock(true, "response is ok"))
      subject.add(report_mock(:down), handler_mock(true, "system failure"))

      subject.all_messages.should == ['response is ok', 'system failure']
    end

    it "should store multiple messages if statuses are being repeated" do
      subject.add(report_mock(:down), handler_mock(true, "omg fail"))
      subject.add(report_mock(:down), handler_mock(true, "system failure"))

      subject.report_messages.should == ['omg fail', 'system failure']
    end

  end

  def handler_mock(returns=true, message=nil)
    mock.tap do |m|
      m.stub(:handle).with(nil).once.and_return(returns)
      m.stub(:message).once.and_return(message) if message
    end
  end

  def report_mock(status)
    {:status => status, :rule_params => nil}
  end
end
