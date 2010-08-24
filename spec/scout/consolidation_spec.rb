require 'spec_helper'

describe Scout::Consolidation do
  class Example
    include Scout::Consolidation
  end
  subject { Example.new.consolidate(status_list) }

  describe "#consolidate" do
    context ":up" do
      let(:status_list) { [:up] }
      it { should == :up }
    end

    context "multiple :up's" do
      let(:status_list) { [:up] * 5 }
      it { should == :up }
    end

    context ":up and :warning" do
      let(:status_list) { [:up, :warning] }
      it { should == :warning }
    end

    context ":up and :down" do
      let(:status_list) { [:down, :up] }
      it { should == :down }
    end

    context ":warning and :down" do
      let(:status_list) { [:down, :warning] }
      it { should == :down }
    end

    context "nil and :up" do
      let(:status_list) { [nil, :up] }
      it { should == :up }
    end

    context "nil and :warning" do
      let(:status_list) { [nil, :warning] }
      it { should == :warning }
    end

    context "nil and :down" do
      let(:status_list) { [nil, :down] }
      it { should == :down }
    end

    context "only nil wrapped in a list" do
      let(:status_list) { [:nil] * 3 }
      it { should == :unknown }
    end

    context "only a nil" do
      let(:status_list) { nil }
      it { should == :unknown }
    end
  end
end
