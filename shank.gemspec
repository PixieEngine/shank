# -*- encoding: utf-8 -*-
require File.expand_path('../lib/shank/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "shank"
  gem.version       = Shank::VERSION
  gem.authors       = ["Matt Diebolt", "Daniel X. Moore"]
  gem.email         = ["pixie@pixieengine.com"]
  gem.homepage      = "https://github.com/PixieEngine/Shank"
  gem.summary       = %q{Sometimes you gotta stab someone to make a game}
  gem.description   = %q{Polyfills for making games in the browser}

  gem.files         = `git ls-files`.split("\n")
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rake"

  gem.add_dependency "sprockets"
end
