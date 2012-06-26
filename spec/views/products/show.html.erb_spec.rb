# coding: utf-8
require 'spec_helper'

describe "products/show.html.erb" do

  fixtures :categories, :departments, :products, :categories_products, :departments_products, :relations

  before do
    user = double('user')
    controller.stub(:current_user) { user }
    user.stub(:admin?) { true }

    @product = Product.find(1)

    @department_name = Array.new(@product.departments.size)
    @product.departments.each do |d|
      department = Department.find(d.id)
      @department_name << department.name
    end

    @category_name = Array.new(@product.categories.size)
    @product.categories.each do |c|
      category = Category.find(c.id)
      @category_name << category.name
    end
  end

  it "商品名'LBP9100'が表示される。" do
    render
    rendered.should have_content("LBP9100")
  end

  it "価格'50000'が表示される。" do
    render
    rendered.should have_content("50,000円")
  end
  it "部署名'フィールドサポート'が表示される。" do
    render
    rendered.should have_content("フィールドサポート")
  end

  it "カテゴリが表示される。" do
    render
    rendered.should have_content("プリンター")
  end

  it "管理者ユーザーの場合、「編集」「削除」リンクが表示される。" do
    render
    rendered.should have_content("編　集")
    rendered.should have_content("削　除")
  end

  it "管理者ユーザーの場合、「編 集」「削 除」リンクが表示されない。" do
    user = double('user')
    controller.stub(:current_user) { user }
    user.stub(:admin?) { false }
    render
    rendered.should_not have_content("編　集")
    rendered.should_not have_content("削　除")
  end
=begin
=end
end
