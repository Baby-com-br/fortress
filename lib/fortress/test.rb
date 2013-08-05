# encoding: utf-8
module Fortress
  class Test
    attr_reader :name, :url, :expected_transaction_rate, :concurrent_users, :test_duration

    def initialize(configuration)
      @name                      = configuration["name"]
      @url                       = configuration["url"]
      @expected_transaction_rate = configuration["expected_transaction_rate"]
      @concurrent_users          = configuration["concurrent_users"]
      @test_duration             = configuration["test_duration"]
    end

    def run
      external_command_output  = run_external_command
      @parser                  = Parser.new external_command_output
      @failed                  = expected_transaction_rate <= @parser.transaction_rate && $?.success?
    end

    def has_failed?
      !@failed
    end

    def print_failure(stream)
      return if !has_failed? || @parser.nil?
      stream << "Test #{name}: Expected a transaction rate of #{expected_transaction_rate}, got #{@parser.transaction_rate}\n"
    end

    private

    def run_external_command
      `siege -c#{concurrent_users} -t#{test_duration} #{url} 2>&1`
    end
  end
end
