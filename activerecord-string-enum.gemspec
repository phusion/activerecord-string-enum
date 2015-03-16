# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord/string/enum/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-string-enum"
  spec.version       = Activerecord::StringEnum::VERSION
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

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
