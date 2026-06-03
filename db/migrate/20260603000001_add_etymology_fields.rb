class AddEtymologyFields < ActiveRecord::Migration[5.1]
  def change
    add_column :jana_sanchaya_entries, :root_language, :string
    add_column :jana_sanchaya_entries, :root_word, :string
    add_column :jana_sanchaya_entries, :cognates, :text

    add_column :padas, :root_language, :string
    add_column :padas, :root_word, :string
    add_column :padas, :cognates, :text

    add_index :jana_sanchaya_entries, :root_language
    add_index :padas, :root_language
  end
end
