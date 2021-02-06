class AddColumnCheckOutBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :check_out_books, :status, :boolean, null: false, default: true
  end
end
