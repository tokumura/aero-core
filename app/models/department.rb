class Department < ActiveRecord::Base
  has_and_belongs_to_many :products
  has_many :user
  validates_presence_of :name
end
