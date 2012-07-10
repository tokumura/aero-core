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
      product = Product.new
      @products = product.product_all(@user.department.id)
      @selected_department_id = @user.department.id
    else
      @products = Product.order('name')
      @selected_department_id = "0"
    end
    @departments = Department.all
    @categories = Category.all
    @order_name = "商品名 (昇順)"
    @sort = "name_asc"

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

    department = Department.new
    @department_name = department.get_name_for_show(@product.departments)

    category = Category.new
    @category_name = category.get_name_for_show(@product.categories)
    
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
      save_success = @product.save_with_relations(params[:department_param], params[:category_param])

      if !save_success
        @departments = Department.all

        @categories = Category.all
        category = Category.new
        @category_names = category.get_category_hash(@categories)

        @products = Product.all
        product = Product.new
        @product_names = product.get_product_hash(@products)
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
          category = Category.new
          @category_names = category.get_category_hash(@categories)

          @products = Product.all
          product = Product.new
          @product_names = product.get_product_hash(@products)

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
    sort = params[:sort].to_s.split("_")
    @order_name = get_sort_name(sort[0].to_s, sort[1].to_s)
    @sort = params[:sort]

    keyword = params[:search_string]
    @products = Product.find(:all, 
                             :conditions => ["name LIKE ?", "%" + params[:search_string] + "%"], 
                             :order => sort[0] + ' ' + sort[1])

    @departments = Department.all
    @categories = Category.all
    @search_string = params[:search_string]
    @selected_department_id = "0"

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
    @order_name = "商品名 (昇順)"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

=begin

  def findall
    @products = Product.order('name')
    #@products = Product.all
    @departments = Department.all
    @selected_department_id = "0"
    @categories = Category.all
    @order_name = "商品名 (昇順)"
    sort = params[:sort].to_s.split("_")
    @order_name = get_sort_name(sort[0].to_s, sort[1].to_s)
    @sort = params[:sort]

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
    @order_name = "商品名 (昇順)"
    @sort = params[:sort]

    respond_to do |format|
      format.html # findall.html.erb
      format.xml  { render :xml => @products }
    end
  end
=end

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
    report.page.values :output_date => '2012/06/29 12:21'

    @products.each do |p|
      category_names = ""
      p.categories.each do |c|
        category = Category.find(c.id)
        category_names = category_names + category.name + "　"
      end

      url = p.photo(:original)
      ext = p.photo_content_type.to_s.split("/")
      
      response = Net::HTTP.get_response(URI.parse(url)).body
      filepath = "tmp/" + p.id.to_s + "." + ext[1]
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
    FileUtils.rm(Dir.glob(Rails.root.to_s + "/tmp/*.jpg"))
    FileUtils.rm(Dir.glob(Rails.root.to_s + "/tmp/*.png"))
  end

  def download_detail
    @product = Product.find(params[:id])
    report = ThinReports::Report.new :layout => File.join(Rails.root, 'reports', 'products_detail.tlf')
    report.start_new_page

    category_names = ""
    @product.categories.each do |c|
      category = Category.find(c.id)
      category_names = category_names + category.name + "　"
    end

    url = @product.photo(:original)
    ext = @product.photo_content_type.to_s.split("/")
    
    response = Net::HTTP.get_response(URI.parse(url)).body
    filepath = "tmp/" + @product.id.to_s + "." + ext[1]
    open(filepath, "wb") do |file|
      file.puts response
    end

    report.page.values :product_name => @product.name,
                       :product_image => filepath,
                       :product_price => @product.price.to_s + " 円",
                       :product_classify => @product.classify,
                       :product_category => category_names,
                       :product_comment => @product.comment
 
    if @product.relations.size > 0
      report.page.values :relation_title_name => '商品名',
                         :relation_title_category => 'カテゴリー'
    end

    @product.relations.each do |pr|
      product = Product.find(pr.relation_id)

      category_names = ""
      product.categories.each do |c|
        category = Category.find(c.id)
        category_names = category_names + category.name + "　"
      end

      url = product.photo(:thumb)
      ext = product.photo_content_type.to_s.split("/")
      
      response = Net::HTTP.get_response(URI.parse(url)).body
      relation_filepath = "tmp/" + product.id.to_s + "." + ext[1]
      open(relation_filepath, "wb") do |file|
        file.puts response
      end

      report.page.list(:relation_list) do |list|
        list.add_row :relation_name => product.name, 
                     :relation_category => category_names,
                     :relation_image => relation_filepath
      end
      
    end

=begin

=end

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

  def belong_order
    sort = params[:sort].to_s.split("_")
    @order_name = get_sort_name(sort[0].to_s, sort[1].to_s)

    if params[:id].to_s == "0"
      @products = Product.order(sort[0] + ' ' + sort[1])
    elsif
      @products = Product.find_by_sql(['
        SELECT * FROM departments_products as dp
        LEFT OUTER JOIN products as p ON dp.product_id = p.id 
        WHERE dp.department_id = ' + params[:id].to_s + ' 
        ORDER BY p.' + sort[0] + ' ' + sort[1]
      ])
    end

    @departments = Department.all
    @categories = Category.all
    @selected_department_id = params[:id]
    @sort = params[:sort]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  def get_sort_name(sort_name, sort_order)
    order_name = ""
    if sort_name == "name"
      order_name = "商品名"
    elsif sort_name == "classify"
      order_name = "分類"
    end

    if sort_order == "asc"
      order_name = order_name + " (昇順)"
    elsif sort_order == "desc"
      order_name = order_name + " (降順)"
    end
    order_name
  end

end
