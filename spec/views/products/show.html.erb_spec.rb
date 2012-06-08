# coding: utf-8
require 'spec_helper'

describe "products/show.html.erb" do
  fixtures :departments, :products
  before do
    @product = Product.find(1)
  end
  it "商品名'LBP9100'が表示される。" do
    render
    rendered.should have_content("LBP9100")
  end
  it "価格'50000'が表示される。" do
    render
    rendered.should have_content("50000")
  end
=begin
  it "部署名'フィールドサポート'が表示される。" do
    render
    rendered.should have_content("フィールドサポート")
  end

  it "所属部署のラジオボタンが表示される。" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "radio", :name => "product[department_id]")
    end
  end
=end
end
