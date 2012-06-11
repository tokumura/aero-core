class ProductsController < ApplicationController

  before_filter :authenticate_user!

  # GET /products
  # GET /products.xml
  def index
    puts "aaa"
    @user = User.find(1)
    puts "aaa"
    if @user.department_id
      @departments_products = DepartmentsProducts.find_all_by_department_id(@user.department.id)
      puts "aaa"
      @products = Array.new(0)
      puts "aaa"
      @departments_products.each do |dp|
        product = Product.find(dp.product_id)
        @products << product
      end
      puts "aaa"
    else
      @products = Product.all
    end
    #@products = Product.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.find(params[:id])

    @department_name = Array.new(@product.departments.size)
    @product.departments.each do |d|
      department = Department.find(d.id)
      @department_name << department.name
    end

    @category_name = Array.new(@product.categories.size)
    @product.categories.each do |c|
      category = Category.find(c.id)
      @category_name << category.name
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
          puts "success!"
          format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
          format.xml  { head :ok }
        else
          puts "failed!"
          format.html { render :action => "edit" }
          format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
=begin
=end


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

  def search
    #@products = Product.find_by_name(params[:keyword])
    @products = Product.all
    redirect_to products_path
  end

end
