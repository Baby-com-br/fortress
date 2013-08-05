# encoding: utf-8
module Fortress
  class Runner
    attr_reader :suite

    def initialize(config_file_path)
      @suite = Suite.new config_file_path
    end

    def run(output_stream = STDOUT)
      suite.run

      if suite.all_passing?
        output_stream << "Congrats, you have a fast application!\n"
      else
        output_stream << "It looks like something is slowing you down...\n"
        suite.print_failed_tests(output_stream)
      end
    end

    def all_passing?
      suite.all_passing?
    end
  end
end
