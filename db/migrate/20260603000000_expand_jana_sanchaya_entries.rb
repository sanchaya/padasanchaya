class ExpandJanaSanchayaEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :jana_sanchaya_entries, :contributor_name, :string
    add_column :jana_sanchaya_entries, :contributor_email, :string
    add_column :jana_sanchaya_entries, :current_place, :string
    add_column :jana_sanchaya_entries, :dialect_place, :string
    add_column :jana_sanchaya_entries, :dialect_name, :string
    add_column :jana_sanchaya_entries, :is_dialect, :boolean, default: false
    add_column :jana_sanchaya_entries, :transliteration, :string
    add_column :jana_sanchaya_entries, :meaning_in_english, :text
    add_column :jana_sanchaya_entries, :synonyms, :text
    add_column :jana_sanchaya_entries, :antonyms, :text
    add_column :jana_sanchaya_entries, :usage_example, :text
    add_column :jana_sanchaya_entries, :etymology, :text
    add_column :jana_sanchaya_entries, :ecological_domain, :string
    add_column :jana_sanchaya_entries, :cultural_notes, :text
    add_column :jana_sanchaya_entries, :status, :string, default: 'pending'

    add_index :jana_sanchaya_entries, :dialect_name
    add_index :jana_sanchaya_entries, :is_dialect
    add_index :jana_sanchaya_entries, :ecological_domain
    add_index :jana_sanchaya_entries, :status
  end
end
