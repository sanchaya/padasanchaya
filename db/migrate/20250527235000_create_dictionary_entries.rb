class CreateDictionaryEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :dictionary_entries do |t|
      t.integer :dict_id, null: false, index: true
      t.string :dict_name
      t.string :dict_english_name
      t.text :kannada_word
      t.text :english_word
      t.text :kannada_meaning
      t.text :synonyms
      t.text :subject
      t.text :grammar
      t.text :department
      t.text :kannada_pronunciation
      t.text :english_meaning
      t.text :short_description
      t.text :long_description
      t.text :administrative_word

      t.timestamps
    end

    add_index :dictionary_entries, :kannada_word, length: 255
    add_index :dictionary_entries, :english_word, length: 255
    add_index :dictionary_entries, :dict_english_name, length: 255
  end
end
