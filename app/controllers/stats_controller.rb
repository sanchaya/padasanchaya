class StatsController < ApplicationController
  def index
    # ZIP dictionary stats from dictionary_file_stats (raw import counts)
    @zip_dictionary_stats = DictionaryFileStat.select(:dict_id, :dict_name, :total_entries)
                                              .order(:dict_id)

    @total_zip_dictionaries = DictionaryFileStat.count
    @grand_total_items = DictionaryFileStat.sum(:total_entries)
    @total_entries = Pada.count + DictionaryEntry.count + WiktionaryEntry.count

    # Old dictionaries (IDs 1-10, pre-existing before ZIP)
    @old_dictionaries = Dictionary.where(id: (1..10).to_a).order(:id)
    @total_old_dictionaries = @old_dictionaries.count

    # Count padas only for old IDs to avoid showing ZIP data here
    old_ids = (1..10).to_a
    @old_entries = Pada.where(dictionary_id: old_ids).group(:dictionary_id).count
    @total_old_entries = Pada.where(dictionary_id: old_ids).count

    # Wiktionary stats
    @wiktionary_count = WiktionaryEntry.count
  end
end
