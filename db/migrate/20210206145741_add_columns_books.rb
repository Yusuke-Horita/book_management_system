class AddColumnsBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :stock, :integer, null: false, default: 0
  end
end
