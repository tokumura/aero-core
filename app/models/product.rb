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

end
