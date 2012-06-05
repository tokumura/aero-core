# coding: utf-8

Given /^ユーザーアカウントが一人以上存在する。$/ do
  @user = User.new(:username => 'okumura', :password => "123456", :admin => false)
  @user.save!
end

# ログイン成功シナリオ
When /^ログイン画面でID、パスワードを入力してログインした時、$/ do
  visit new_user_session_path
  fill_in "user_username", :with => "okumura"
  fill_in "user_password", :with => "123456"
  click_on "Sign in"
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
  click_on "Sign in"
end

Then /^ログインエラーとなり、エラーメッセージが表示される。$/ do
  page.should have_content("ログインエラー")
end

