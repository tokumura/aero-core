# coding: utf-8
require 'spec_helper'

describe "products/index.html.erb" do
  fixtures :users, :categories, :departments, :products, :departments_products
  before do
    user = double('user')
    controller.stub(:current_user) { user }
    user.stub(:admin?) { true }

    @user = User.find(users(:higashino).id)
    @departments_products = DepartmentsProducts.find_all_by_department_id(@user.department.id)
    @products = Array.new(0)
    @departments_products.each do |dp|
      product = Product.find(dp.product_id)
      @products << product
    end
    @departments = Department.all
    @categories = Category.all
    @sort = "name_asc"
    @selected_department_id = 1
  end

  it "初期表示時、自部署で絞り込みされている。(F/Sの場合、500Aは表示されない）" do
    render
    rendered.should have_content("LBP9100")
    rendered.should have_content("LBP3100")
    rendered.should_not have_content("500A")
  end

=begin
  it "" do
    render
    rendered.should have_content("")
  end
=end
end
