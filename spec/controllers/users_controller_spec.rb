require 'spec_helper'

describe UsersController do
  fixtures :users

  describe "GET /users" do
    it "should be successfull" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET /users/new" do
    it "should be successfull" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET /users/edit" do
    it "should be successfull" do
      get 'edit', {:id => 1}
      response.should be_success
    end
  end

  describe "DELETE /users" do
    it "should be successfull" do
      delete 'destroy', {:id => 1}
      response.should redirect_to(users_path)
    end
  end

=begin
  describe "POST /users" do
    it "should be successfull" do
      post 'create', {:username => "hososhita"}
      response.should redirect_to(users_path)
    end
  end
  describe "PUT /users" do
    it "should be successfull" do
      post 'create', {:username => "hososhita"}
      response.should redirect_to(users_path)
    end
  end
=end

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
