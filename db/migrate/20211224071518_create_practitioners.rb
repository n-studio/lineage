class CreatePractitioners < ActiveRecord::Migration[7.0]
  def change
    create_table :practitioners do |t|
      t.references :created_style, index: true, foreign_key: { to_table: :styles }
      t.string :name, null: false, index: true
      t.boolean :legendary, default: false
      t.boolean :controversial, default: false
      t.boolean :public_figure, default: false, index: true
      t.date :birthdate
      t.boolean :approximate_birthdate, default: false
      t.date :deathdate, index: true
      t.boolean :approximate_deathdate, default: false
      t.string :country_code, comment: "ISO 3166-1 alpha-2"
      t.timestamps
    end
  end
end
