class CreateProductsDepartments < ActiveRecord::Migration
  def self.up
    create_table :products_departments do |t|
      t.integer :product_id
      t.integer :department_id

      t.timestamps
    end
  end

  def self.down
    drop_table :products_departments
  end
end
