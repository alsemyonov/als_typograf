require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'redgreen' rescue nil

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
