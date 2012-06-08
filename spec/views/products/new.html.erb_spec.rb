# coding: utf-8
require 'spec_helper'

describe "products/new.html.erb" do
  fixtures :departments, :products
  before do
    @product = Product.new
    @departments = Department.all
    @categories = Category.all
  end
  it "商品名のテキストボックス(空)が表示される。" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "product[name]")
    end
  end
  it "部署チェックボックスが表示される。" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "checkbox", :name => "department_param[]")
    end
  end
  it "カテゴリラジオボタンが表示される。" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "radio", :name => "category_param")
    end
  end

=begin
=end
end
