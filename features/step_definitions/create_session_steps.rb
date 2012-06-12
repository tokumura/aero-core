# coding: utf-8
=begin
Before do
  Fixtures.create_fixtures("spec/fixtures", "categories")
  Fixtures.create_fixtures("spec/fixtures", "categories_products")
  Fixtures.create_fixtures("spec/fixtures", "departments")
  Fixtures.create_fixtures("spec/fixtures", "departments_products")
  Fixtures.create_fixtures("spec/fixtures", "products")
end
=end

Given /^ユーザーアカウントが一人以上存在する。$/ do
  @department = Department.new(:id=>1, :name=>'ORCA事業部')
  @department.save!
  @user = User.new(:username => 'okumura', :password => "123456", :admin => false, :department_id => 1)
  @user.save!
  @departments_products = DepartmentsProducts.new(:department_id=>1, :product_id=>1)
  @departments_products.save!
  @selected_department_id = 1

    @user = User.find(1)
    if @user.department_id
      @departments_products = DepartmentsProducts.find_all_by_department_id(@user.department.id)
      @products = Array.new(0)
      @departments_products.each do |dp|
        product = Product.find(dp.product_id)
        @products << product
      end
    else
      @products = Product.all
    end
    @departments = Department.all
end

# ログイン成功シナリオ
When /^ログイン画面でID、パスワードを入力してログインした時、$/ do
  visit new_user_session_path
  fill_in "user_username", :with => "okumura"
  fill_in "user_password", :with => "123456"
  click_on "ログイン"
end

Then /^ログインが成功し、商品一覧画面が表示される。$/ do
  page.should have_content("商品一覧")
  page.should have_content("okumura")
end

# ログインエラーのシナリオ
When /^ログイン画面で誤ったID、パスワードを入力してログインした時、$/ do
  visit new_user_session_path
  fill_in "user_username", :with => "abcdefg"
  fill_in "user_password", :with => "9999999"
  click_on "ログイン"
end

Then /^ログインエラーとなり、エラーメッセージが表示される。$/ do
  page.should have_content("ログインエラー")
end

