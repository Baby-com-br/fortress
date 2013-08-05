$:.unshift File.expand_path(File.dirname(__FILE__))

require "fortress/version"

module Fortress
  autoload :Parser, "fortress/parser"
  autoload :Runner, "fortress/runner"
  autoload :Suite, "fortress/suite"
  autoload :Test, "fortress/test"
end
