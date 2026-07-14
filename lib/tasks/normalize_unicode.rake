namespace :unicode do
  desc "Normalize all text columns to NFKC form for consistent search"
  task normalize_padas: :environment do
    text_columns = %w[word meaning pos synonyms department kannada_pronunciation
                      short_description long_description administrative_word root_word cognates]

    total = Pada.count
    updated = 0
    errors = 0

    Pada.find_each do |pada|
      changed = false
      text_columns.each do |col|
        val = pada.send(col)
        next if val.blank?
        normalized = val.unicode_normalize(:nfkc)
        if val != normalized
          pada.send(:"#{col}=", normalized)
          changed = true
        end
      rescue ArgumentError => e
        puts "Error normalizing Pada##{pada.id} column #{col}: #{e.message}"
        errors += 1
      end

      if changed
        pada.save!(validate: false)
        updated += 1
      end
    rescue => e
      puts "Error processing Pada##{pada.id}: #{e.message}"
      errors += 1
    end

    puts "Normalization complete: #{total} total, #{updated} updated, #{errors} errors"
  end

  desc "Normalize wiktionary_entries to NFKC"
  task normalize_wiktionary: :environment do
    text_columns = %w[word meaning pos page_title language raw_content]
    total = WiktionaryEntry.count
    updated = 0
    errors = 0

    WiktionaryEntry.find_each do |entry|
      changed = false
      text_columns.each do |col|
        val = entry.send(col)
        next if val.blank?
        normalized = val.unicode_normalize(:nfkc)
        if val != normalized
          entry.send(:"#{col}=", normalized)
          changed = true
        end
      rescue ArgumentError => e
        puts "Error normalizing WiktionaryEntry##{entry.id} column #{col}: #{e.message}"
        errors += 1
      end

      if changed
        entry.save!(validate: false)
        updated += 1
      end
    rescue => e
      puts "Error processing WiktionaryEntry##{entry.id}: #{e.message}"
      errors += 1
    end

    puts "Wiktionary normalization complete: #{total} total, #{updated} updated, #{errors} errors"
  end

  desc "Normalize jana_sanchaya_entries to NFKC"
  task normalize_jana_sanchaya: :environment do
    text_columns = %w[word meaning pos contributor_name contributor_email
                      current_place dialect_place dialect_name transliteration
                      meaning_in_english synonyms antonyms usage_example etymology
                      ecological_domain cultural_notes root_language root_word cognates]
    total = JanaSanchayaEntry.count
    updated = 0
    errors = 0

    JanaSanchayaEntry.find_each do |entry|
      changed = false
      text_columns.each do |col|
        val = entry.send(col)
        next if val.blank?
        normalized = val.unicode_normalize(:nfkc)
        if val != normalized
          entry.send(:"#{col}=", normalized)
          changed = true
        end
      rescue ArgumentError => e
        puts "Error normalizing JanaSanchayaEntry##{entry.id} column #{col}: #{e.message}"
        errors += 1
      end

      if changed
        entry.save!(validate: false)
        updated += 1
      end
    rescue => e
      puts "Error processing JanaSanchayaEntry##{entry.id}: #{e.message}"
      errors += 1
    end

    puts "JanaSanchaya normalization complete: #{total} total, #{updated} updated, #{errors} errors"
  end

  desc "Normalize all dictionary data to NFKC (padas, wiktionary_entries, jana_sanchaya_entries)"
  task normalize_all: [:normalize_padas, :normalize_wiktionary, :normalize_jana_sanchaya]
end
