class Department < ActiveRecord::Base
  has_and_belongs_to_many :products
  has_many :user
  validates_presence_of :name

  def get_name_for_show(departments)
    department_name = Array.new(0)
    departments.each do |d|
      department = Department.find(d.id)
      department_name << department.name
    end
    department_name
  end
end
