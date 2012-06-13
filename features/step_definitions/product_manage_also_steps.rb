# coding: utf-8

Given /^管理ユーザーでログインする。$/ do
  visit destroy_user_session_path
  @user = User.new(:username => 'admin', :password => "123456", :admin => false, :department_id => 1)
  @user.save!
  if @user.department_id
    @departments_products = DepartmentsProducts.find_all_by_department_id(@user.department.id)
    @products = Array.new(0)
    @departments_products.each do |dp|
      product = Product.find(dp.product_id)
      @products << product
    end
    @selected_department_id = @user.department.id
  else
    @products = Product.all
    @selected_department_id = "0"
  end
  @departments = Department.all
  @categories = Category.all
end

When /^管理ユーザーで商品詳細画面を表示した場合、$/ do
  visit new_user_session_path
  fill_in "user_username", :with => "admin"
  fill_in "user_password", :with => "123456"
  click_on "ログイン"
  visit make_admin_user_path(@user.id)
  visit product_path(1)
end

Then /^「編集」、「削除」リンクが表示される。$/ do
  page.should have_content("編集")
  page.should have_content("削除")
end

