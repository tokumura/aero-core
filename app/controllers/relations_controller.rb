# coding: utf-8
class RelationsController < ApplicationController

  def edit
    @relation = Relation.new
    @product = Product.find(params[:id])
    @relations = Relation.find_all_by_product_id(params[:id])

    @relation_names = Hash::new
    @relations && @relations.each do |r|
      product = Product.find(r.relation_id)
      @relation_names[product.name] = product.id
    end

    @categories = Category.all
    @category_names = Hash::new
    @product_items = Hash::new
    @categories.each do |c|
      @category_names[c.name] = c.id
    end
  end

  def get_items
    puts "params!!!"
    puts params[:id]
    @product_items = Array.new(0)
    @categories_products = CategoriesProducts.find_all_by_category_id(params[:id])
    @categories_products.each do |cp|
      puts "find !!!"
      @product_items << Product.find(cp.product_id)
    end
    @product_items
  end

  #def create
  def update
    puts "update!!"
    puts params
    puts params[:relation_products_params]
    redirect_to products_path

  end


end
