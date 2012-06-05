require 'spec_helper'

describe UsersController do
  fixtures :users

  describe "GET /users" do
    it "should be successfull" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET /make_admin" do
    it "should be successfull" do
      get 'make_admin', :id => users(:sekiguchi).id
      response.should redirect_to(users_path)
    end
  end

  describe "GET /remove_admin" do
    it "should be successfull" do
      get 'remove_admin', :id => users(:okumura).id
      response.should redirect_to(users_path)
    end
  end
end
