# -*- encoding: utf-8 -*-
require 'spec_helper'

describe AlsTypograf do
  def self.process_assertions(assertions)
    assertions.each do |from, to|
      it "process [#{from}] to [#{to}]" do
        AlsTypograf.process(from).should == to
      end
    end
  end

  context '.default_options!' do
    before { AlsTypograf.default_options! }

    process_assertions({
                         '- Это "Типограф"?' => "<p>— Это «Типограф»?<br />\n</p>",
                       })
  end

  context '.use_p == false' do
    before { AlsTypograf.use_p = false }

    process_assertions({
                         '- Это "Типограф"?' => '— Это «Типограф»?<br />',
                       })
  end
end
