# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rake/arduino/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jacob Buys"]
  gem.email         = ["wjbuys@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.name          = "rake-arduino"
  gem.require_paths = ["lib"]
  gem.version       = Rake::Arduino::VERSION

  gem.add_dependency "rake"
end
