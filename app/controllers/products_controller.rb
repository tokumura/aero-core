# coding: utf-8
require 'thinreports'

class ProductsController < ApplicationController

  before_filter :authenticate_user!

  # GET /products
  # GET /products.xml
  def index
    @user = User.find(current_user.id)
    if @user.department_id && @user.department_id.to_s != "0"
      @departments_products = DepartmentsProducts.find_all_by_department_id(@user.department.id)
      @products = Array.new(0)
      @departments_products.each do |dp|
        product = Product.find(dp.product_id)
        @products << product
      end
      @selected_department_id = @user.department.id
    else
      @products = Product.all
      @selected_department_id = "0"
    end
    @departments = Department.all
    @categories = Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

    @department_name = ""
    @product.departments.each do |d|
      department = Department.find(d.id)
      @department_name = @department_name + department.name + "　"
    end

    @category_name = ""
    @product.categories.each do |c|
      category = Category.find(c.id)
      @category_name = @category_name + category.name + "　"
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new
    @departments = Department.all
    @categories = Category.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    @departments = Department.all
    @categories = Category.all
  end

  # POST /products
  # POST /products.xml
  def create
    Product.transaction do
      @product = Product.new(params[:product])
      save_success = @product.save

      if save_success
        params[:department_param] && params[:department_param].each do |department_id|
          @departments_products = DepartmentsProducts.new(:product_id => @product.id, :department_id => department_id)
          save_success = @departments_products.save
        end

        if params[:category_param] 
          @categories_products = CategoriesProducts.new(:product_id => @product.id, :category_id => params[:category_param])
          save_success = @categories_products.save
        end
      end

      respond_to do |format|
        if save_success
          format.html { redirect_to(@product, :notice => 'Product was successfully created.') }
          format.xml  { render :xml => @product, :status => :created, :location => @product }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    Product.transaction do
      @product = Product.find(params[:id])
      DepartmentsProducts.delete_all(:product_id => @product.id)
      CategoriesProducts.delete_all(:product_id => @product.id)

      save_success = false
      params[:department_param] && params[:department_param].each do |department_id|
        @departments_products = DepartmentsProducts.new(:product_id => @product.id, 
                                                        :department_id => department_id)
        save_success = @departments_products.save
        if save_success == false
          break
        end
      end

      if params[:category_param] 
        @categories_products = CategoriesProducts.new(:product_id => @product.id, :category_id => params[:category_param])
        save_success = @categories_products.save
      end

      respond_to do |format|
        if @product.update_attributes(params[:product]) && save_success
          format.html { redirect_to(@product, :notice => '更新しました。') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end

  def find
    keyword = params[:search_string]
    @products = Product.find(:all, :conditions => ["name LIKE ?", "%" + params[:search_string] + "%"])
    @departments = Department.all
    @categories = Category.all
    @search_string = params[:search_string]

    respond_to do |format|
      format.html # search.html.erb
      format.xml  { render :xml => @products }
    end
  end

  def belong
    @departments_products = DepartmentsProducts.find_all_by_department_id(params[:id])
    @products = Array.new(0)
    @departments_products.each do |dp|
      product = Product.find(dp.product_id)
      @products << product
    end
    @departments = Department.all
    @categories = Category.all
    
    @selected_department_id = params[:id]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  def findall
    @products = Product.all
    @departments = Department.all
    @selected_department_id = "0"
    @categories = Category.all

    respond_to do |format|
      format.html # findall.html.erb
      format.xml  { render :xml => @products }
    end
  end

  def download

    if params[:search_string] != nil
      keyword = params[:search_string]
      @products = Product.find(:all, :conditions => ["name LIKE ?", "%" + keyword + "%"])
    elsif params[:selected_department_id] == "0"
      @products = Product.all
    else
      departments_products = DepartmentsProducts.find_all_by_department_id(params[:selected_department_id])
      @products = Array.new(0)
      departments_products.each do |dp|
        product = Product.find(dp.product_id)
        @products << product
      end
    end

    report = ThinReports::Report.new :layout => File.join(Rails.root, 'reports', 'products_list.tlf')
    report.start_new_page

    report.page.values :tiltle => "商品一覧"
    @products.each do |p|
      report.page.list(:list) do |list|
        list.add_row :product_name => p.name, :product_price => p.price
      end
    end
    send_data report.generate, :filename => "products.pdf", :type => 'application/pdf'
  end
end
