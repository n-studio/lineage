class CreateAlternativeNames < ActiveRecord::Migration[7.0]
  def change
    create_table :alternative_names do |t|
      t.references :model, polymorphic: true, index: true
      t.string :name
      t.string :language
      t.string :language_info
      t.boolean :unusual, default: false
      t.timestamps
    end
  end
end
