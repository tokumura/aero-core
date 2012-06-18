# coding: utf-8
require 'spec_helper'

describe "products/edit.html.erb" do
  fixtures :departments, :products
  before do
    @product = Product.new
    @departments = Department.all
    @categories = Category.all

    @category_names = Hash::new
    @categories.each do |c|
      @category_names[c.name] = c.id
    end

    @products = Product.all
    @product_names = Hash::new
    @products.each do |p|
      @product_names[p.name] = p.id
    end
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
