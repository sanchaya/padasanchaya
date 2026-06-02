class CreateWiktionaryEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :wiktionary_entries do |t|
      t.string :word
      t.text :meaning
      t.string :pos
      t.string :page_title
      t.string :language
      t.text :raw_content
    end
  end
end
