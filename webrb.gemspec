# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'webrb/version'

Gem::Specification.new do |spec|
  spec.name          = "webrb"
  spec.version       = Webrb::VERSION
  spec.authors       = ["wusuopu"]
  spec.email         = ["admin@longchangjin.cn"]
  spec.summary       = %q{A simple Web Framework.}
  spec.description   = %q{A simple Web Framework.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z | grep -v "^sample"`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "rack"
  spec.add_runtime_dependency "erubis"
  spec.add_runtime_dependency "multi_json"
  spec.add_runtime_dependency "sqlite3"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "test-unit"
end
