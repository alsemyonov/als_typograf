$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'activerecord'
require 'shoulda'
require 'redgreen' rescue nil
require 'als_typograf'
require 'active_support/test_case'

class ActiveSupport::TestCase
  def self.process_assertions(assertions)
    assertions.each do |from, to|
      should "process '#{from}' to '#{to}'" do
        assert_equal to, AlsTypograf.process(from)
      end
    end
  end
end

def load_schema
  config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")

  db_adapter = ENV['DB']

  # no db passed, try one of these fine config-free DBs before bombing.
  db_adapter ||=
    begin
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

