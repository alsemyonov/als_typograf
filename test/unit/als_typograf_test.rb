# -*- coding: utf-8 -*-
require 'helper'

class AlsTypografTest < ActiveSupport::TestCase
  # TODO: need more tests or not?
  context 'with default configuration' do
    setup { AlsTypograf.default_options! }
    process_assertions({
      '- Это "Типограф"?' => "<p>— Это «Типограф»?<br />\n</p>",
    })
  end

  context 'no p' do
    setup { AlsTypograf.use_p = false }
    process_assertions({
      '- Это "Типограф"?' => "— Это «Типограф»?<br />",
    })
  end

end
