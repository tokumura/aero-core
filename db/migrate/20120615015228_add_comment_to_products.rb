class AddCommentToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :comment, :text
  end

  def self.down
    remove_column :products, :comment
  end
end
