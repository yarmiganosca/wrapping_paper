# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wrapping_paper/version'

Gem::Specification.new do |gem|
  gem.name          = "wrapping_paper"
  gem.version       = WrappingPaper::VERSION
  gem.authors       = ["Chris Hoffman"]
  gem.email         = ["yarmiganosca@gmail.com"]
  gem.description   = "Wrap your Ruby objects in shiny clothes!"
  gem.summary       = "A dirt simple Ruby implementation of the Presenter pattern."
  gem.homepage      = "https://github.com/yarmiganosca/wrapping_paper"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
