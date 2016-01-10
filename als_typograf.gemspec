# coding: utf-8
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'als_typograf/version'

Gem::Specification.new do |s|
  s.name = 'als_typograf'
  s.version = AlsTypograf::VERSION
  s.authors = ['Alexander Semyonov']
  s.email = 'al@semyonov.us'
  s.homepage = 'http://github.com/alsemyonov/als_typograf'
  s.summary = 'ArtLebedevStudio.RemoteTypograf'
  s.description = 'Ruby client for ArtLebedevStudio.RemoteTypograf service'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = %w(lib)

  s.add_runtime_dependency('activesupport', '>= 4.2.5')

  s.add_development_dependency('activerecord')
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rspec-its')
  s.add_development_dependency('yard')
  s.add_development_dependency('rake')
  s.add_development_dependency('roodi')
  s.add_development_dependency('codeclimate-test-reporter')
end
