# Lesson & Exercise Translation Plan

## Overview
Make all lesson content and exercise instructions translatable based on the app's UI language setting.

## Translatable Content Fields

### Lesson Level
- `title` - Lesson title
- `description` - Lesson description

### Section Types

#### TextSection
- `title` - Section title
- `content` - Main content text
- `examples[]` - Array of example strings

#### ExerciseSection
- `instruction` - Exercise instruction text
- `question` - Question text
- `options[].text` - Option text for each answer choice
- `explanation` - Explanation after answering
- `hint` - Hint text

#### MatchingExerciseSection
- `instruction` - Matching instruction text
- `explanation` - Explanation after matching

#### PronunciationExerciseSection
- `instruction` - Pronunciation instruction text
- `explanation` - Explanation after pronunciation

#### ExampleSection
- `explanation` - Explanation text

## Translation Storage Strategy

### Option 1: Inline Translations in JSON (Recommended)
Store translations directly in the lesson JSON with a structure like:
```json
{
  "title": "Social & Functional Language",
  "translations": {
    "es": {
      "title": "Lenguaje Social y Funcional"
    }
  },
  "content_json": {
    "sections": [{
      "instruction": "Match the words",
      "translations": {
        "es": {
          "instruction": "Empareja las palabras"
        }
      }
    }]
  }
}
```

### Option 2: Separate Translation Table
Create a `lesson_translations` table that stores translations separately:
- `lesson_id`
- `field_path` (e.g., "sections[0].instruction")
- `language`
- `translated_text`

### Option 3: Separate Content Versions
Store completely separate lesson content JSON for each language.

## Recommended Approach: Option 1 (Inline Translations)

**Pros:**
- Keeps translations with content
- Easy to maintain
- No complex joins needed
- Version control friendly

**Cons:**
- Larger JSON size
- Need to update migration files

## Implementation Steps

1. **Update Models** - Add translation support to Lesson and LessonContent models
2. **Create Translation Service** - Service to extract translated content based on app language
3. **Update Lesson Loading** - Modify lesson service to apply translations when loading
4. **Migration Strategy** - Plan for migrating existing lessons to include translations
5. **Admin Interface** - Update admin interface to support adding translations

## Translation Priority

1. **High Priority** (UI elements):
   - Instructions
   - Buttons/Labels
   - Error messages
   - Explanations

2. **Medium Priority** (Content):
   - Titles
   - Descriptions
   - Questions

3. **Low Priority** (Examples):
   - Example sentences (can stay in target language)

