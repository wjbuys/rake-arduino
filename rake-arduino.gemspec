# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rake/arduino/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jacob Buys"]
  gem.email         = ["wjbuys@gmail.com"]
  gem.summary       = %q{Flexible build system for Arduino projects.}
  gem.description   = %q{rake-arduino allows you to easily build Arduino sketches using Rake.}
  gem.homepage      = "https://github.com/wjbuys/rake-arduino"
  gem.license       = "MIT"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.name          = "rake-arduino"
  gem.require_paths = ["lib"]
  gem.version       = Rake::Arduino::VERSION

  gem.add_dependency "rake"
end
