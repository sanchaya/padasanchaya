require 'open-uri'
require 'csv'

namespace :indic_dict do
  REPO_URL = 'https://github.com/indic-dict/stardict-kannada'
  RAW_BASE = 'https://raw.githubusercontent.com/indic-dict/stardict-kannada/master'

  DICTIONARIES = {
    alar: {
      path: 'kn-head/en-entries/alar/alar.babylon',
      name: 'Alar (kn-en)',
      description: 'Alar Kannada-English dictionary by V. Krishna — https://github.com/alar-dict/data (ODbL)',
      language_id: 1,
      meaning_language_id: 2
    },
    kittel: {
      path: 'kn-head/en-entries/kittel/kittel.babylon',
      name: 'Kittel (kn-en)',
      description: 'Kittel Kannada-English dictionary from indic-dict/stardict-kannada',
      language_id: 1,
      meaning_language_id: 2
    },
    mysore_uni_eng_kn: {
      path: 'en-head/mysore_uni_eng_kn/mysore_uni_eng_kn.babylon',
      name: 'Mysore University (en-kn)',
      description: 'Mysore University English-Kannada dictionary from indic-dict/stardict-kannada',
      language_id: 2,
      meaning_language_id: 1
    },
    keshiraja: {
      path: 'kn-head/en-entries/keshirAja/keshirAja.babylon',
      name: 'Keshiraja (kn-en)',
      description: 'Keshiraja Kannada-English dictionary from indic-dict/stardict-kannada',
      language_id: 1,
      meaning_language_id: 2
    },
    ka_ga_pa_2014: {
      path: 'kn-head/en-entries/ka-ga-pa_2014/ka-ga-pa_2014.babylon',
      name: 'Ka-ga-pa 2014 (kn-en)',
      description: 'Ka-ga-pa Kannada-English dictionary (2014) from indic-dict/stardict-kannada',
      language_id: 1,
      meaning_language_id: 2
    },
    maisUru_vishvakosha_1: {
      path: 'kn-head/kn-entries/maisUru-vishvakosha_1/maisUru-vishvakosha_1.babylon',
      name: 'Maisuru Vishvakosha 1 (kn-kn)',
      description: 'Maisuru Vishvakosha part 1 (indic-dict/stardict-kannada)',
      language_id: 1,
      meaning_language_id: 1
    },
    maisUru_vishvakosha_2: {
      path: 'kn-head/kn-entries/maisUru-vishvakosha_2/maisUru-vishvakosha_2.babylon',
      name: 'Maisuru Vishvakosha 2 (kn-kn)',
      description: 'Maisuru Vishvakosha part 2 (indic-dict/stardict-kannada)',
      language_id: 1,
      meaning_language_id: 1
    },
    maisUru_vishvakosha_3: {
      path: 'kn-head/kn-entries/maisUru-vishvakosha_3/maisUru-vishvakosha_3.babylon',
      name: 'Maisuru Vishvakosha 3 (kn-kn)',
      description: 'Maisuru Vishvakosha part 3 (indic-dict/stardict-kannada)',
      language_id: 1,
      meaning_language_id: 1
    },
    maisUru_vishvakosha_4: {
      path: 'kn-head/kn-entries/maisUru-vishvakosha_4/maisUru-vishvakosha_4.babylon',
      name: 'Maisuru Vishvakosha 4 (kn-kn)',
      description: 'Maisuru Vishvakosha part 4 (indic-dict/stardict-kannada)',
      language_id: 1,
      meaning_language_id: 1
    },
    champU_nuDi_gannaDi: {
      path: 'kn-head/kn-entries/champU-nuDi-gannaDi/champU-nuDi-gannaDi.babylon',
      name: 'Champu Nudi Gannadi (kn-kn)',
      description: 'Champu Nudi Gannadi Kannada-Kannada dictionary from indic-dict/stardict-kannada',
      language_id: 1,
      meaning_language_id: 1
    },
    haLe_gannaDa_pada_sampada: {
      path: 'kn-head/kn-entries/haLe-gannaDa-pada-sampada/haLe-gannaDa-pada-sampada.babylon',
      name: 'Hale Gannada Pada Sampada (kn-kn)',
      description: 'Hale Gannada Pada Sampada Kannada-Kannada dictionary from indic-dict/stardict-kannada',
      language_id: 1,
      meaning_language_id: 1
    },
    janapada_vastu_kosha: {
      path: 'kn-head/kn-entries/janapada-vastu-kosha/janapada-vastu-kosha.babylon',
      name: 'Janapada Vastu Kosha (kn-kn)',
      description: 'Janapada Vastu Kosha Kannada-Kannada dictionary from indic-dict/stardict-kannada',
      language_id: 1,
      meaning_language_id: 1
    },
    kumAravyAsa: {
      path: 'kn-head/kn-entries/kumAravyAsa/kumAravyAsa.babylon',
      name: 'Kumaravyasa (kn-kn)',
      description: 'Kumaravyasa Kannada-Kannada dictionary from indic-dict/stardict-kannada',
      language_id: 1,
      meaning_language_id: 1
    },
    pampana_nuDi_gaNi: {
      path: 'kn-head/kn-entries/pampana-nuDi-gaNi/pampana-nuDi-gaNi.babylon',
      name: 'Pampana Nudi Gani (kn-kn)',
      description: 'Pampana Nudi Gani Kannada-Kannada dictionary from indic-dict/stardict-kannada',
      language_id: 1,
      meaning_language_id: 1
    },
    sanxipta_kannaDa_nighaNTu: {
      path: 'kn-head/kn-entries/sanxipta-kannaDa-nighaNTu-ka-sa-pa/sanxipta-kannaDa-nighaNTu-ka-sa-pa.babylon',
      name: 'Sanxipta Kannada Nighantu (kn-kn)',
      description: 'Sanxipta Kannada Nighantu Kannada-Kannada dictionary from indic-dict/stardict-kannada',
      language_id: 1,
      meaning_language_id: 1
    },
    shrIvatsa_nighaNTu: {
      path: 'kn-head/kn-entries/shrIvatsa-nighaNTu/shrIvatsa-nighaNTu.babylon',
      name: 'Shrivatsa Nighantu (kn-kn)',
      description: 'Shrivatsa Nighantu Kannada-Kannada dictionary from indic-dict/stardict-kannada',
      language_id: 1,
      meaning_language_id: 1
    },
    kumAravyAsa_kosha: {
      path: 'kosha-mUlagaLu/kumAravyAsa-kosha/kumAravyAsa-kosha.tsv',
      name: 'Kumaravyasa Kosha (kn-kn)',
      description: 'Kumaravyasa Kosha glossary from Mahabharata (indic-dict/stardict-kannada)',
      language_id: 1,
      meaning_language_id: 1,
      format: :tsv
    },
    kagga: {
      path: 'kn-kAvya/kagga/kagga.csv',
      name: 'Mankutimma Kagga (kn-en)',
      description: 'Mankutimma Kagga poetry with Kannada and English meanings (indic-dict/stardict-kannada)',
      language_id: 1,
      meaning_language_id: 2,
      format: :csv_kagga
    }
  }.freeze

  desc "Import dictionaries from indic-dict/stardict-kannada"
  task import: :environment do
    require 'tempfile'
    require 'fileutils'

    temp_dir = Dir.mktmpdir('indic_dict')
    puts "Created temp dir: #{temp_dir}"

    begin
      kan_lan = Language.find_or_create_by!(name: "kannada", lan_code: "kn")
      eng_lan = Language.find_or_create_by!(name: "english", lan_code: "en")

      DICTIONARIES.each do |key, config|
        puts "\n=== Importing #{config[:name]} ==="
        import_dictionary(key, config, temp_dir, kan_lan, eng_lan)
      end

      puts "\n=== All imports complete ==="
    ensure
      FileUtils.remove_entry(temp_dir) if temp_dir
    end
  end

  def self.import_dictionary(key, config, temp_dir, kan_lan, eng_lan)
    dict = Dictionary.find_or_create_by!(name: config[:name]) do |d|
      d.description = config[:description]
    end

    if dict.padas.exists?
      puts "  Already imported (#{dict.padas.count} entries). Skipping."
      return
    end

    format = config[:format] || :babylon
    file_path = File.join(temp_dir, File.basename(config[:path]))
    url = "#{RAW_BASE}/#{config[:path]}"

    begin
      puts "Downloading #{url}..."
      download_file(url, file_path)
    rescue OpenURI::HTTPError => e
      puts "  #{e.message} — skipping #{config[:name]}"
      return
    end

    case format
    when :babylon
      import_babylon(dict, config, file_path)
    when :tsv
      import_tsv(dict, config, file_path)
    when :csv_kagga
      import_csv_kagga(dict, config, file_path)
    end
  end

  def self.download_file(url, dest)
    URI.open(url) do |remote|
      File.open(dest, 'wb') { |f| f.write(remote.read) }
    end
  end

  def self.import_babylon(dict, config, file_path)
    content = File.read(file_path, encoding: 'UTF-8')
    lines = content.lines.map { |l| l.strip }

    inserted = 0
    skipped = 0
    current_word = nil
    current_meaning = []
    batch = []

    lines.each do |line|
      if line.start_with?('#')
        next
      elsif line.empty?
        if current_word
          meaning = sanitize_meaning(current_meaning.join("\n"))
          if meaning.present?
            batch << {
              word: current_word[0, 255],
              meaning: meaning[0, 16777215],
              dictionary_id: dict.id,
              language_id: config[:language_id],
              meaning_language_id: config[:meaning_language_id]
            }
          end
          current_word = nil
          current_meaning = []
        end
      elsif current_word.nil?
        current_word = line
      else
        current_meaning << line
      end
    end

    if current_word
      meaning = sanitize_meaning(current_meaning.join("\n"))
      if meaning.present?
        batch << {
          word: current_word[0, 255],
          meaning: meaning[0, 16777215],
          dictionary_id: dict.id,
          language_id: config[:language_id],
          meaning_language_id: config[:meaning_language_id]
        }
      end
    end

    puts "  Parsed #{batch.size} entries. Inserting into padas..."

    batch.each_slice(500) do |slice|
      slice.each do |entry|
        begin
          Pada.create!(entry)
          inserted += 1
        rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
          skipped += 1
        end
      end
    end

    puts "  Inserted: #{inserted}, Skipped: #{skipped}"
  end

  def self.import_tsv(dict, config, file_path)
    inserted = 0
    skipped = 0

    CSV.foreach(file_path, col_sep: "\t", headers: true, encoding: 'UTF-8') do |row|
      word = row['Pada']&.strip
      meaning = row['Artha1']&.strip
      next if word.blank? || meaning.blank?

      begin
        Pada.create!(
          word: word[0, 255],
          meaning: meaning[0, 16777215],
          dictionary_id: dict.id,
          language_id: config[:language_id],
          meaning_language_id: config[:meaning_language_id]
        )
        inserted += 1
      rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
        skipped += 1
      end
    end

    puts "  Inserted: #{inserted}, Skipped: #{skipped}"
  end

  def self.import_csv_kagga(dict, config, file_path)
    inserted = 0
    skipped = 0

    CSV.foreach(file_path, headers: false, encoding: 'UTF-8') do |row|
      word = row[0]&.strip
      meaning = [row[2], row[3]].compact.reject(&:blank?).join(' | ')
      next if word.blank? || meaning.blank?

      begin
        Pada.create!(
          word: word[0, 255],
          meaning: meaning[0, 16777215],
          dictionary_id: dict.id,
          language_id: config[:language_id],
          meaning_language_id: config[:meaning_language_id]
        )
        inserted += 1
      rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
        skipped += 1
      end
    end

    puts "  Inserted: #{inserted}, Skipped: #{skipped}"
  end

  def self.sanitize_meaning(text)
    text = text.gsub(%r{<[^>]+>}, ' ')  # strip HTML tags
    text = text.gsub(/\s+/, ' ')          # collapse whitespace
    text = text.gsub(/\s*;\s*/, '; ')     # normalize semicolons
    text.strip
  end
end
