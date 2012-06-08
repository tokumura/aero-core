# coding: utf-8
require 'spec_helper'

describe DepartmentsController do

  fixtures :departments

  before do
    controller.class.skip_before_filter :authenticate_user!
  end

  describe "GET /departments" do
    it "should be successfull" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET /departments/new" do
    it "should be successfull" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET /departments/edit" do
    it "should be successfull" do
      get 'edit', {:id => 1}
      response.should be_success
    end
  end

  describe "DELETE /departments" do
    it "should be successfull" do
      delete 'destroy', {:id => 1}
      response.should redirect_to(departments_path)
    end
  end

  describe "POST /departments" do
    it "should be successfull" do
      post 'create', {:id => 4, :name => "顧客管理部"}
      response.should redirect_to(department_path(4))
    end
  end

  describe "PUT /departments" do
    it "should be successfull" do
      post 'update', {:id => 2, :name => "医機部"}
      response.should redirect_to(department_path(2))
    end
  end

=begin
=end
end
