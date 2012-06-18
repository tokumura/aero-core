class Product < ActiveRecord::Base
  has_and_belongs_to_many :departments
  has_and_belongs_to_many :categories
  has_many :relations

  mount_uploader :pict, PhotoUploader

  before_save :set_code

  def set_code
    self.pictcode = "data:image/#{self.pict.file.extension};base64,"
    self.pictcode << Base64.encode64(self.pict.file.read)
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
