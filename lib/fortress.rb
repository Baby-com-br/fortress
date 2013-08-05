$:.unshift File.expand_path(File.dirname(__FILE__))

require "fortress/version"

module Fortress
  autoload :Parser, "fortress/parser"
end
