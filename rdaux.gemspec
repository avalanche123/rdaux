# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rdaux/version'

Gem::Specification.new do |spec|
  spec.name          = "rdaux"
  spec.version       = RDaux::VERSION
  spec.authors       = ["Bulat Shakirzyanov"]
  spec.email         = ["mallluhuct@gmail.com"]
  spec.description   = %q{RDaux creates beautiful documentation websites from markdown files.
It is inspired by daux.io and uses redcarpet with pygments.rb to process
github-flavored markdown files into beautiful documentation websites and
supports ASCII art with help of ditaa}
  spec.summary       = %q{RDaux creates beautiful documentation websites from markdown files}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'avalanche-cli', '= 0.1.0'
  spec.add_runtime_dependency 'redcarpet',     '= 3.0.0'
  spec.add_runtime_dependency 'pygments.rb',   '= 0.5.1'
  spec.add_runtime_dependency 'unicorn',       '= 4.6.2'
  spec.add_runtime_dependency 'tilt',          '= 1.4.1'
  spec.add_runtime_dependency 'sinatra',       '= 1.3.3'
  spec.add_runtime_dependency 'posix-spawn',   '= 0.3.6'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
