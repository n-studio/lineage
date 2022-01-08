class CreateStyles < ActiveRecord::Migration[7.0]
  def change
    create_table :styles do |t|
      t.string :name, null: false, index: true
      t.integer :practitioners_count, null: false, default: 0
      t.timestamps
    end
  end
end
