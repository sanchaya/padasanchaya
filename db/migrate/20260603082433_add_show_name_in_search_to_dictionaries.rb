class AddShowNameInSearchToDictionaries < ActiveRecord::Migration[5.2]
  def change
    add_column :dictionaries, :show_name_in_search, :boolean, default: false, null: false
  end
end
