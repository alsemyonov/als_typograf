require 'helper'

class TestAlsTypograf < Test::Unit::TestCase
  # TODO: need more tests or not?
  context 'with default configuration' do
    setup { AlsTypograf.default_options! }
    process_assertions({
      '- Это "Типограф"?' => "<p>&#151; Это &laquo;Типограф&raquo;?</p>",
    })
  end

  context 'no p' do
    setup { AlsTypograf.p!(false) }
    process_assertions({
      '- Это "Типограф"?' => "&#151; Это &laquo;Типограф&raquo;?",
    })
  end
end
