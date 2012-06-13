# coding: utf-8
require 'spec_helper'

describe ProductsController do
  fixtures :products, :departments, :departments_products

  before do
    controller.class.skip_before_filter :authenticate_user!
    user = double('user')
    controller.stub(:current_user) { user }
    user.stub(:id) { 1 }
  end

  describe "GET /products" do
    it "should be successfull" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET /products/new" do
    it "should be successfull" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET /products/edit" do
    it "should be successfull" do
      get 'edit', {:id => 1}
      response.should be_success
    end
  end

  describe "DELETE /products" do
    it "should be successfull" do
      delete 'destroy', {:id => 1}
      response.should redirect_to(products_path)
    end
  end

  describe "POST /products (departments is nil)" do
    it "should be successfull" do
      post 'create', :product => {:id => 4, :name => "カルナート", :price => 10000}, 
                      :department_param => nil, :category_param => nil
      response.should redirect_to(product_path(4))
    end
  end

  describe "POST /products (departments is not nil)" do
    it "should be successfull" do
      post 'create', :product => {:id => 4, :name => "カルナート", :price => 10000}, 
                     :department_param => {:product_id => 4, :department_id => 1},
                     :category_param => 1
      response.should redirect_to(product_path(4))
    end
  end
=begin
=end

  describe "PUT /products" do
    it "should be successfull" do
      pending("product update")
      #post 'update', {:id => 1, :name => "Canon LBP9020", :price => "40000"}
      post 'update', :product => {:id => 1, :name => "Canon LBP9020", :price => 40000},
                      #:department_param => nil
                      :department_param => ["1", "2", "3"]
      response.should redirect_to(product_path(1))
    end
  end

  describe "GET /belong" do
    it "should be successfull" do
      get 'belong', {:id => 1}
      response.should be_success
    end
  end

  describe "GET /find" do
    it "should be successfull" do
      post 'find', :search_string => "LBP"
      response.should be_success
      #response.should redirect_to(product_path(1))
    end
  end

  describe "GET /findall" do
    it "should be successfull" do
      get 'findall'
      response.should be_success
    end
  end
=begin
=end
end
