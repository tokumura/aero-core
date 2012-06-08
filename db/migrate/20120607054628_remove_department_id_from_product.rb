class RemoveDepartmentIdFromProduct < ActiveRecord::Migration
  def self.up
    remove_column :products, :department_id
  end

  def self.down
    add_column :products, :department_id, :integer
  end
end
