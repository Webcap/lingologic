# Lesson Translation Format Guide

## Overview
This guide explains how to add translations to lesson content. Translations are stored inline within the lesson JSON structure.

## Translation Structure

### Lesson-Level Translations
Add a `translations` object at the lesson level:

```json
{
  "id": "spanish_a2_social",
  "title": "Social & Functional Language",
  "description": "Master essential social phrases...",
  "translations": {
    "es": {
      "title": "Lenguaje Social y Funcional",
      "description": "Domina frases sociales esenciales..."
    }
  },
  "content_json": { ... }
}
```

### Section-Level Translations
Add a `translations` object within each section that needs translation:

```json
{
  "type": "text",
  "id": "social_intro",
  "title": "Social & Functional Language",
  "content": "Welcome! This lesson teaches...",
  "translations": {
    "es": {
      "title": "Lenguaje Social y Funcional",
      "content": "¡Bienvenido! Esta lección enseña..."
    }
  }
}
```

## Section-Specific Translation Examples

### TextSection
```json
{
  "type": "text",
  "id": "intro",
  "title": "Introduction",
  "content": "Welcome to this lesson",
  "examples": ["Example 1", "Example 2"],
  "translations": {
    "es": {
      "title": "Introducción",
      "content": "Bienvenido a esta lección",
      "examples": ["Ejemplo 1", "Ejemplo 2"]
    }
  }
}
```

### ExerciseSection
```json
{
  "type": "exercise",
  "id": "exercise1",
  "instruction": "Choose the correct answer",
  "question": "What does 'hola' mean?",
  "options": [
    {"text": "Hello", "is_correct": true},
    {"text": "Goodbye", "is_correct": false}
  ],
  "explanation": "Correct! 'Hola' means hello",
  "hint": "Think about greetings",
  "translations": {
    "es": {
      "instruction": "Elige la respuesta correcta",
      "question": "¿Qué significa 'hola'?",
      "options": [
        {"text": "Hola", "is_correct": true},
        {"text": "Adiós", "is_correct": false}
      ],
      "explanation": "¡Correcto! 'Hola' significa hola",
      "hint": "Piensa en saludos"
    }
  }
}
```

### MatchingExerciseSection
```json
{
  "type": "matching",
  "id": "matching1",
  "instruction": "Match the words with their translations",
  "pairs": [
    {"word": "hola", "translation": "hello"}
  ],
  "explanation": "Great job matching!",
  "translations": {
    "es": {
      "instruction": "Empareja las palabras con sus traducciones",
      "explanation": "¡Buen trabajo emparejando!"
    }
  }
}
```

### PronunciationExerciseSection
```json
{
  "type": "pronunciation",
  "id": "pronunciation1",
  "instruction": "Pronounce the following words",
  "words": [...],
  "explanation": "Well done on your pronunciation!",
  "translations": {
    "es": {
      "instruction": "Pronuncia las siguientes palabras",
      "explanation": "¡Bien hecho con tu pronunciación!"
    }
  }
}
```

### ExampleSection
```json
{
  "type": "example",
  "id": "example1",
  "spanish_example": "Hola, ¿cómo estás?",
  "english_translation": "Hello, how are you?",
  "explanation": "Notice the question structure",
  "translations": {
    "es": {
      "explanation": "Observa la estructura de la pregunta"
    }
  }
}
```

## Important Notes

1. **Fallback Behavior**: If a translation is missing, the original English text is used
2. **Language Codes**: Use ISO 639-1 codes (e.g., "en", "es")
3. **Partial Translations**: You can translate only some fields - missing ones will use English
4. **Options Array**: For exercises, translate the entire options array with all fields
5. **Examples Array**: Translate each string in the examples array

## Migration Example

To add Spanish translations to an existing lesson:

```sql
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{translations}',
  '{"es": {"title": "Tu título en español", "description": "Tu descripción en español"}}'::jsonb
)
WHERE id = 'your_lesson_id';
```

For section translations, you'll need to update the sections array within content_json.

