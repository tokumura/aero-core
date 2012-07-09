# coding: utf-8
require 'spec_helper'

describe "categories/edit" do
  fixtures :categories
  before do
    @category = categories(:software)
  end

  it "カテゴリー名のテキストボックスが表示される。" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "category[name]", :value => @category.name)
    end
  end

  it "登録ボタンが表示される。" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "submit", :value => "　登　録　")
    end
  end
end
