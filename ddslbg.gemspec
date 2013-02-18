# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ddslbg/version'

Gem::Specification.new do |gem|
  gem.name          = 'ddslbg'
  gem.version       = Ddslbg::VERSION
  gem.authors       = ['Bjørn Arild Mæland']
  gem.email         = ['bjorn.maeland@gmail.com']
  gem.description   = 'This library spawns a child process which communicates with the DDSL command line tool'
  gem.summary       = 'Ruby client which wraps ddsl-cmdline-tool'
  gem.homepage      = 'https://github.com/bmaland/ddslbg'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'awesome_print'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rb-fsevent'
end
