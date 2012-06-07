# coding: utf-8
require 'spec_helper'

describe "products/new.html.erb" do
  fixtures :departments, :products
  before do
    @product = Product.new
  end
  it "商品名のテキストボックス(空)が表示される。" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "product[name]")
    end
  end

  it "所属部署のラジオボタンが表示される。" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "radio", :name => "product[department_id]")
    end
=begin
=end
  end
end
