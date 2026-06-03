class CreateDialects < ActiveRecord::Migration[5.1]
  def change
    create_table :dialects do |t|
      t.string :english_name, null: false
      t.string :kannada_name, null: false
      t.string :category
      t.string :category_kannada
      t.text :primary_region
      t.text :primary_region_kannada
      t.text :notes
      t.text :notes_kannada
      t.timestamps
    end

    add_index :dialects, :english_name, unique: true
    add_index :dialects, :kannada_name, unique: true

    add_column :jana_sanchaya_entries, :dialect_id, :bigint
    add_index :jana_sanchaya_entries, :dialect_id
  end
end
