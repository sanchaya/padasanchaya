class AddTimestampsToWiktionaryEntries < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :wiktionary_entries
  end
end
