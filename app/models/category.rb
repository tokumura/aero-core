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
end
