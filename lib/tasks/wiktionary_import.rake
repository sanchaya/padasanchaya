require 'net/http'
require 'json'
require 'uri'

namespace :wiktionary do
  desc "Import Kannada Wiktionary entries from kn.wiktionary.org"
  task import: :environment do
    base_url = "https://kn.wiktionary.org/w/api.php"
    continue_token = nil
    total_imported = 0
    total_skipped = 0
    batch = 0

    puts "Starting Kannada Wiktionary import..."

    loop do
      batch += 1
      params = {
        action: 'query',
        generator: 'allpages',
        gaplimit: 50,
        gapnamespace: 0,
        prop: 'revisions',
        rvprop: 'content',
        format: 'json',
        formatversion: 2
      }
      params[:gapcontinue] = continue_token if continue_token

      uri = URI(base_url)
      uri.query = URI.encode_www_form(params)

      begin
        response = Net::HTTP.get_response(uri)
        
        if response.code == '429'
          puts "Rate limited (HTTP 429). Waiting 30 seconds before retry..."
          sleep 30
          response = Net::HTTP.get_response(uri)
        end
        
        unless response.is_a?(Net::HTTPSuccess)
          puts "HTTP error: #{response.code} - #{response.message}"
          break
        end

        data = JSON.parse(response.body)
      rescue => e
        puts "API error: #{e.message}"
        break
      end

      pages = data.dig('query', 'pages') || []
      puts "Batch #{batch}: fetched #{pages.size} pages"

      pages.each do |page|
        title = page['title']
        revisions = page['revisions']
        next unless revisions && revisions.any?

        content = revisions.first['content']
        next if content.blank?

        # Skip non-article pages (templates, categories, etc.)
        next if title.start_with?('MediaWiki:', 'Template:', 'Category:', 'Module:', 'Help:')

        meanings = extract_kannada_meanings(content)
        next if meanings.empty?

        # Use the first meaning as primary, join others
        primary_meaning = meanings.first
        all_meanings = meanings.join("; ")

        pos = extract_pos(content)

        entry = WiktionaryEntry.find_or_initialize_by(page_title: title)
        entry.word = title
        entry.meaning = all_meanings
        entry.pos = pos
        entry.language = 'kn'
        entry.raw_content = content[0..5000] # store truncated content

        if entry.new_record?
          entry.save!
          total_imported += 1
        else
          total_skipped += 1
        end
      end

      puts "  Imported: #{total_imported}, Skipped: #{total_skipped}"

      continue_token = data.dig('continue', 'gapcontinue')
      break unless continue_token

      # Longer delay to avoid rate limiting (429 errors)
      # Wiktionary has rate limits, be respectful
      sleep 2.0
    end

    puts "\n=== Import Complete ==="
    puts "Total imported: #{total_imported}"
    puts "Total skipped (already exists): #{total_skipped}"
    puts "Total Wiktionary entries: #{WiktionaryEntry.count}"
  end

  # Extract Kannada meanings from wiki markup
  def extract_kannada_meanings(content)
    meanings = []

    # Find the Kannada section
    # Match ==ಕನ್ನಡ== or == ಕನ್ನಡ == with possible extra chars
    kannada_match = content.match(/==\s*ಕನ್ನಡ\s*==/m)
    return meanings unless kannada_match

    # Get text from Kannada section until next ==...== section
    start_idx = kannada_match.end(0)
    end_match = content.index(/\n==[^=]/, start_idx)
    section = end_match ? content[start_idx...end_match] : content[start_idx..-1]

    return meanings unless section

    # Extract lines starting with # (definitions)
    section.each_line do |line|
      line = line.strip
      if line.start_with?('#') && !line.start_with?('##')
        # Clean up the definition
        meaning = line.sub(/^#+\s*/, '')
        # Remove wiki links [[...]]
        meaning = meaning.gsub(/\[\[([^\]|]+)(?:\|[^\]]+)?\]\]/, '\1')
        # Remove templates {{...}}
        meaning = meaning.gsub(/\{\{[^}]+\}\}/, '')
        # Remove HTML tags
        meaning = meaning.gsub(/<[^>]+>/, '')
        # Remove extra formatting
        meaning = meaning.gsub(/''+/,'').gsub(/'''+/,'')
        meaning = meaning.strip

        meanings << meaning if meaning.present? && meaning.length < 500
      end
    end

    meanings
  end

  # Try to extract part of speech from wiki markup
  def extract_pos(content)
    pos_map = {
      'ನಾಮಪದ' => 'ನಾಮಪದ',
      'ಕ್ರಿಯಾಪದ' => 'ಕ್ರಿಯಾಪದ',
      'ವಿಶೇಷಣ' => 'ವಿಶೇಷಣ',
      'ಕ್ರಿಯಾವಿಶೇಷಣ' => 'ಕ್ರಿಯಾವಿಶೇಷಣ',
      'ಸಮಾಸ' => 'ಸಮಾಸ',
      'ಪದಬಂಧ' => 'ಪದಬಂಧ',
      'ಪರ್ಯಾಯ ಪದ' => 'ಪರ್ಯಾಯ ಪದ',
      'ವ್ಯಾಕರಣ' => 'ವ್ಯಾಕರಣ',
      'ಅವ್ಯಯ' => 'ಅವ್ಯಯ'
    }

    pos_map.each do |pattern, label|
      return label if content.include?("===#{pattern}===") || content.include?("=== #{pattern} ===")
    end

    nil
  end
end
