# coding: utf-8
require 'spec_helper'

describe "categories/index" do
  fixtures :categories
  before do
    @categories = Category.all
  end
  it "初期表示時、全カテゴリが表示されている" do
    render
    rendered.should have_content(categories(:software).name)
    rendered.should have_content(categories(:pc).name)
    rendered.should have_content(categories(:printer).name)
  end

  it "編集ボタンが表示されている" do
    render
    rendered.should have_content(" 編　集 ")
  end

  it "削除ボタンが表示されている" do
    render
    rendered.should have_content(" 削　除 ")
  end
end
