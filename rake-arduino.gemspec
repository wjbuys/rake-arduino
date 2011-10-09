# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rake/arduino/version', __FILE__)

Gem::Specification.new do |gem|
  gem.platform      = Gem::Platform::RUBY
  gem.name          = "rake-arduino"
  gem.version       = Rake::Arduino::VERSION
  gem.summary       = %q{Flexible build system for Arduino projects.}
  gem.description   = %q{rake-arduino allows you to easily build Arduino sketches using Rake.}

  gem.author        = "Jacob Buys"
  gem.email         = "wjbuys@gmail.com"
  gem.homepage      = "https://github.com/wjbuys/rake-arduino"
  gem.license       = "MIT"

  gem.files         = Dir["{lib,examples}/**/*", "MIT-LICENSE", "README.md"]
  gem.require_path  = "lib"

  gem.add_dependency "rake"
end
