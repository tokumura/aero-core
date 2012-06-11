# coding: utf-8
require 'spec_helper'

describe "users/new.html.erb" do
  before do
    @user = User.new
    @departments = Department.all
  end
  it "ユーザー名のテキストボックス(空)が表示される。" do
    render
    rendered.should have_selector("form") do |form|
      form.should have_selector("input", :type => "text", :name => "user[username]")
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
