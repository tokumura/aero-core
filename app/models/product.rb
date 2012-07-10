class Product < ActiveRecord::Base
  has_and_belongs_to_many :departments
  has_and_belongs_to_many :categories
  has_many :relations
  has_attached_file :photo,
                    :styles => {
                      :thumb  => "80x60",
                      :medium => "120x90",
                      :large  => "160x120"
                    },
                      :storage => :s3,
                      :s3_credentials => "#{Rails.root.to_s}/config/s3.yml",
                      :path => ":attachment/:id/:style.:extension"

  validates_presence_of :name, :price

  def product_all(department_id)
    departments_products = DepartmentsProducts.find_all_by_department_id(department_id)
    products = Array.new(0)
    sql = ""
    departments_products.each do |dp|
      sql = sql + "id = " + dp.product_id.to_s + " OR "
    end
    sql = sql + "id = 0 order by name asc"
    products = Product.find_by_sql(['SELECT * FROM products where ' + sql])
    products
  end

  def save_with_relations(departments, categories)
    save_success = save
    if save_success
      departments && departments.each do |department_id|
        departments_products = DepartmentsProducts.new(:product_id => id, :department_id => department_id)
        save_success = departments_products.save
      end

      if categories 
        categories_products = CategoriesProducts.new(:product_id => id, :category_id => categories)
        save_success = categories_products.save
      end
    else
    end
    save_success
  end

  def get_product_hash(products)
    product_names = Hash::new
    products.each do |p|
      product_names[p.name] = p.id
    end
    product_names
  end

end
