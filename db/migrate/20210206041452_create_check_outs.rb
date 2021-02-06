class CreateCheckOuts < ActiveRecord::Migration[5.2]
  def change
    create_table :check_outs do |t|
      t.date :return_date
      t.boolean :status, null: false, default: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
