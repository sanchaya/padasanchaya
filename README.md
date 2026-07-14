# Pada Sanchaya (ಪದ ಸಂಚಯ) - Kannada Dictionary Portal

A comprehensive Kannada dictionary portal aggregating multiple dictionary sources, community contributions, and Wiktionary data. Built with Ruby on Rails.

**Live**: https://pada.sanchaya.net

## Features

- **Multi-source search**: Search across 100+ Kannada dictionaries, Kannada Wiktionary, and community entries simultaneously
- **Community dictionary**: Users can contribute words, meanings, dialect info, etymology, and ecological domain
- **Admin dashboard**: Manage dictionaries, entries, and global settings
- **Per-dictionary metadata**: Core name, type, category, publisher, year, multilingual flag
- **Selective dictionary name display**: Global + per-dictionary toggle for showing dictionary names in search results
- **Voice input**: Speech-to-text for Kannada (Chrome, HTTPS only)
- **Color-coded results**: Each dictionary source has a distinct colored underline
- **Kannada IME**: Built-in input method editor for Kannada script
- **SEO optimized**: Schema.org structured data, sitemap, Open Graph, Twitter Cards, breadcrumbs
- **Responsive design**: Mobile-friendly Bootstrap layout

## Data Sources

| Source | Entries | Description |
|--------|---------|-------------|
| Legacy Dictionaries | ~190,000 | Pre-existing dictionaries in `padas` table |
| ZIP-imported Dictionaries | 103 dictionaries | Imported from dictionary ZIP archive |
| Kannada Wiktionary | ~130,000 | From kn.wiktionary.org XML dump |
| Indic-Dict Stardict | 16 dictionaries | From indic-dict/stardict-kannada (Babylon/TSV/CSV) |
| Vachana Sanchaya Glossary | ~6,200 | Vachana literature glossary |
| Community (Jana Sanchaya) | User-contributed | Crowdsourced entries with voting |

## Tech Stack

- **Ruby 2.5.9** / **Rails 5.2.8**
- **MySQL** (InnoDB, utf8mb4)
- **Passenger** application server
- **Bootstrap** frontend framework
- **jQuery IME** for Kannada input

## Setup

### Requirements
- Ruby 2.5.9
- Rails 5.2
- MySQL
- Node.js (for asset compilation)

### Installation

```bash
bundle install
yarn install
rails db:migrate RAILS_ENV=production
```

## Routes

| Path | Description |
|------|-------------|
| `/` | Homepage — search all dictionaries |
| `/stats` | Statistics with per-dictionary breakdown |
| `/about` | About the project |
| `/help` | Usage guide |
| `/contribute` | Add words to community dictionary |
| `/community` | Browse community entries |
| `/sitemap.xml` | XML sitemap for search engines |
| `/robots.txt` | Robots exclusion rules |

### Admin Routes (requires login)

| Path | Description |
|------|-------------|
| `/admin/login` | Admin login |
| `/admin/dashboard` | Dashboard with community entry stats |
| `/admin/settings` | Global settings (e.g., show dictionary names in search) |
| `/admin/dictionaries` | Manage dictionary metadata |
| `/admin/community_entries` | Moderate community entries |

## Database

### Key Tables

- **padas**: Main search table (word, meaning, POS, dictionary_id)
- **dictionaries**: Dictionary metadata with fields: core_name, dictionary_type, multilingual, category, publisher, published_year, total_entries, show_name_in_search
- **wiktionary_entries**: Kannada Wiktionary entries
- **jana_sanchaya_entries**: Community-contributed entries with voting
- **admin_users**: Admin authentication
- **dialects**: Kannada dialect reference data
- **settings**: Key-value global settings
- **dictionary_entries**: Raw imported ZIP data (legacy)
- **dictionary_file_stats**: ZIP import tracking

### Recent Migrations

- Add dictionary metadata fields (core_name, dictionary_type, multilingual, category, publisher, published_year, total_entries)
- Create Jana Sanchaya entries with etymology/dialect/ecological domain fields
- Create admin users and authentication
- Create dialects reference table
- Create settings (key-value store)
- Add `show_name_in_search` per-dictionary toggle

## Admin Features

### Dictionary Management
- Edit name, core_name, description, type, category, publisher, year
- Toggle `show_name_in_search` per dictionary
- View pada entries per dictionary with search

### Global Settings
- `show_dictionary_names` — Master toggle for showing dictionary names in search results

### Community Entry Moderation
- View, edit, approve/reject community-submitted entries

## Search Behavior

1. **Exact word matches** from `padas` table shown with colored underlines
2. **Vachana Sanchaya** results in dedicated section
3. **Alar** dictionary results in dedicated section
4. **Wiktionary entries** with source attribution
5. **Community entries** (Jana Sanchaya) with voting
6. **Similar/partial matches** in right sidebar
7. **Meaning-only matches** if no word matches found

Dictionary names in results can be controlled via:
- Global toggle at `/admin/settings`
- Per-dictionary toggle in dictionary edit form

## Rake Tasks

### Dictionary Import from ZIP

```bash
rails dictionaries:import RAILS_ENV=production
rails dictionaries:import_into_padas RAILS_ENV=production
```

### Wiktionary Import

```bash
rails wiktionary:import RAILS_ENV=production
```

See `docs/WIKTIONARY_IMPORT.md` for bulk XML dump import.

### Indic-Dict Stardict-Kannada Import

```bash
rails indic_dict:import RAILS_ENV=production
```

Imports 16 dictionaries (Kittel, Alar, Mysore University, etc.) from [indic-dict/stardict-kannada](https://github.com/indic-dict/stardict-kannada). See `docs/DICTIONARY_IMPORT.md` for details.

## SEO

- Unique `<title>` and `<meta name="description">` per page
- Open Graph / Twitter Cards for social sharing
- JSON-LD structured data (WebSite with SearchAction, BreadcrumbList)
- XML sitemap at `/sitemap.xml`
- `robots.txt` at `/robots.txt`
- Canonical URLs
- Semantic HTML with proper `<h1>` hierarchy

## Contributing

The Kannada community is invited to contribute words, meanings, dialect information, and etymology through the community dictionary at `/contribute`.

## License

Dictionary data belongs to respective publishers. Code license TBD.

## Credits

- **Sanchaya** (https://sanchaya.org)
- **Sanchi Foundation** (https://sanchifoundation.org)
- **Kannada Wiktionary** (https://kn.wiktionary.org)
- **Vachana Sanchaya** (https://vachana.sanchaya.net)
- Community contributors
