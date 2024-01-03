# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/string_enum/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-string-enum"
  spec.version       = ActiveRecord::StringEnum::VERSION
  spec.authors       = ["Tinco Andringa"]
  spec.email         = ["tinco@phusion.nl"]
  spec.summary       = %q{Make ActiveRecord 4's Enum store as strings instead of integers.}
  spec.description   = %q{Make ActiveRecord 4's Enum store as strings instead of integers.}
  spec.homepage      = "https://github.com/phusion/activerecord-string-enum"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "activesupport", "6.1.7.3"
  spec.add_development_dependency "activerecord", "6.1.7.1"
  spec.add_development_dependency "erubis"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "simplecov"
end
