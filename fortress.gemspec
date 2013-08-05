# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fortress/version'

Gem::Specification.new do |spec|
  spec.name          = "fortress"
  spec.version       = Fortress::VERSION
  spec.authors       = ["Cássio Marques"]
  spec.email         = ["cassio.marques@baby.com.br"]
  spec.description   = %q{Fortress automates load testing, using `siege` and defining throughtput limits for each tested endpoint. If the throughput is less than the specified, the test fails}
  spec.summary       = %q{A good fortress can resist a siege}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-debugger"
  spec.add_development_dependency "pry-doc"
end
