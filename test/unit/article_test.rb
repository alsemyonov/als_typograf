# -*- coding: utf-8 -*-
require 'helper'
require 'shoulda/active_record/matchers'
require 'shoulda/active_record/macros'

load_schema

class Article < ActiveRecord::Base
  typograf(:content)
  typograf(:title => {:use_p => false, :use_br => false})
  typograf(:skills, :achievements, :description, :use_br => false)
end

class ArticleTest < ActiveSupport::TestCase
  extend Shoulda::ActiveRecord::Macros

  should "have class method #typograf" do
    assert Article.respond_to?(:typograf)
  end
  %w(typograf_fields typograf_current_fields).each do |field|
    should "have instance method \##{field}" do
      assert Article.instance_methods.include?(field)
    end
  end

  should 'load schema correctly' do
    assert_equal [], Article.all
  end

  context 'with an Article' do
    setup do
      @article = Article.create(:title => '- Does it "Article"?',
                                :content => 'Да, это - "Статья"...')
      AlsTypograf.default_options!
    end

    should 'typograf article’s content with default options' do
      assert_equal "<p>Да, это — «Статья»...<br />\n</p>", @article.content
    end

    should 'typograf article’s title with custom options' do
      assert_equal "— Does it «Article»?", @article.title
    end
  end
end
