# Padakannaja Dictionary Portal

A multilingual dictionary portal for Kannada language, supporting multiple dictionary sources including legacy databases, imported ZIP dictionaries, and Kannada Wiktionary.

## Features

- **Multi-source dictionary search**: Search across old legacy dictionaries, imported ZIP dictionaries, and Kannada Wiktionary
- **Color-coded results**: Each dictionary source has a distinct colored underline for easy identification
- **Wiktionary integration**: Kannada Wiktionary (kn.wiktionary.org) results appear under a horizontal separator with source attribution
- **Statistics dashboard**: `/stats` page shows counts and breakdowns for all dictionary sources
- **Kannada IME support**: Input method editor for Kannada script

## Data Sources

| Source | Table | Count | Description |
|--------|-------|-------|-------------|
| Old Dictionaries (IDs 1-10) | `padas` | ~190,000 | Pre-existing dictionaries before ZIP import |
| ZIP Dictionaries (IDs 11-121) | `dictionary_entries` + `dictionary_file_stats` | 593,113 | Imported from `padakanaja_dictionaries.zip` |
| Kannada Wiktionary | `wiktionary_entries` | ~130,000 | Imported from kn.wiktionary.org dump |

## Setup

### Requirements
- Ruby 2.5.9
- Rails 5.2
- MySQL
- Node.js (for asset compilation)

### Installation

```bash
# Install dependencies
bundle install
yarn install

# Setup database
rails db:migrate RAILS_ENV=production

# Import dictionary data (see Rake Tasks below)
```

## Rake Tasks

### Dictionary Import from ZIP
Import all dictionary CSV files from `padakanaja_dictionaries.zip`:

```bash
rails dictionaries:import RAILS_ENV=production
```

This imports into the `dictionary_entries` table and updates `dictionary_file_stats`.

### Import into Padas
Map ZIP dictionary data into the existing `padas`/`dictionaries` tables:

```bash
rails dictionaries:import_into_padas RAILS_ENV=production
```

### Wiktionary Import
Import Kannada Wiktionary entries from the XML dump:

```bash
rails wiktionary:import RAILS_ENV=production
```

For bulk import from the XML dump, see `docs/WIKTIONARY_IMPORT.md`.

## Database Schema

Key tables:

- **padas**: Main search table. Contains word, meaning, POS, dictionary_id
- **dictionaries**: Dictionary metadata (name, description)
- **dictionary_entries**: Raw imported data from ZIP files
- **dictionary_file_stats**: Per-file statistics for ZIP import tracking
- **wiktionary_entries**: Kannada Wiktionary entries (word, meaning, POS, page_title)
- **languages**: Language codes (Kannada, English)

## Routes

| Path | Description |
|------|-------------|
| `/` | Homepage - search all dictionaries |
| `/stats` | Statistics page showing all dictionary counts |
| `/about` | About page |

## Search Behavior

When a user searches:
1. **Exact matches** from `padas` table are shown first with colored underlines per dictionary
2. **Wiktionary results** appear below a horizontal line (`<hr>`) with the "Wiktionary" badge, purple underline, and link to source page
3. **Similar matches** appear in the right sidebar

## Stats Page

The `/stats` page shows:
- Total ZIP dictionaries (from `dictionary_file_stats`)
- Old pre-existing dictionaries (IDs 1-10)
- Wiktionary entries with count
- Grand total across all sources
- Per-dictionary breakdown tables

## License

[Your license here]

## Credits

Dictionary data from various Kannada publishers and [Kannada Wiktionary](https://kn.wiktionary.org).
