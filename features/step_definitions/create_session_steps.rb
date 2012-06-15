# coding: utf-8

Given /^ユーザーアカウントが一人以上存在する。$/ do
  @user = User.new(:username => 'okumura', :password => "123456", :admin => false, :department_id => 1)
  @user.save!
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

Given /^ゲストアカウントが作成済み。$/ do
  @user = User.new(:username => 'guest', :password => "guestpass", :admin => false, :department_id => 0)
  @user.save!
end

When /^ログイン画面で'ゲストログイン'をクリックした時、$/ do
  visit new_user_session_path
  fill_in "user_username", :with => "guest"
  fill_in "user_password", :with => "guestpass"
  click_on "ゲストログイン"
end

Then /^ゲストユーザーとしてログインされる。$/ do
  page.should have_content("商品一覧")
  page.should_not have_content("ユーザー管理")
  page.should have_content("guest")
end

