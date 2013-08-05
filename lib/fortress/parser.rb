# encoding: utf-8
module Fortress
  class Parser
    attr_reader :output, :transactions, :availability, :response_time, :transaction_rate,
      :throughput, :concurrency, :failed_transactions, :longest_transaction, :shortest_transaction

    def initialize(output)
      @output               = output
      @transactions         = /Transactions:\s+(\d+)\s+hits/.match(output)[1].to_i
      @availability         = /Availability:\s+([\d\.]+)\s%/.match(output)[1].to_f
      @response_time        = /Response time:\s+([\d\.]+)\s/.match(output)[1].to_f
      @transaction_rate     = /Transaction rate:\s+([\d\.]+)\s/.match(output)[1].to_f
      throughput_matches    = /Throughput:\s+([\d\.]+)\s(.+)$/.match(output)
      @throughput           = {:value => throughput_matches[1].to_f, :unit => throughput_matches[2]}
      @concurrency          = /Concurrency:\s+([\d\.]+)$/.match(output)[1].to_f
      @failed_transactions  = /Failed transactions:\s+([\d\.]+)/.match(output)[1].to_i
      @longest_transaction  = /Longest transaction:\s+([\d\.]+)/.match(output)[1].to_f
      @shortest_transaction = /Shortest transaction:\s+([\d\.]+)/.match(output)[1].to_f
    end
  end
end
