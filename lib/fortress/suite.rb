# encoding: utf-8
require "yaml"

module Fortress
  class Suite
    def initialize(configuration_file_path)
      @configuration_file_path = configuration_file_path
      @tests = []
      build_tests_list
    end

    def run
      @tests.each(&:run)
    end

    def tests
      @tests.freeze
    end

    def all_passing?
      @tests.none?(&:has_failed?)
    end

    def print_failed_tests(stream = STDOUT)
      @tests.find_all(&:has_failed?).each { |test| test.print_failure(stream) }
    end

    private

    def build_tests_list
      configuration.map(&:values).flatten.each { |test_config| @tests << Test.new(test_config) }
    end

    def configuration
      @configuration ||= begin
        file = File.open(@configuration_file_path, "r")
        YAML.load(file)
      end
    end
  end
end
