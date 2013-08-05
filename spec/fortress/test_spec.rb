# encoding: utf-8
require 'spec_helper'

describe Fortress::Test do
  subject(:test) { described_class.new configuration }

  let(:configuration) { {
    "name"                      => "My example test",
    "url"                       => "http://my-example-test",
    "expected_transaction_rate" => expected_transaction_rate,
    "concurrent_users"          => 14,
    "test_duration"             => "10M"
  } }

  let(:expected_transaction_rate)  { 25 }

  let(:siege_output) {
    <<OUTPUT
Lifting the server siege...      done.

Transactions:                     12 hits
Availability:                 100.00 %
  Elapsed time:                   9.97 secs
Data transferred:               2.22 MB
Response time:                  1.73 secs
Transaction rate:               25.20 trans/sec
Throughput:                     30.22 MB/sec
Concurrency:                    2.08
Successful transactions:          12
Failed transactions:               0
Longest transaction:            2.26
Shortest transaction:           0.88
OUTPUT
  }

  before do
    test.stub(:` => siege_output)
  end

  its(:name)                      { should == "My example test" }
  its(:url)                       { should == "http://my-example-test" }
  its(:expected_transaction_rate) { should == 25 }
  its(:concurrent_users)          { should == 14 }
  its(:test_duration)             { should == "10M" }

  describe "#run" do
    it "runs the external command with the correct options" do
      test.should_receive(:`).with("siege -c14 -t10M http://my-example-test").and_return(siege_output)
      test.run
    end

    context "when the result transaction rate is less than the expected one" do
      let(:expected_transaction_rate) { 30 }

      it "returns false" do
        test.run.should == false
      end

      it "fails" do
        test.run
        test.should have_failed
      end
    end

    context "when the result transaction rate is greater than the expected one" do
      let(:expected_transaction_rate) { 25 }

      it "returns true" do
        test.run.should == true
      end

      it "passes" do
        test.run
        test.should_not have_failed
      end
    end

    context "when the result transaction rate is equal to the expected one" do
      let(:expected_transaction_rate) { 25.2 }

      it "returns true" do
        test.run.should == true
      end

      it "passes" do
        test.run
        test.should_not have_failed
      end
    end

    context "when the external command exited with success" do
      it "returns true" do
        test.run.should == true
      end

      it "passes" do
        test.run
        test.should_not have_failed
      end
    end

    context "when the external command exit code didn't exit with success" do
      before { $?.stub(:success? => false) }

      it "returns false" do
        test.run.should == false
      end

      it "fails" do
        test.run
        test.should have_failed
      end
    end
  end

  describe "#print_fail" do
    let(:stream) { "" }

    context "when the test has failed" do
      let(:expected_transaction_rate) { 50 }

      it "prints the error to the given stream" do
        test.run
        expect {
          test.print_failure(stream)
        }.to change { stream }.to("Expected a transaction rate of 50, got 25.2")
      end
    end

    context "when the test has not failed" do
      let(:expected_transaction_rate) { 5 }

      it "does not print anything to the given stream" do
        test.run
        expect { test.print_failure(stream) }.to_not change { stream }
      end
    end
  end
end
