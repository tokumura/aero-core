class Category < ActiveRecord::Base
  has_and_belongs_to_many :products
  validates_presence_of :name

  def get_name_for_show(categories)
    category_name = Array.new(0)
    categories.each do |c|
      category = Category.find(c.id)
      category_name << category.name
    end
    category_name
  end

  def get_belong_products(category_id)
    categories_products = CategoriesProducts.find_all_by_category_id(category_id)
    products = Array.new(0)
    categories_products.each do |cp|
      product = Product.find(cp.product_id)
      products << product
    end
    products
  end

  def get_category_hash(categories)
    category_names = Hash::new
    categories.each do |c|
      category_names[c.name] = c.id
    end
    category_names
  end
end
