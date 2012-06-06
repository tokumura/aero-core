require 'spec_helper'

describe ProductsController do
  fixtures :products

  before do
    controller.class.skip_before_filter :authenticate_user!
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

  describe "POST /products" do
    it "should be successfull" do
      post 'create', {:id => 3, :name => "Canon LBP7010", :price => "10000"}
      response.should redirect_to(product_path(3))
    end
  end

  describe "PUT /products" do
    it "should be successfull" do
      post 'update', {:id => 1, :name => "Canon LBP9020", :price => "40000"}
      response.should redirect_to(product_path(1))
    end
  end

  describe "GET /search" do
    it "should be successfull" do
      get 'search'
      #get 'search'
      response.should redirect_to(products_path)
    end
  end
=begin
=end
end
