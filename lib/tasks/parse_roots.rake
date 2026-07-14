namespace :padas do
  LANG_CODE_MAP = {
    'ಸಂ'     => 'ಸಂಸ್ಕೃತ',
    'ದೇ'     => 'ದೇಶ್ಯ',
    'ಅರ'     => 'ಅರಬಿಕ್',
    'ಪಾರ'    => 'ಪಾರಸಿ',
    'ತಮಿ'    => 'ತಮಿಳು',
    'ತೆಲು'   => 'ತೆಲುಗು',
    'ಪ್ರಾ'    => 'ಪ್ರಾಕೃತ',
    'ಹಿಂ'     => 'ಹಿಂದಿ',
    'ಮರಾ'    => 'ಮರಾಠಿ',
    'ಇಂ'      => 'ಇಂಗ್ಲೀಷ್',
    'ಪೋರ್'   => 'ಪೋರ್ಚುಗೀಸ್',
    'ಪಾಳ'    => 'ಪಾಳಿ',
    'ಮಲ'     => 'ಮಲಯಾಳಂ',
    'ತುಳು'   => 'ತುಳು',
    'ಕನ್ನಡ'  => 'ಕನ್ನಡ',
  }.freeze

  LANG_CODES = LANG_CODE_MAP.keys.freeze

  desc "Parse root info from Keshiraja (dict 211) JSON meaning field into root_word/root_language/cognates"
  task parse_keshiraja_roots: :environment do
    dict = Dictionary.find_by(id: 211)
    unless dict
      puts "Dictionary 211 not found"
      exit 1
    end

    total = 0
    skipped = 0

    Pada.where(dictionary_id: 211).find_each do |pada|
      raw = pada.meaning.strip
      parsed = parse_keshiraja_json(raw)
      unless parsed
        skipped += 1
        next
      end

      update = {}
      update[:root_word] = parsed[:kn_root] if parsed[:kn_root].present?
      update[:root_language] = 'ಕನ್ನಡ'
      if parsed[:kn_root_latin].present?
        update[:kannada_pronunciation] = parsed[:kn_root_latin]
      end

      kn_root = pada.word.split('|').first&.strip
      update[:word] = kn_root if kn_root.present?

      parts = []
      parts << "(ಸಂಸ್ಕೃತ) #{parsed[:sa_meaning]}" if parsed[:sa_meaning].present?
      parts << "(ಇಂಗ್ಲೀಷ್) #{parsed[:eng_meaning]}" if parsed[:eng_meaning].present?
      update[:meaning] = parts.join('; ') if parts.any?

      cognates_list = []
      cognates_list << "ಸಂಸ್ಕೃತ: #{parsed[:sa_meaning]}" if parsed[:sa_meaning].present?
      cognates_list << "ಇಂಗ್ಲೀಷ್: #{parsed[:eng_meaning]}" if parsed[:eng_meaning].present?
      update[:cognates] = cognates_list.join(' | ') if cognates_list.any?

      pada.update_columns(update) if update.any?
      total += 1
    end

    puts "Keshiraja: #{total} updated, #{skipped} skipped"
  end

  desc "Parse root info from GV (dict 1) etymology tags in meaning field"
  task parse_gv_roots: :environment do
    dict = Dictionary.find_by(id: 1)
    unless dict
      puts "Dictionary 1 not found"
      exit 1
    end

    total = 0
    skipped = 0

    Pada.where(dictionary_id: 1).where('meaning LIKE ?', '%(<%').find_each do |pada|
      tags = pada.meaning.scan(/\(<([^)]+)\)/)
      next if tags.empty?

      all_languages = []
      all_root_words = []

      tags.each do |(content)|
        langs, roots = parse_gv_tag(content)
        all_languages.concat(langs)
        all_root_words.concat(roots)
      end

      update = {}
      update[:root_language] = all_languages.uniq.join(', ') if all_languages.any?
      update[:root_word] = all_root_words.uniq.join(', ') if all_root_words.any?

      clean_meaning = pada.meaning.gsub(/\(<[^)]+\)\s*/, '').strip
      update[:meaning] = clean_meaning if clean_meaning.present? && clean_meaning != pada.meaning

      pada.update_columns(update) if update.any?
      total += 1
    rescue => e
      skipped += 1
    end

    puts "GV: #{total} updated, #{skipped} skipped"
  end

  desc "Parse simple language tags (LANG_CODE) without root word from GV (dict 1)"
  task parse_gv_simple_tags: :environment do
    lang_pattern = LANG_CODES.join('|')
    regex = /\((#{lang_pattern})\)/

    total = 0
    skipped = 0

    Pada.where(dictionary_id: 1).where('meaning REGEXP ?', '^\\((ಸಂ|ದೇ|ಅರ|ಪಾರ|ತಮಿ|ತೆಲು|ಪ್ರಾ|ಹಿಂ|ಮರಾ|ಇಂ|ಪೋರ್|ಪಾಳ|ಮಲ|ತುಳು|ಕನ್ನಡ)\\)').find_each do |pada|
      next if pada.root_language.present?

      match = pada.meaning.match(regex)
      next unless match

      lang_code = match[1]
      full_name = LANG_CODE_MAP[lang_code]
      next unless full_name

      update = { root_language: full_name }

      clean_meaning = pada.meaning.sub(/\s*\(#{lang_code}\)\s*/, '').strip
      update[:meaning] = clean_meaning if clean_meaning.present? && clean_meaning != pada.meaning

      pada.update_columns(update)
      total += 1
    rescue => e
      skipped += 1
    end

    puts "GV simple tags: #{total} updated, #{skipped} skipped"
  end

  desc "Parse all root entries (Keshiraja + GV + simple tags)"
  task parse_all: :environment do
    Rake::Task['padas:parse_keshiraja_roots'].invoke
    Rake::Task['padas:parse_gv_roots'].invoke
    Rake::Task['padas:parse_gv_simple_tags'].invoke
  end

  def self.parse_keshiraja_json(raw)
    return nil unless raw.start_with?('{')
    data = JSON.parse(raw)
    {
      kn_root: data['kn_root'],
      sa_meaning: data['sa_meaning'],
      kn_root_latin: data['kn_root_latin'],
      eng_meaning: data['eng_meaning'],
    }
  rescue JSON::ParserError
    nil
  end

  def self.parse_gv_tag(content)
    parts = content.strip.split(/[\s.>]+/).reject(&:empty?)
    languages = []
    root_words = []

    parts.each do |part|
      part = part.strip
      next if part.blank?
      if LANG_CODES.include?(part)
        languages << LANG_CODE_MAP[part]
      else
        root_words << part
      end
    end

    [languages.uniq, root_words.uniq]
  end
end
