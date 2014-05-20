# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hensel/version'

Gem::Specification.new do |spec|
  spec.name          = "hensel"
  spec.version       = Hensel::VERSION
  spec.authors       = ["namusyaka"]
  spec.email         = ["namusyaka@gmail.com"]
  spec.summary       = %q{Hensel makes it easy to build the breadcrumbs.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/namusyaka/hensel"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "nyan-cat-formatter"
  spec.add_development_dependency "rspec-html-matchers"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-shell"
  spec.add_development_dependency "guard-rspec"
end
