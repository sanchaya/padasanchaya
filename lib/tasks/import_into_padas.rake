namespace :dictionaries do
  desc "Import dictionary_entries into padas for new dictionaries"
  task import_into_padas: :environment do
    puts "Checking existing padas..."
    initial_padas = Pada.count

    # Get unique dict_ids from the zip
    zip_dict_ids = DictionaryFileStat.distinct.pluck(:dict_id).sort
    puts "Found #{zip_dict_ids.size} zip dict IDs"

    zip_dict_ids.each do |dict_id|
      de = DictionaryEntry.find_by(dict_id: dict_id)
      next unless de

      d = Dictionary.find_or_create_by!(id: dict_id) do |r|
        r.name = de.dict_english_name.to_s[0..255]
        r.description = de.dict_name.to_s[0..255]
      end

      count = 0
      DictionaryEntry.where(dict_id: dict_id).find_each do |entry|
        word = (entry.kannada_word.presence || entry.english_word.presence)&.unicode_normalize(:nfkc)
        meaning = (entry.kannada_meaning.presence || entry.english_meaning.presence || '').unicode_normalize(:nfkc)

        next if word.blank?

        # Match by word, meaning, dictionary_id
        next if Pada.exists?(word: word, meaning: meaning, dictionary_id: d.id)

        Pada.create!(
          word: word,
          meaning: meaning,
          dictionary_id: d.id,
          language_id: 1,
          meaning_language_id: 2
        )
        count += 1
      end

      # Check per-dict count in padas
      pada_count = Pada.where(dictionary_id: d.id).count
      puts "  Dict #{dict_id}: #{count} new padas created (#{pada_count} total)"
    end

    puts "=== Result ==="
    puts "Padas: #{Pada.count} (+#{Pada.count - initial_padas})"
  end
end
