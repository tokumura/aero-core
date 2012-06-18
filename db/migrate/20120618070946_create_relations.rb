class CreateRelations < ActiveRecord::Migration
  def self.up
    create_table :relations do |t|
      t.integer :product_id
      t.integer :relation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :relations
  end
end
