# encoding: utf-8
require 'spec_helper'

describe Fortress::Parser do
  let(:parser) { described_class.new(output) }
  let(:output) {
    <<OUTPUT
Lifting the server siege...      done.

Transactions:                     12 hits
Availability:                 100.00 %
  Elapsed time:                   9.97 secs
Data transferred:               2.22 MB
Response time:                  1.73 secs
Transaction rate:               1.20 trans/sec
Throughput:                     0.22 MB/sec
Concurrency:                    2.08
Successful transactions:          12
Failed transactions:               0
Longest transaction:            2.26
Shortest transaction:           0.88
OUTPUT
  }

  it "parses the number of transactions" do
    parser.transactions.should == 12
  end

  it "parses the availability" do
    parser.availability.should == 100.00
  end

  it "parses the response time" do
    parser.response_time.should == 1.73
  end

  it "parses the transaction rate" do
    parser.transaction_rate.should == 1.20
  end

  it "parses the throughput" do
    parser.throughput.should == {:value => 0.22, :unit => "MB/sec"}
  end

  it "parses the concurrency" do
    parser.concurrency.should == 2.08
  end

  it "parses the number of failed transactions" do
    parser.failed_transactions.should == 0
  end

  it "parses the time of the longest transaction" do
    parser.longest_transaction.should == 2.26
  end

  it "parses the time of the shortest transaction" do
    parser.shortest_transaction.should == 0.88
  end
end
