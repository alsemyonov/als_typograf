ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.join(File.dirname(__FILE__), '../../../..')

require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'redgreen' rescue nil
require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'als_typograf'

class Test::Unit::TestCase
  def self.process_assertions(assertions)
    assertions.each do |from, to|
      should "process '#{from}' to '#{to}'" do
        assert_equal to, process(from)
      end
    end
  end

  def process(text)
    AlsTypograf.process(text)
  end
end

def load_schema
  config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")

  db_adapter = ENV['DB']

  # no db passed, try one of these fine config-free DBs before bombing.
  db_adapter ||=
    begin
      require 'rubygems'
      require 'sqlite'
        'sqlite'
    rescue MissingSourceFile
      begin
        require 'sqlite3'
          'sqlite3'
      rescue MissingSourceFile
      end
    end

  if db_adapter.nil?
    raise "No DB Adapter selected. Pass the DB= option to pick one, or install Sqlite or Sqlite3."
  end

  ActiveRecord::Base.establish_connection(config[db_adapter])
  load(File.dirname(__FILE__) + "/schema.rb")
  require File.dirname(__FILE__) + '/../rails/init.rb'
end

