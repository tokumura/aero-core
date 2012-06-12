class Product < ActiveRecord::Base
  has_and_belongs_to_many :departments
  has_and_belongs_to_many :categories

  validate :price_valid?

  def price_valid?
#    errors.add(:price, 'is invalid.') if validates_numericality_of :price
    puts "error!!!!!"
#    puts errors.size
  end

  def get_belongs_to(user)
    departments_products = DepartmentsProducts.find_all_by_department_id(@user.department.id)
    products = Array.new(0)
    departments_products.each do |dp|
      product = Product.find(dp.product_id)
      products << product
    end
    products
  end
end
