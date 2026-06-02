require 'zip'
require 'csv'
require 'active_record'

namespace :import do
  desc 'Reimport Padakanaja dictionaries from new zip file (fresh data)'
  task dictionaries: :environment do
    puts 'Clearing all existing dictionaries and padas...'
    Pada.delete_all
    Dictionary.delete_all

    zip_path = File.expand_path('../padakanaja_dictionaries.zip', __dir__)
    unless File.exist?(zip_path)
      puts "Zip file not found at #{zip_path}"
      exit 1
    end
    puts "Opening zip at #{zip_path}"

    kannada_regex = /[\u0C80-\u0CFF]/
    english_regex = /[A-Za-z]/

    Zip::File.open(zip_path) do |zip|
      csv_entries = zip.entries.select { |e| e.file? && e.name.end_with?('.csv') }
      puts "Found #{csv_entries.size} dictionary CSV files"

      csv_entries.each do |entry|
        content = entry.get_input_stream.read
        rows = CSV.parse(content, headers: false)

        next if rows.empty?

        first_row = rows.first
        dict_id = first_row[0]
        dict_name = first_row[1]
        dict_english_name = first_row[2]

        shortname = dict_english_name.gsub(/[^a-zA-Z]/, '').downcase[0, 15]
        shortname = "dict#{dict_id}" if shortname.empty?

        dictionary = Dictionary.find_or_create_by(name: shortname) do |d|
          d.original_name = dict_name.to_s[0, 255]
          d.description = "Imported from padakanaja zip (source file: #{entry.name})"
        end

        puts "Importing entries from dictionary #{dict_name} (#{shortname})"

        rows.each_with_index do |row, idx|
          kannada_word = row[3].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
          english_word = row[4].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
          kannada_meaning = row[5].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
          synonyms = row[6].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
          subject_raw = row[7].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
          grammar_raw = row[8].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
          department = row[9].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
          kannada_pronunciation = row[10].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
          english_meaning_raw = row[11].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
          short_description = row[12].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
          long_description = row[13].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
          administrative_word = row[14].to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')

          word = nil
          meaning = nil
          language_id = nil
          meaning_language_id = nil

          has_kannada_in_ew = !(english_word =~ kannada_regex).nil?
          has_english_in_em = !(english_meaning_raw =~ english_regex).nil?
          has_kannada_in_syn = !(synonyms =~ kannada_regex).nil?
          has_english_in_km = !(kannada_meaning =~ english_regex).nil?
          has_kannada_in_km = !(kannada_meaning =~ kannada_regex).nil?

          if has_kannada_in_ew && has_english_in_em
            word = english_word
            meaning = english_meaning_raw
            language_id = 1
            meaning_language_id = 2
          elsif has_kannada_in_ew && has_kannada_in_syn
            word = english_word
            meaning = synonyms
            language_id = 1
            meaning_language_id = 1
          elsif has_english_in_km && has_kannada_in_syn
            word = kannada_meaning
            meaning = synonyms
            language_id = 2
            meaning_language_id = 1
          else
            if has_kannada_in_ew
              word = english_word
              language_id = 1
            elsif has_english_in_km
              word = kannada_meaning
              language_id = 2
            else
              next
            end
            if has_english_in_em
              meaning = english_meaning_raw
              meaning_language_id = 2
            elsif has_kannada_in_syn
              meaning = synonyms
              meaning_language_id = 1
            else
              meaning = ''
              meaning_language_id = 1
            end
          end
          next if word.nil? || meaning.nil?

          pos = !grammar_raw.strip.empty? ? grammar_raw.strip : subject_raw.strip

          attrs = {
            dictionary: dictionary,
            word: word.strip,
            meaning: meaning.strip,
            pos: pos,
            synonyms: synonyms.strip.empty? ? nil : synonyms,
            department: department.strip.empty? ? nil : department,
            kannada_pronunciation: kannada_pronunciation.strip.empty? ? nil : kannada_pronunciation,
            short_description: short_description.strip.empty? ? nil : short_description,
            long_description: long_description.strip.empty? ? nil : long_description,
            administrative_word: administrative_word.strip.empty? ? nil : administrative_word,
            language_id: language_id,
            meaning_language_id: meaning_language_id
          }
          if Pada.column_names.include?('subject')
            attrs[:subject] = subject_raw.strip.empty? ? nil : subject_raw
          end
          dictionary.padas.create!(attrs)
        end
        puts "Imported #{rows.size} entries for dictionary #{dict_name}"
      end
    end
    puts 'Import finished successfully.'
  end
end
