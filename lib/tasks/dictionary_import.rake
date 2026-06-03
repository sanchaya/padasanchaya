require 'csv'
require 'zip'

namespace :dictionaries do
  desc "Import all dictionary CSV files from ZIP archive into dictionary_entries + padas/dictionaries tables"
  task import: :environment do
    zip_path = Rails.root.join('padakanaja_dictionaries.zip')
    unless File.exist?(zip_path)
      puts "ERROR: #{zip_path} not found"
      exit 1
    end

    total_inserted = 0
    total_updated = 0
    file_stats = []

    Zip::File.open(zip_path) do |zip_file|
      csv_entries = zip_file.select { |entry| entry.name.end_with?('.csv') }
      puts "Found #{csv_entries.count} CSV files in the zip."

      csv_entries.each do |entry|
        next if entry.directory?

        file_name = entry.name
        puts "Processing: #{file_name}"

        csv_content = entry.get_input_stream.read.force_encoding('UTF-8')

        begin
          csv = CSV.parse(csv_content, headers: true, encoding: 'UTF-8')
        rescue => e
          puts "  ERROR parsing #{file_name}: #{e.message}"
          next
        end

        row_count = csv.count
        puts "  -> #{row_count} rows found"

        inserted = 0
        updated = 0
        first_row = nil

        csv.each do |row|
          dict_id = row['dict_id'].to_i
          kannada_word = row['kannada_word']
          english_word = row['english_word']
          dict_name = row['dict_name']
          dict_english_name = row['dict_english_name']

          first_row ||= row

          # Insert into dictionary_entries (raw CSV data)
          entry_attributes = {
            dict_id: dict_id,
            dict_name: dict_name,
            dict_english_name: dict_english_name,
            kannada_word: kannada_word,
            english_word: english_word,
            kannada_meaning: row['kannada_meaning'],
            synonyms: row['synonyms'],
            subject: row['subject'],
            grammar: row['grammar'],
            department: row['department'],
            kannada_pronunciation: row['kannada_pronunciation'],
            english_meaning: row['english_meaning'],
            short_description: row['short_description'],
            long_description: row['long_description'],
            administrative_word: row['administrative_word']
          }

          existing_entry = DictionaryEntry.find_by(
            dict_id: dict_id,
            kannada_word: kannada_word,
            english_word: english_word
          )

          if existing_entry
            changed = entry_attributes.any? { |k, v| existing_entry.send(k) != v }
            if changed
              existing_entry.update!(entry_attributes)
              updated += 1
            end
          else
            DictionaryEntry.create!(entry_attributes)
            inserted += 1
          end
        end

        # Track per-file stats
        if first_row
          stat = DictionaryFileStat.find_or_initialize_by(file_name: file_name)
          stat.table_name = "dictionary_entries"
          stat.dict_id = first_row['dict_id'].to_i rescue nil
          stat.dict_name = first_row['dict_name'] rescue nil
          stat.dict_english_name = first_row['dict_english_name'] rescue nil
          stat.total_entries = row_count
          stat.source_file_path = file_name
          stat.save!
        end

        total_inserted += inserted
        total_updated += updated
        file_stats << { file: file_name, inserted: inserted, updated: updated, total: row_count }
        puts "  -> Inserted: #{inserted}, Updated: #{updated}"
      end
    end

    puts "\n=== Import Summary ==="
    puts "Total files processed: #{file_stats.count}"
    puts "Total inserted (dictionary_entries): #{total_inserted}"
    puts "Total updated (dictionary_entries): #{total_updated}"
  end
end
