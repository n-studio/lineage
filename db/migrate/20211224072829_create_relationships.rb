class CreateRelationships < ActiveRecord::Migration[7.0]
  def change
    create_table :relationships do |t|
      t.references :practitioner, null: false, index: true, foreign_key: true
      t.references :other_practitioner, null: false, index: true, foreign_key: { to_table: :practitioners }
      t.references :style, index: true, foreign_key: true
      t.string :relation_type, null: false, index: true, comment: "disciple/son/nephew/husband/..."
      t.integer :duration, comment: "in seconds"
      t.date :start_on
      t.date :end_on
      t.timestamps
    end
  end
end
