# -*- encoding: utf-8 -*-
require 'spec_helper'
require 'active_model/typograf'

describe ActiveModel::Typograf do
  class Article < ActiveRecord::Base
    typograf(:content)
    typograf(:title => {:use_p => false, :use_br => false})
    typograf(:skills, :achievements, :description, :use_br => false)
  end

  subject { Article }

  it 'have class method #typograf' do
    Article.should respond_to(:typograf)
  end
  %w(typograf_fields typograf_current_fields).each do |field|
    it "have instance method \##{field}" do
      Article.new.should respond_to(field)
    end
  end

  it 'load schema correctly' do
    Article.all.should == []
  end

  context 'with an Article' do
    before do
      @article = Article.create(:title => '- Does it "Article"?',
                                :content => 'Да, это - "Статья"...')
      AlsTypograf.default_options!
    end

    subject { @article }

    its(:content) { should == "<p>Да, это — «Статья»...<br />\n</p>" }
    its(:title) { should == '— Does it «Article»?' }
  end
end
