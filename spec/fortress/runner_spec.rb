# encoding: utf-8
require 'spec_helper'

describe Fortress::Runner do
  subject(:runner)    { described_class.new path }
  let(:suite)         { double(:suite).as_null_object }
  let(:path)          { "/some/path" }
  let(:output_stream) { "" }

  before do
    Fortress::Suite.stub(:new).and_return(suite)
  end

  def run
    runner.run output_stream
  end

  it "is initialized with the path for a configuration file" do
    Fortress::Suite.should_receive(:new).with(path).and_return(suite)
    described_class.new path
  end

  it "runs the suite" do
    suite.should_receive(:run)
    run
  end

  context "when all tests pass" do
    before { suite.stub(:all_passing? => true) }

    it "does not print failing tests" do
      suite.should_not_receive(:print_failed_tests)
      run
    end

    it "prints a success message" do
      run
      output_stream.should == "Congrats, you have a fast application!"
    end
  end

  context "when there are failing tests" do
    before { suite.stub(:all_passing? => false) }

    it "prints the failing tests" do
      suite.should_receive(:print_failed_tests)
      run
    end

    it "prints a failure message" do
      run
      output_stream.should == "It looks like something is slowing you down..."
    end
  end

  it "is possible to check the run result" do
    suite.stub(:all_passing? => true)
    run
    runner.should be_all_passing
  end
end
