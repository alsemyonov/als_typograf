require 'helper'

class TestAlsTypograf < Test::Unit::TestCase

  class Article < ActiveRecord::Base
  end

  # TODO: need more tests or not?
  context 'with default configuration' do
    setup { AlsTypograf.default_options! }
    process_assertions({
      '- Это "Типограф"?' => "<p>— Это «Типограф»?</p>",
    })
  end

  context 'no p' do
    setup { AlsTypograf.use_p = false }
    process_assertions({
      '- Это "Типограф"?' => "— Это «Типограф»?",
    })
  end

end
