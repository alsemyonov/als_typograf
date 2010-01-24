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

  should_have_class_methods :typograf
  should_have_instance_methods :typograf_fields, :typograf_current_fields

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
      assert_equal "— Does it “Article”?", @article.title
    end
  end
end
