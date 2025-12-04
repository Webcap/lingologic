# Adding Spanish Translations to Lessons

## Overview
This guide explains how to add Spanish translations to English lessons so Spanish-speaking users can see the UI text in Spanish while learning English.

## Translation Structure

### Lesson-Level Translations
Add translations at the lesson level for title and description:

```sql
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{translations}',
  '{"es": {
    "title": "Título en Español",
    "description": "Descripción en Español"
  }}'::jsonb,
  true
)
WHERE id = 'lesson_id';
```

### Section-Level Translations

#### Text Sections
```sql
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{sections,INDEX,translations}',
  '{"es": {
    "title": "Título en Español",
    "content": "Contenido en Español",
    "examples": ["Ejemplo 1", "Ejemplo 2"]
  }}'::jsonb,
  true
)
WHERE id = 'lesson_id';
```

#### Exercise Sections
```sql
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{sections,INDEX,translations}',
  '{"es": {
    "instruction": "Instrucción en Español",
    "question": "Pregunta en Español",
    "explanation": "Explicación en Español",
    "hint": "Pista en Español",
    "options": [
      {"text": "Opción 1", "is_correct": true},
      {"text": "Opción 2", "is_correct": false}
    ]
  }}'::jsonb,
  true
)
WHERE id = 'lesson_id';
```

#### Matching Exercise Sections
```sql
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{sections,INDEX,translations}',
  '{"es": {
    "instruction": "Instrucción en Español",
    "explanation": "Explicación en Español"
  }}'::jsonb,
  true
)
WHERE id = 'lesson_id';
```

#### Pronunciation Exercise Sections
```sql
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{sections,INDEX,translations}',
  '{"es": {
    "instruction": "Instrucción en Español",
    "explanation": "Explicación en Español"
  }}'::jsonb,
  true
)
WHERE id = 'lesson_id';
```

#### Example Sections
```sql
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{sections,INDEX,translations}',
  '{"es": {
    "explanation": "Explicación en Español"
  }}'::jsonb,
  true
)
WHERE id = 'lesson_id';
```

## Finding Section Index

The section index is the position in the `sections` array (0-based):
- First section: `{sections,0,translations}`
- Second section: `{sections,1,translations}`
- Third section: `{sections,2,translations}`
- etc.

## Important Notes

1. **Escape Single Quotes**: In JSON strings within SQL, single quotes must be doubled: `I'm` becomes `I''m`
2. **Test Each Update**: After updating, verify the JSON structure is valid
3. **Preserve Original Content**: Translations are additive - original English content remains
4. **Use `true` Parameter**: The fourth parameter to `jsonb_set` creates the path if it doesn't exist

## Generating Translations

Due to the large volume of content, consider:

1. **Use a Script**: Create a Python/Node script to generate SQL from translations
2. **Batch Updates**: Update multiple sections in one transaction
3. **Translation Service**: Use professional translation services for accuracy
4. **Review Process**: Have native speakers review all translations

## Example: Complete Lesson Translation

See `039_add_spanish_translations_to_lessons.sql` for a complete example of translating one lesson with all its sections.

## Verification Query

After adding translations, verify with:

```sql
-- Check if translations were added
SELECT 
  id,
  title,
  content_json->'translations'->'es'->>'title' as spanish_title,
  jsonb_array_length(content_json->'sections') as section_count
FROM lessons
WHERE id = 'your_lesson_id';
```

```sql
-- Check specific section translation
SELECT 
  id,
  content_json->'sections'->0->>'id' as section_id,
  content_json->'sections'->0->'translations'->'es' as spanish_translations
FROM lessons
WHERE id = 'your_lesson_id';
```

