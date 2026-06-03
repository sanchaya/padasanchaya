class StatsController < ApplicationController
  def index
    @page_title = 'ಅಂಕಿಅಂಶಗಳು - ಪದ ಸಂಚಯ'
    @page_description = 'ಪದ ಸಂಚಯ ಯೋಜನೆಯ ಅಂಕಿಅಂಶಗಳು. ಒಟ್ಟು ನಿಘಂಟುಗಳು, ಒಟ್ಟು ನಮೂದುಗಳ ಸಂಖ್ಯೆ ಮತ್ತು ಪ್ರತಿ ನಿಘಂಟಿನ ವಿವರ.'
    @breadcrumb_json = '{"@type":"ListItem","position":2,"name":"ಅಂಕಿಅಂಶಗಳು","item":"https://pada.sanchaya.net/stats"}'
    # All dictionaries with padas count
    @dictionaries = Dictionary.left_joins(:padas)
                              .select('dictionaries.*, COUNT(padas.id) as pada_count')
                              .group('dictionaries.id')
                              .order(:id)

    @total_dictionaries = Dictionary.count
    @total_all_entries = Pada.count + WiktionaryEntry.count

    # Wiktionary stats
    @wiktionary_count = WiktionaryEntry.count

    # Vachana Sanchaya stats
    vachana_dict = Dictionary.where('name LIKE ?', '%vachana%').first
    @vachana_count = vachana_dict ? Pada.where(dictionary_id: vachana_dict.id).count : 0
  end
end
