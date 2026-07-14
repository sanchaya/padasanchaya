# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2026_06_03_000002) do

  create_table "adalita_kannada", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "text", limit: 45, null: false
    t.string "meaning", limit: 250
  end

  create_table "admin_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.string "username"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["username"], name: "index_admin_users_on_username", unique: true
  end

  create_table "champu_nudigannadi", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "word"
    t.text "meaning"
    t.string "pos", limit: 500
    t.bigint "language_id"
    t.integer "meaning_language_id"
    t.bigint "dictionary_id"
  end

  create_table "daasa_sahitya_kosha", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "word", limit: 500
    t.string "meaning", limit: 1000
  end

  create_table "dictionaries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description", limit: 16777215
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "original_name"
  end

  create_table "dictionary_entries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "dict_id", null: false
    t.string "dict_name"
    t.string "dict_english_name"
    t.text "kannada_word"
    t.text "english_word"
    t.text "kannada_meaning"
    t.text "synonyms"
    t.text "subject"
    t.text "grammar"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "english_meaning"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dict_english_name"], name: "index_dictionary_entries_on_dict_english_name"
    t.index ["dict_id"], name: "index_dictionary_entries_on_dict_id"
    t.index ["english_word"], name: "index_dictionary_entries_on_english_word", length: 255
    t.index ["kannada_word"], name: "index_dictionary_entries_on_kannada_word", length: 255
  end

  create_table "dictionary_file_stats", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "file_name", null: false
    t.string "table_name", null: false
    t.string "dict_name"
    t.string "dict_english_name"
    t.integer "dict_id"
    t.integer "total_entries", default: 0
    t.string "source_file_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_name"], name: "index_dictionary_file_stats_on_file_name", unique: true
    t.index ["table_name", "dict_id"], name: "index_dictionary_file_stats_on_table_name_and_dict_id", unique: true
  end

  create_table "gv_eng_kannada", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "word", limit: 100
    t.string "pos", limit: 500
    t.string "meaning", limit: 1000
  end

  create_table "gv_kan_english", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "word", limit: 100
    t.string "pos", limit: 500
    t.string "meaning", limit: 1000
  end

  create_table "halagannada_pada", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "word"
    t.text "meaning"
    t.string "pos", limit: 500
    t.bigint "language_id"
    t.integer "meaning_language_id"
    t.bigint "dictionary_id"
  end

  create_table "jaina_paribhashika", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "word", limit: 23
    t.string "meaning", limit: 444
    t.integer "language_id"
    t.integer "meaning_language_id"
    t.integer "dictionary_id"
  end

  create_table "jana_sanchaya_entries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word", null: false
    t.string "meaning", null: false
    t.string "pos"
    t.bigint "language_id", default: 1
    t.bigint "dictionary_id", default: 208
    t.string "user_ip"
    t.integer "votes_up", default: 0
    t.integer "votes_down", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contributor_name"
    t.string "contributor_email"
    t.string "current_place"
    t.string "dialect_place"
    t.string "dialect_name"
    t.boolean "is_dialect", default: false
    t.string "transliteration"
    t.text "meaning_in_english"
    t.text "synonyms"
    t.text "antonyms"
    t.text "usage_example"
    t.text "etymology"
    t.string "ecological_domain"
    t.text "cultural_notes"
    t.string "status", default: "pending"
    t.string "root_language"
    t.string "root_word"
    t.text "cognates"
    t.index ["created_at"], name: "index_jana_sanchaya_entries_on_created_at"
    t.index ["dialect_name"], name: "index_jana_sanchaya_entries_on_dialect_name"
    t.index ["ecological_domain"], name: "index_jana_sanchaya_entries_on_ecological_domain"
    t.index ["is_dialect"], name: "index_jana_sanchaya_entries_on_is_dialect"
    t.index ["root_language"], name: "index_jana_sanchaya_entries_on_root_language"
    t.index ["status"], name: "index_jana_sanchaya_entries_on_status"
    t.index ["votes_up"], name: "index_jana_sanchaya_entries_on_votes_up"
    t.index ["word", "dictionary_id"], name: "index_jana_sanchaya_entries_on_word_and_dictionary_id"
  end

  create_table "jana_sanchaya_votes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "jana_sanchaya_entry_id", null: false
    t.string "user_ip", null: false
    t.string "vote_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jana_sanchaya_entry_id", "user_ip"], name: "index_jana_votes_on_entry_and_ip", unique: true
    t.index ["jana_sanchaya_entry_id"], name: "index_jana_sanchaya_votes_on_jana_sanchaya_entry_id"
  end

  create_table "janapada_vastukosha", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "word"
    t.text "meaning"
    t.string "pos", limit: 500
    t.bigint "language_id"
    t.integer "meaning_language_id"
    t.bigint "dictionary_id"
  end

  create_table "kanaja_dictionary", id: false, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "serial_number", default: 0, null: false
    t.string "word", limit: 45
    t.integer "word_type"
    t.string "meaning", limit: 706
    t.string "E", limit: 10
    t.string "F", limit: 10
    t.string "G", limit: 10
    t.string "H", limit: 10
    t.integer "I"
    t.string "J", limit: 10
    t.string "K", limit: 10
    t.string "L", limit: 10
    t.integer "dictionary_type"
    t.index ["word"], name: "word"
  end

  create_table "kanaja_dictionary1", id: false, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "serial_number", default: 0, null: false
    t.string "word", limit: 45
    t.integer "word_type"
    t.string "meaning", limit: 706
    t.text "E"
    t.string "F", limit: 10
    t.string "G", limit: 10
    t.string "H", limit: 10
    t.integer "I"
    t.string "J", limit: 10
    t.string "K", limit: 10
    t.string "L", limit: 10
    t.integer "dictionary_type"
    t.index ["word"], name: "word"
  end

  create_table "kasapa_nigantu", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "word"
    t.text "meaning"
    t.string "pos", limit: 500
    t.bigint "language_id"
    t.integer "meaning_language_id"
    t.bigint "dictionary_id"
  end

  create_table "krp_pa", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "word", limit: 100
    t.string "meaning", limit: 1000
  end

  create_table "languages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "lan_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nkvt_pa", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "word", limit: 1000
    t.string "description", limit: 1000
    t.string "meaning", limit: 1000
  end

  create_table "padas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.text "word"
    t.text "meaning", limit: 16777215
    t.text "pos", limit: 16777215
    t.bigint "language_id"
    t.integer "meaning_language_id"
    t.bigint "dictionary_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "synonyms", limit: 16777215
    t.text "department", limit: 16777215
    t.text "kannada_pronunciation", limit: 16777215
    t.text "short_description", limit: 16777215
    t.text "long_description", limit: 16777215
    t.text "administrative_word", limit: 16777215
    t.string "root_language"
    t.string "root_word"
    t.text "cognates"
    t.index ["dictionary_id"], name: "index_padas_on_dictionary_id"
    t.index ["language_id"], name: "index_padas_on_language_id"
    t.index ["root_language"], name: "index_padas_on_root_language"
  end

  create_table "pampana_nudigani", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "word"
    t.text "meaning"
    t.string "pos", limit: 500
    t.bigint "language_id"
    t.integer "meaning_language_id"
    t.bigint "dictionary_id"
  end

  create_table "pracheena_padakosha", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "word", limit: 19
    t.string "meaning", limit: 42
    t.integer "language_id"
    t.integer "meaning_language_id"
    t.integer "dictionary_id"
  end

  create_table "tmp_aantriklekkprish", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_aarthikvibhaagsn", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_aayurveediyshaar", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_accgnndddeehaavy", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_accgnnddpraannip", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_alrvikrssnnknndd", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_arnnyshaastrpaar", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_beesaayshaastrpa", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_bhdrtemttujaagrt", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_daassaahitykoosh", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_gnnkvibhaagsnkss", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_grnthsnpaadnprib", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_hainugaarikepaar", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_hllgnnddpdsnpdkn", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_iaaddllitpdrcnaa", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_ingliissknnddaud", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_ingliissknnddpdk", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_ingliissknnddvij", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_jiiviingliissknn", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_jiiviknnddknnddn", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_jiivshaastrpaari", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_kaanuunuvibhaags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_kiittshaastrpaar", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_knnddingliissnig", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_knnddjaanpdnighn", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_knnddrtnkooshknn", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_knpyuuttrtntrjny", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_krssienjiniyring", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_krssirsaaynshaas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_krssissyshaastrp", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_krssisuukssmjiiv", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_krssivijnyaanpdk", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_kunbaarikevrttip", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_kuvenpusaahitypd", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_miinugaarikepaar", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_nvkrnaattkaaddll", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_nvkrnaattkvijnya", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_paaribhaassikpdg", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_phnddmenttladdmi", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_pshuvaidykiiymtt", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_ptrikaanighnttue", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_shaankrveedaantn", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_sncaarvibhaagsnk", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_snkssiptaaddllit", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_snkssiptknnddnig", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_toottgaarikeilaa", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_toottgaarikepaar", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_trbeetivibhaagsn", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_ugraannvibhaagsn", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "tmp_vishvvidyaalypdk", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.text "pos"
    t.text "synonyms"
    t.text "department"
    t.text "kannada_pronunciation"
    t.text "short_description"
    t.text "long_description"
    t.text "administrative_word"
  end

  create_table "vivaranatmaka_padakosha", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "word", limit: 1000
    t.string "meaning", limit: 1000
    t.string "description", limit: 1000
  end

  create_table "wiktionary_entries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "word"
    t.text "meaning"
    t.string "pos"
    t.string "page_title"
    t.string "language"
    t.text "raw_content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "padas", "dictionaries"
  add_foreign_key "padas", "languages"
end
