# Dictionary Import Guide

This document describes how dictionary data is imported and managed in Pada Sanchaya.

## Overview

The application supports three types of dictionaries:
1. **Old/Legacy Dictionaries** (IDs 1-10) — Pre-existing before ZIP import
2. **ZIP Dictionaries** (IDs 11-121) — Imported from dictionary ZIP archive
3. **Kannada Wiktionary** — Imported from kn.wiktionary.org (see WIKTIONARY_IMPORT.md)

## ZIP Dictionary Import

### Source File

- **File**: Dictionary ZIP archive (in Rails root)
- **Format**: ZIP archive containing CSV files
- **Total dictionaries**: 92
- **Total entries**: 593,113

### CSV Format

Each CSV file contains rows with these columns:
- `dict_id` — Dictionary ID
- `dict_name` — Dictionary name in Kannada
- `dict_english_name` — English name
- `kannada_word` — Word in Kannada
- `english_word` — Word in English
- `kannada_meaning`, `english_meaning` — Meanings
- `synonyms`, `subject`, `grammar`, `department` — Additional metadata

### Import Steps

#### 1. Import into dictionary_entries (raw data)

```bash
rails dictionaries:import RAILS_ENV=production
```

This:
- Extracts each CSV from the ZIP
- Creates/updates records in `dictionary_entries` table
- Tracks per-file statistics in `dictionary_file_stats`

#### 2. Import into padas (searchable format)

```bash
rails dictionaries:import_into_padas RAILS_ENV=production
```

This:
- Groups entries by `dict_id`
- Creates `Dictionary` records if not present
- Creates `Pada` records (word, meaning, pos, dictionary_id)
- Links to existing language IDs (1=Kannada, 2=English)

## Data Architecture

### Tables

**dictionary_entries** — Raw imported data
```
+ id, dict_id, dict_name, dict_english_name
+ kannada_word, english_word, kannada_meaning, english_meaning
+ synonyms, subject, grammar, department
+ timestamps
```

**dictionary_file_stats** — Import tracking
```
+ file_name, table_name, dict_id
+ dict_name, dict_english_name, total_entries
+ source_file_path, timestamps
```

**padas** — Searchable normalized data
```
+ word, meaning, pos, language_id, meaning_language_id, dictionary_id
+ synonyms, department, kannada_pronunciation
+ short_description, long_description, administrative_word
+ root_language, root_word, cognates
```

**dictionaries** — Dictionary metadata
```
+ name, core_name, description
+ dictionary_type, category, multilingual
+ publisher, published_year, total_entries
+ show_name_in_search, timestamps
```

### Dictionary ID Ranges

| Range | Type | Count |
|-------|------|-------|
| 1-10 | Old/Legacy | 10 (pre-existing) |
| 11-121 | ZIP Dictionaries | 92 (from ZIP file) |
| 122+ | Stardict / Indic-Dict | Added dynamically |

## Indic-Dict Stardict-Kannada Import

The [indic-dict/stardict-kannada](https://github.com/indic-dict/stardict-kannada) repository
contains Kannada dictionaries in Babylon (.babylon), TSV, and CSV formats.

### Dictionaries imported

| Dictionary | Source | Type |
|------------|--------|------|
| Alar (kn-en) (ODbL) | `kn-head/en-entries/alar/alar.babylon` | Babylon |
| Kittel (kn-en) | `kn-head/en-entries/kittel/kittel.babylon` | Babylon |
| Mysore University (en-kn) | `en-head/mysore_uni_eng_kn/mysore_uni_eng_kn.babylon` | Babylon |
| Keshiraja (kn-en) | `kn-head/en-entries/keshirAja/keshirAja.babylon` | Babylon |
| Ka-ga-pa 2014 (kn-en) | `kn-head/en-entries/ka-ga-pa_2014/ka-ga-pa_2014.babylon` | Babylon |
| Maisuru Vishvakosha 1-4 (kn-kn) | `kn-head/kn-entries/maisUru-vishvakosha_{1..4}/` | Babylon |
| Champu Nudi Gannadi (kn-kn) | `kn-head/kn-entries/champU-nuDi-gannaDi/champU-nuDi-gannaDi.babylon` | Babylon |
| Hale Gannada Pada Sampada (kn-kn) | `kn-head/kn-entries/haLe-gannaDa-pada-sampada/haLe-gannaDa-pada-sampada.babylon` | Babylon |
| Janapada Vastu Kosha (kn-kn) | `kn-head/kn-entries/janapada-vastu-kosha/janapada-vastu-kosha.babylon` | Babylon |
| Kumaravyasa (kn-kn) | `kn-head/kn-entries/kumAravyAsa/kumAravyAsa.babylon` | Babylon |
| Pampana Nudi Gani (kn-kn) | `kn-head/kn-entries/pampana-nuDi-gaNi/pampana-nuDi-gaNi.babylon` | Babylon |
| Sanxipta Kannada Nighantu (kn-kn) | `kn-head/kn-entries/sanxipta-kannaDa-nighaNTu-ka-sa-pa/sanxipta-kannaDa-nighaNTu-ka-sa-pa.babylon` | Babylon |
| Shrivatsa Nighantu (kn-kn) | `kn-head/kn-entries/shrIvatsa-nighaNTu/shrIvatsa-nighaNTu.babylon` | Babylon |
| Mankutimma Kagga (kn-en) | `kn-kAvya/kagga/kagga.csv` | CSV |
| Kumaravyasa Kosha (kn-kn) | `kosha-mUlagaLu/kumAravyAsa-kosha/kumAravyAsa-kosha.tsv` | TSV |

### Import command

```bash
rails indic_dict:import RAILS_ENV=production
```

This downloads each dictionary file from GitHub, parses it, and inserts entries into
the `padas` table (deduplicating by word/meaning/dictionary_id). Already-imported
dictionaries (those with existing `Pada` records) are automatically skipped.

## Part of Speech (POS) and Grammar Tags

The `padas` table stores POS (part of speech) information in the `pos` column.
This data comes from several sources:

- **ZIP dictionaries**: The `subject` and `grammar` CSV columns are mapped to `pos`
- **JanaSanchaya community entries**: Users can select POS from a predefined list
- **Wiktionary**: POS is extracted from Wiktionary page structure

### Display

POS tags are displayed in the public search results as labeled badges:
- **Blue badges** for POS (noun, verb, adjective, etc.)
- **Red badges** for root language origin (ಸಂಸ್ಕೃತ, ಇಂಗ್ಲೀಷ್, etc.)
- **Purple badges** for pronunciation (/kannada/)

On the admin dictionary detail page, POS and root language distributions are
visualized with horizontal bar charts showing the top 10 values.

## Admin Dictionary Management

### Index Page (`/admin/dictionaries`)

The admin dictionary list shows:
- **Summary cards**: Total dictionaries, total entries, POS-tagged entries, root-language-tagged entries
- **Table columns**: ID, name, core name, type, category, publisher, year, entry count, POS count, root language count, actions

### Show Page (`/admin/dictionaries/:id`)

Each dictionary detail page includes:
- **Metadata panel**: All dictionary attributes (type, category, multilingual, publisher, year, etc.)
- **Stats cards**: Total entries, entries with POS, entries with root language, entries with synonyms
- **POS distribution chart**: Horizontal bar chart of top 10 POS tags
- **Root language distribution chart**: Horizontal bar chart of top 10 root languages
- **Searchable entries table**: Paginated list of entries with POS and root language badges

### Edit Page (`/admin/dictionaries/:id/edit`)

Edit form with sections:
- Basic info (name, core name, description)
- Classification (type, category, multilingual)
- Publishing info (publisher, year, total entries)
- Search settings (show_name_in_search)

## Stats Page

The `/stats` page aggregates data from all sources:

- **All Dictionaries**: Each dictionary with entry count
- **Vachana Sanchaya**: Glossary entries from vachana.sanchaya.net
- **Indic-Dict Stardict**: Per-dictionary counts
- **Wiktionary**: Entries from kn.wiktionary.org

## Legacy Import Rake Tasks

Several legacy rake tasks exist in `lib/tasks/`:

- `dictionary_import.rake` — Main ZIP import to `dictionary_entries`
- `import_into_padas.rake` — Maps ZIP data to `padas`
- `integrate_dictionaries.rake` — Integration helper
- `fix_all_names.rake` — Name fixing utility

## Known Issues

### Overlapping Dictionary IDs
Old dictionaries (IDs 1-78) may overlap with ZIP dictionary IDs if IDs were reused. The stats controller only counts old dictionaries as IDs 1-10 to avoid confusion.

### Duplicate Padas
If a dictionary is re-imported, duplicate `padas` rows may be created. Use the import tasks' deduplication logic, or clean up manually:

```sql
-- Remove exact duplicates (keeping lowest id)
DELETE p1 FROM padas p1
INNER JOIN padas p2
WHERE p1.id > p2.id
  AND p1.word = p2.word
  AND p1.meaning = p2.meaning
  AND p1.dictionary_id = p2.dictionary_id;
```

## FAQ

**Q: Can I re-import the ZIP file?**
A: Yes. Running `rails dictionaries:import` will update existing entries and add new ones.

**Q: The stats page shows wrong numbers for old dictionaries.**
A: After mixing old and ZIP data in `padas`, IDs 11-78 may contain mixed data. The stats controller filters to only show IDs 1-10 as "old dictionaries."

**Q: How do I clean up old overlapping dictionaries?**
A: Delete `padas` where `dictionary_id` is between 11-78, then re-import:
```sql
DELETE FROM padas WHERE dictionary_id BETWEEN 11 AND 78;
DELETE FROM dictionaries WHERE id BETWEEN 11 AND 78;
```
Then run `rails dictionaries:import_into_padas`.

**Q: How do I check if a dictionary has already been imported?**
A: The stardict import (`rails indic_dict:import`) now checks `dict.padas.exists?` before importing — dictionaries with existing entries are skipped automatically.
