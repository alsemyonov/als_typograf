require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'als_typograf'
    gem.summary = %Q{ArtLebedevStudio.RemoteTypograf}
    gem.description = %Q{ruby-implementation of ArtLebedevStudio.RemoteTypograf class (web-service client)}
    gem.email = 'rotuka@rotuka.com'
    gem.homepage = 'http://github.com/rotuka/als_typograf'
    gem.authors = ['Alexander Semyonov']
    gem.add_dependency 'activesupport', '>= 2.3.4'
    gem.add_dependency 'httparty', '>= 0.4.5'
    gem.add_development_dependency 'shoulda', '>= 0'
    gem.add_development_dependency 'yard', '>= 0'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort 'RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov'
  end
end

begin
  require 'reek/adapters/rake_task'
  Reek::RakeTask.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = 'lib/**/*.rb'
  end
rescue LoadError
  task :reek do
    abort 'Reek is not available. In order to run reek, you must: sudo gem install reek'
  end
end

begin
  require 'roodi'
  require 'roodi_task'
  RoodiTask.new do |t|
    t.verbose = false
  end
rescue LoadError
  task :roodi do
    abort 'Roodi is not available. In order to run roodi, you must: sudo gem install roodi'
  end
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort 'YARD is not available. In order to run yardoc, you must: sudo gem install yard'
  end
end

task :test => :check_dependencies
task :default => :test
desc 'Push release to github and gemcutter and install gem in the system'
task :push => %w(release gemcutter:release install)
