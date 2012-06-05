# coding: utf-8
require 'spec_helper'

describe User do

  fixtures :users

  context "複数ユーザーがいる場合" do
    before do
      @users = User.all
    end
    it "全件検索時、複数ユーザーが取得される。" do
      @users.size.should > 1
    end
  end

  context "ユーザーID:1 のユーザー名が 'okumura'の場合" do
    before do
      @user = User.find(1)
    end
    it "ユーザー名は'okumura'である。" do
      @user.username.should == "okumura"
    end
  end

  context "管理者権限を付与した場合" do
    before do
      @user = User.find(2)
      @user.update_attribute :admin, true
    end
    it "管理者権限が付与される。" do
      @user.admin.should == true
    end
  end

  context "管理者権限を解除した場合" do
    before do
      @user = User.find(1)
      @user.update_attribute :admin, false
    end
    it "管理者権限が削除される。" do
      @user.admin.should == false
    end
  end




end
