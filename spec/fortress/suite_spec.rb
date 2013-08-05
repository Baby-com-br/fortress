# encoding: utf-8
require 'spec_helper'

describe Fortress::Suite do
  let(:suite) { described_class.new configuration_file_path }
  let(:configuration_file_path) { File.join(File.dirname(__FILE__), "../fixtures/example_configuration_file.yaml") }
  let(:stub_test1) { double :run => true, :has_failed? => false }
  let(:stub_test2) { double :run => true, :has_failed? => false }
  let(:stub_test3) { double :run => true, :has_failed? => false }
  let(:stub_tests) { [stub_test1, stub_test2, stub_test3] }

  before do
    Fortress::Test.stub(:new).and_return(*stub_tests)
  end

  it "reads the configuration file to build a list of tests" do
    suite.tests.should have(3).items
  end

  describe "#run" do
    it "runs all tests" do
      stub_tests.each { |test| test.should_receive(:run) }
      suite.run
    end
  end

  describe "#all_passing?" do
    it "returns true if all tests are passing" do
      suite.all_passing?.should == true
    end

    it "returns false if at least one test is failing" do
      stub_test2.stub :has_failed? => true
      suite.all_passing?.should == false
    end
  end

  describe "#print_failed_tests" do
    it "prints the failed tests" do
      stub_test1.stub :has_failed? => true
      stub_test1.should_receive(:print_failure)
      stub_test2.should_not_receive(:print_failure)
      stub_test3.should_not_receive(:print_failure)
      suite.run
      suite.print_failed_tests
    end
  end
end
