class CreateDepartmentsProducts < ActiveRecord::Migration
  def self.up
    create_table :departments_products, :id => false do |t|
      t.integer :department_id
      t.integer :product_id

#      t.timestamps
    end
  end

  def self.down
    drop_table :departments_products
  end
end
