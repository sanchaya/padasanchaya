require 'csv'

desc "Import from Kanada tables to project"
task :import_gv1 => :environment do
  Kanajadb.table_name = Kanajadb::GV_KN_EN
  dictionary = Dictionary.find_or_create_by(name: Kanajadb::GV_KN_EN)
  kan_lan = Language.find_or_create_by(name: "kannada", lan_code: "kn")
  eng_lan = Language.find_or_create_by(name: "english", lan_code: "en")
  gvdata = Kanajadb.all

  puts "started"
  gvdata.each do |gv|
  	puts gv.inspect
  	Pada.create(word: gv.word, meaning: gv.meaning, dictionary_id: dictionary.id, pos: gv.pos, language_id: kan_lan.id, meaning_language_id: kan_lan.id)
  end
  puts "ended"

end


task :import_gv2 => :environment do
  Kanajadb.table_name = Kanajadb::GV_EN_KN
  dictionary = Dictionary.find_or_create_by(name: Kanajadb::GV_EN_KN)
  kan_lan = Language.find_or_create_by(name: "kannada", lan_code: "kn")
  eng_lan = Language.find_or_create_by(name: "english", lan_code: "en")
  gvdata = Kanajadb.all

  puts "started"
  gvdata.each do |gv|
    puts gv.inspect
    Pada.create(word: gv.word, meaning: gv.meaning, dictionary_id: dictionary.id, pos: gv.pos, language_id: eng_lan.id, meaning_language_id: kan_lan.id)
  end
  puts "ended"

end

task :import_nkvt => :environment do
  Kanajadb.table_name = Kanajadb::NKVT_PA
  dictionary = Dictionary.find_or_create_by(name: Kanajadb::NKVT_PA)
  kan_lan = Language.find_or_create_by(name: "kannada", lan_code: "kn")
  eng_lan = Language.find_or_create_by(name: "english", lan_code: "en")
  table_data = Kanajadb.all

  puts "started"
  table_data.each do |data|
    puts data.inspect
    Pada.create(word: data.word, meaning: data.description, pos: data.meaning, dictionary_id: dictionary.id, language_id: kan_lan.id, meaning_language_id: eng_lan.id)
  end
  puts "ended"

end

task :import_adalitha => :environment do
  Kanajadb.table_name = Kanajadb::ADALITHA_EN_KN
  dictionary = Dictionary.find_or_create_by(name: Kanajadb::ADALITHA_EN_KN)
  kan_lan = Language.find_or_create_by(name: "kannada", lan_code: "kn")
  eng_lan = Language.find_or_create_by(name: "english", lan_code: "en")
  gvdata = Kanajadb.all

  puts "started"
  gvdata.each do |gv|
    puts gv.inspect
    Pada.create(word: gv.text, meaning: gv.meaning, dictionary_id: dictionary.id, language_id: eng_lan.id, meaning_language_id: kan_lan.id)
  end
  puts "ended"

end



desc "Import from csv"
task :import_gv_eng_kan_csv => :environment do
  file_name = Rails.root.to_s + '/lib/gv_eng_kannada.csv'
  puts 'started importing'

  dictionary = Dictionary.find_or_create_by(name: Kanajadb::GV_EN_KN)
  kan_lan = Language.find_or_create_by(name: "kannada", lan_code: "kn")
  eng_lan = Language.find_or_create_by(name: "english", lan_code: "en")

  CSV.foreach(file_name, :col_sep => ',', :headers => true) do |row|
     Pada.create(word: row[0], meaning: row[2], dictionary_id: dictionary.id, pos: row[1], language_id: eng_lan.id, meaning_language_id: kan_lan.id)
  end
end


# description of task
desc 'Import CSV to dictionary table'
# rake task name. Here "import_csv"
task import_krp_pa_csv: :environment do

  # CSV File path
  file_name = Rails.root.to_s+'/lib/krp_pa.csv'
  puts 'started'
  # Read from CSV which has header with coma separated
  CSV.foreach(file_name, col_sep: ',', headers: true) do |row|
    # insert into Padas table by matching CSV row values.
    # Make sure we have created Dictionary and dictionary_id is already present in DB,
    # before running this format as we are creating with Dictionary_id
    Pada.create(word: row['word'], meaning: row['meaning'],
                dictionary_id: row['dictionary_id'],
                pos: row['pos'], language_id: row['language_id'],
                meaning_language_id: row['meaning_language_id'])
    puts row['word']
    puts row['meaning']
    puts '>>>>>>>>>>>>>..'
  end
  puts 'End '

end


# description of task
desc 'Import CSV to dictionary table'
# rake task name. Here "import_csv"
task import_dasa_padakosha_csv: :environment do

  # CSV File path
  file_name = Rails.root.to_s+'/lib/daasa_sahitya.csv'
  puts 'started'
  # Read from CSV which has header with coma separated
  CSV.foreach(file_name, col_sep: ',', headers: true) do |row|
    # insert into Padas table by matching CSV row values.
    # Make sure we have created Dictionary and dictionary_id is already present in DB,
    # before running this format as we are creating with Dictionary_id
    Pada.create(word: row['word'], meaning: row['meaning'],
                dictionary_id: row['dictionary_id'],
                pos: row['pos'], language_id: row['language_id'],
                meaning_language_id: row['meaning_language_id'])
    puts row['word']
    puts row['meaning']
    puts '>>>>>>>>>>>>>..'
  end
  puts 'End '

end
