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


end
