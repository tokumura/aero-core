# coding: utf-8

Given /^一般ユーザーでログインする。$/ do
  @user = User.new(:username => 'okumura', :password => "123456", :admin => false, :department_id => 1)
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

When /^一般ユーザーで商品詳細画面を表示した場合、$/ do
  visit new_user_session_path
  fill_in "user_username", :with => "okumura"
  fill_in "user_password", :with => "123456"
  click_on "ログイン"
  visit product_path(1)
end

Then /^「編集」、「削除」リンクが表示されない。$/ do
  page.should_not have_content("編集")
  page.should_not have_content("削除")
end

