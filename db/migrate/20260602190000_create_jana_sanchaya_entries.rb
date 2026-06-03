class CreateJanaSanchayaEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :jana_sanchaya_entries do |t|
      t.string :word, null: false
      t.string :meaning, null: false
      t.string :pos
      t.bigint :language_id, default: 1
      t.bigint :dictionary_id, default: 208
      t.string :user_ip
      t.integer :votes_up, default: 0
      t.integer :votes_down, default: 0
      t.timestamps
    end
    
    add_index :jana_sanchaya_entries, [:word, :dictionary_id]
    add_index :jana_sanchaya_entries, :votes_up
    add_index :jana_sanchaya_entries, :created_at
    
    create_table :jana_sanchaya_votes do |t|
      t.bigint :jana_sanchaya_entry_id, null: false
      t.string :user_ip, null: false
      t.string :vote_type, null: false # 'up' or 'down'
      t.timestamps
    end
    
    add_index :jana_sanchaya_votes, [:jana_sanchaya_entry_id, :user_ip], unique: true, name: 'index_jana_votes_on_entry_and_ip'
    add_index :jana_sanchaya_votes, :jana_sanchaya_entry_id
  end
end
