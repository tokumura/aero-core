# coding: utf-8
require 'spec_helper'

describe "users/edit.html.erb" do
  fixtures :users

  before do
    @user = User.find(users(:okumura))
  end

  it "ユーザー名のテキストボックス('okumura'が入力済)が表示される。" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "user[username]", :value => "okumura")
    end
  end

  it "パスワードのテキストボックスが表示される。" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "password", :name => "user[password]")
    end
=begin
=end
  end
end
