class CreatePractitioners < ActiveRecord::Migration[7.0]
  def change
    create_table :practitioners do |t|
      t.string :name, null: false
      t.boolean :legendary, default: false
      t.boolean :controversial, default: false
      t.timestamps
    end
  end
end
