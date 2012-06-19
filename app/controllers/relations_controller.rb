# coding: utf-8
class RelationsController < ApplicationController
  def edit
    @product = Product.find(params[:id])

    @relations = Relation.find_all_by_product_id(params[:id])
    puts "@relations.size!!!"
    puts @relations.size

    @relation_names = Hash::new
    @relations && @relations.each do |r|
      product = Product.find(r.relation_id)
      @relation_names[product.name] = product.id
    end

    @categories = Category.all
    @category_names = Hash::new
    @categories.each do |c|
      @category_names[c.name] = c.id
    end
  end
end
