# Kannada Wiktionary Import Guide

This document describes how the Kannada Wiktionary (kn.wiktionary.org) data is imported into the application.

## Overview

The import fetches the full Wiktionary XML dump, parses Kannada word definitions, and stores them in the `wiktionary_entries` table for search display.

## Source Data

- **Dump URL**: https://dumps.wikimedia.org/knwiktionary/latest/knwiktionary-latest-pages-articles.xml.bz2
- **Format**: MediaWiki XML export
- **Namespace**: `0` (main articles only)
- **Extracted fields**: word, meaning, POS, page_title, language

## Import Process

### 1. Download the dump

```bash
wget https://dumps.wikimedia.org/knwiktionary/latest/knwiktionary-latest-pages-articles.xml.bz2
bunzip2 knwiktionary-latest-pages-articles.xml.bz2
```

### 2. Parse and import

The import is handled by `lib/tasks/wiktionary_import.rake` (API-based) or by a custom script for XML dump processing.

#### Method A: Bulk import from XML dump (recommended)

```bash
# From the XML dump, extract Kannada entries and import via Ruby script
ruby /tmp/fix_import.rb
```

This script:
1. Clears existing `wiktionary_entries`
2. Parses the XML using `iterparse` (streaming, low memory)
3. Extracts the `==ಕನ್ನಡ==` section from each article
4. Parses `#` definition lines as meanings
5. Removes wiki markup (`[[...]]`, `{{...}}`, HTML tags)
6. Inserts in batches of 500 using ActiveRecord connection quoting

#### Method B: Import via API
For smaller or incremental imports:

```bash
rails wiktionary:import RAILS_ENV=production
```

This uses the MediaWiki API with `generator=allpages` and fetches 50 pages per batch.

## Data Model

**Table:** `wiktionary_entries`

| Column      | Type    | Description                              |
|-------------|---------|------------------------------------------|
| id          | bigint  | Primary key                              |
| word        | varchar | The headword / page title                |
| meaning     | text    | Kannada definitions (joined by `; `)     |
| pos         | varchar | Part of speech (e.g., ನಾಮಪದ, ಕ್ರಿಯಾಪದ)  |
| page_title  | varchar | Original Wiktionary page title           |
| language    | varchar | Language code (`kn` for Kannada)       |
| created_at  | datetime| Timestamp                                |
| updated_at  | datetime| Timestamp                                |

## Meaning Extraction

From each Wiktionary article, the parser looks for:

```
==ಕನ್ನಡ==
===ನಾಮಪದ===
# first meaning
# second meaning
```

- Scans for the `==ಕನ್ನಡ==` section header
- Extracts lines starting with `#` (definitions)
- Strips wiki markup, templates, and HTML tags
- Joins multiple meanings with `; `
- Extracts POS from `===POS_NAME===` subheadings

## Search Integration

In `PadasController#index`, after querying the `padas` table:

```ruby
@wiktionary_meanings = WiktionaryEntry.search(params[:search])
```

The view (`app/views/padas/_pada_meaning.html.erb`) displays Wiktionary results:
- Below a horizontal line (`<hr>`)
- With a "Wiktionary" label/badge
- Purple underline (`#9b59b6`)
- Link to source page: `kn.wiktionary.org/wiki/<page_title>`

## Stats

The stats page (`/stats`) shows:
- Wiktionary entry count
- Link to kn.wiktionary.org
- Included in overall total

## Troubleshooting

### Issue: `Incorrect string value` for column 'meaning'
**Cause**: 4-byte UTF-8 characters (emojis) in wiki text
**Solution**: These entries are skipped during import. To fix, alter the column to `utf8mb4`:
```sql
ALTER TABLE wiktionary_entries MODIFY meaning LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Issue: Import timeout or memory error
**Solution**: Reduce the batch size in the import script (default 500).

### Issue: Very few entries imported
**Cause**: The Kannada section (`==ಕನ್ನಡ==`) may not exist in many pages
**Note**: This is normal. Not all Wiktionary pages have a Kannada section.
