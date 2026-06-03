class AddDictionaryMetadataFields < ActiveRecord::Migration[5.2]
  def change
    add_column :dictionaries, :core_name, :string
    add_column :dictionaries, :dictionary_type, :string
    add_column :dictionaries, :multilingual, :boolean, default: false
    add_column :dictionaries, :category, :string
    add_column :dictionaries, :publisher, :string
    add_column :dictionaries, :published_year, :integer
    add_column :dictionaries, :total_entries, :integer
  end
end
