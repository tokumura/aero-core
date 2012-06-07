class AddDepartmentIdToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :department_id, :integer
  end

  def self.down
    remove_column :products, :department_id
  end
end
