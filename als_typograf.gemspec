# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'als_typograf/version'

Gem::Specification.new do |s|
  s.name        = %q{als_typograf}
  s.version     = AlsTypograf::VERSION
  s.authors     = ['Alexander Semyonov']
  s.email       = 'al@semyonov.us'
  s.homepage    = 'http://github.com/alsemyonov/als_typograf'
  s.summary     = 'ArtLebedevStudio.RemoteTypograf'
  s.description = 'Ruby client for ArtLebedevStudio.RemoteTypograf service'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)

  s.add_runtime_dependency('activesupport', ['>= 2.3.4'])
  s.add_development_dependency('activerecord', ['>= 2.3.4'])
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('rspec')
  s.add_development_dependency('yard')
end

