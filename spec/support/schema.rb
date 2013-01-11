require 'active_record'
require 'logger'

config = YAML::load(File.read(File.join(SPEC_ROOT, 'spec/support/database.yml')))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')

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
      nil
    end
  end

if db_adapter.nil?
  raise 'No DB Adapter selected. Pass the DB= option to pick one, or install Sqlite or Sqlite3.'
end

ActiveRecord::Base.establish_connection(config[db_adapter])

ActiveRecord::Schema.define(:version => 0) do
  create_table :articles, :force => true do |t|
    t.string :title
    t.text :content, :skills, :achievements, :description,
      :foo, :bar, :baz
  end
end
