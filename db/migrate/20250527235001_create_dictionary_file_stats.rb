class CreateDictionaryFileStats < ActiveRecord::Migration[5.2]
  def change
    create_table :dictionary_file_stats do |t|
      t.string :file_name, null: false
      t.string :table_name, null: false
      t.string :dict_name
      t.string :dict_english_name
      t.integer :dict_id
      t.integer :total_entries, default: 0
      t.string :source_file_path

      t.timestamps
    end

    add_index :dictionary_file_stats, :file_name, unique: true
    add_index :dictionary_file_stats, [:table_name, :dict_id], unique: true
  end
end
