# SQL Queries for Lessons

## Quick Start

### Get All Lessons
```sql
SELECT * 
FROM lessons
ORDER BY language, level, order_index;
```

### Get Lessons by Language
```sql
SELECT * 
FROM lessons
WHERE language = 'spanish'
ORDER BY level, order_index;
```

### Get Lessons by Level
```sql
SELECT * 
FROM lessons
WHERE level = 'A2'
ORDER BY language, order_index;
```

## Available Query Files

1. **retrieve_all_lessons.sql** - Common queries for retrieving lessons
2. **get_all_lessons.sql** - Comprehensive queries with filters and summaries

## Lesson Table Structure

- `id` - Lesson identifier
- `title` - Lesson title
- `description` - Lesson description
- `language` - Language code (e.g., 'spanish', 'english')
- `category` - Lesson category
- `level` - CEFR level (A1, A2, B1, B2, C1, C2)
- `order_index` - Display order
- `estimated_minutes` - Estimated completion time
- `content_json` - Lesson content (JSONB)
- `unlocks_word_ids` - Array of word IDs unlocked
- `unlocks_grammar_concepts` - Array of grammar concepts unlocked
- `created_at` - Creation timestamp
- `updated_at` - Last update timestamp

