# coding: utf-8
require 'thinreports'
require 'net/http'
require 'uri'

class ProductsController < ApplicationController

  before_filter :authenticate_user!

  # GET /products
  # GET /products.xml
  def index
    @user = User.find(current_user.id)
    if @user.department_id && @user.department_id.to_s != "0"
      @products_temp = Product.all
      @departments_products = DepartmentsProducts.find_all_by_department_id(@user.department.id)
      @products = Array.new(0)
      @sql = ""
      @departments_products.each do |dp|
        @sql = @sql + "id = " + dp.product_id.to_s + " OR "
      end
      @sql = @sql + "id = 0 order by name asc"
      @products = Product.find_by_sql(['SELECT * FROM products where ' + @sql])
      @selected_department_id = @user.department.id
    else
      @products = Product.order('name')
      @selected_department_id = "0"
    end
    @departments = Department.all
    @categories = Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  def index_for_client
    @products = Product.all
    respond_to do |format|
      format.xml 
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])
    @product.relations.each do |r|
      relation_product = Product.find(r.relation_id)
    end

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

    @category_names = Hash::new
    @categories.each do |c|
      @category_names[c.name] = c.id
    end

    @products = Product.all
    @product_names = Hash::new
    @products.each do |p|
      @product_names[p.name] = p.id
    end

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

    @category_names = Hash::new
    @categories.each do |c|
      @category_names[c.name] = c.id
    end

    @products = Product.all
    @product_names = Hash::new
    @products.each do |p|
      @product_names[p.name] = p.id
    end
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
      else
        # Not DRY! Do refactoring!
        @departments = Department.all
        @categories = Category.all

        @category_names = Hash::new
        @categories.each do |c|
          @category_names[c.name] = c.id
        end

        @products = Product.all
        @product_names = Hash::new
        @products.each do |p|
          @product_names[p.name] = p.id
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
          # Not DRY! Do refactoring!
          @departments = Department.all
          @categories = Category.all

          @category_names = Hash::new
          @categories.each do |c|
            @category_names[c.name] = c.id
          end

          @products = Product.all
          @product_names = Hash::new
          @products.each do |p|
            @product_names[p.name] = p.id
          end

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
    @products = Product.order('name')
    #@products = Product.all
    @departments = Department.all
    @selected_department_id = "0"
    @categories = Category.all

    respond_to do |format|
      format.html # findall.html.erb
      format.xml  { render :xml => @products }
    end
  end

  def findall_desc_name
    @products = Product.order('name DESC')
    #@products = Product.all
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

    report.page.values :title => "商品一覧"
    @products.each do |p|
      category_names = ""
      p.categories.each do |c|
        category = Category.find(c.id)
        category_names = category_names + category.name + "　"
      end

      url = p.photo(:thumb)
      response = Net::HTTP.get_response(URI.parse(url)).body
      filepath = "tmp/" + p.id.to_s + ".jpeg"
      open(filepath, "wb") do |file|
        file.puts response
      end

      report.page.list(:product_list) do |list|
        list.add_row :product_name => p.name, 
                     :product_price => p.price, 
                     :product_category => category_names,
                     :product_classify => p.classify,
                     :product_comment => p.comment,
                     :product_image => filepath
      end
    end
    send_data report.generate, :filename => "products.pdf", :type => 'application/pdf'
    FileUtils.rm(Dir.glob(Rails.root.to_s + "/tmp/*.jpeg"))
  end

  def download_detail
    @product = Product.find(params[:id])
    report = ThinReports::Report.new :layout => File.join(Rails.root, 'reports', 'product_detail.tlf')
    report.start_new_page

    report.page.values :product_name => @product.name,
                       :product_price => @product.price.to_s + " 円",
                       :product_classify => @product.classify,
                       :product_comment => @product.comment
 
    send_data report.generate, :filename => "products_detail.pdf", :type => 'application/pdf'
  end

  def relations
    @product = Product.find(params[:id])
    @categories = Category.all

    respond_to do |format|
      format.html # relations.html.erb
      format.xml  { render :xml => @product.relations }
    end
  end

  def relations_update
    @product = Product.find(params[:id])
    Relation.delete_all(:product_id => @product.id)

    save_success = false
    params[:relation_products] && params[:relation_products].each do |relation_id|
      @relation = Relation.new(:product_id=>@product.id, :relation_id=>relation_id)
      save_success = @relation.save
      if save_success == false
        break
      end
    end

    respond_to do |format|
      if save_success
        format.html { redirect_to(@product, :notice => 'Product Relations was successfully created.') }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

end
