# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "doctordata/version"

Gem::Specification.new do |spec|
  spec.name          = "doctordata"
  spec.version       = Doctordata::VERSION
  spec.authors       = ["qsona"]
  spec.email         = ["mori.jmk@gmail.com"]

  spec.summary       = "master data tools"
  spec.description   = "master data tools"
  spec.homepage      = "https://github.com/qsona/doctordata"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "roo", "~> 2"
  spec.add_dependency "faraday", "~> 0.12"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
