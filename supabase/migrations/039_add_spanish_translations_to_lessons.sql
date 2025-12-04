-- ====================================================
-- Migration: Add Spanish Translations to English Lessons
-- ====================================================
-- This migration adds Spanish translations for all English lessons
-- to support Spanish-speaking users learning English.
--
-- Format: Translations are stored inline in the JSON structure
-- Language code: 'es' for Spanish
-- ====================================================

-- ====================================================
-- ENGLISH A1: Greetings and Introductions
-- ====================================================

-- Step 1: Add lesson-level translations (title and description)
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{translations}',
  '{"es": {
    "title": "Saludos y Presentaciones",
    "description": "Aprende los conceptos básicos de los saludos en inglés y cómo presentarte. ¡Perfecto para principiantes absolutos!"
  }}'::jsonb,
  true
)
WHERE id = 'english_a1_greetings_introductions';

-- Step 2: Add translations to each section
-- Section: greetings_intro
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{sections,0,translations}',
  '{"es": {
    "title": "Saludos Básicos",
    "content": "¡Comencemos con los saludos en inglés más esenciales! Los saludos son las primeras palabras que usarás al conocer a alguien. En inglés, hay diferentes saludos dependiendo de la hora del día y qué tan formal quieras ser.",
    "examples": [
      "Usa \"good morning\" antes de las 12 PM (mediodía)",
      "Usa \"good afternoon\" desde las 12 PM hasta alrededor de las 5 PM",
      "Usa \"good evening\" desde alrededor de las 5 PM hasta las 9 PM",
      "\"Hello\" e \"Hi\" se pueden usar en cualquier momento del día!"
    ]
  }}'::jsonb,
  true
)
WHERE id = 'english_a1_greetings_introductions';

-- Section: greeting_example_1
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{sections,1,translations}',
  '{"es": {
    "explanation": "Este es un saludo amable y cortés que podrías usar por la mañana. \"Good morning\" es más formal que \"hello\" o \"hi\"."
  }}'::jsonb,
  true
)
WHERE id = 'english_a1_greetings_introductions';

-- Section: greeting_example_2
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{sections,2,translations}',
  '{"es": {
    "explanation": "Una respuesta casual común cuando alguien te pregunta cómo estás. \"Hi\" es informal y amigable. \"I''m\" es la forma corta de \"I am\"."
  }}'::jsonb,
  true
)
WHERE id = 'english_a1_greetings_introductions';

-- Section: greeting_example_3
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{sections,3,translations}',
  '{"es": {
    "explanation": "Un saludo amigable usando \"how are you doing?\" que es similar a \"how are you?\" pero un poco más casual."
  }}'::jsonb,
  true
)
WHERE id = 'english_a1_greetings_introductions';

-- Section: greeting_exercise_1
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{sections,4,translations}',
  '{"es": {
    "question": "¿Qué saludo deberías usar a las 3:00 PM?",
    "explanation": "Después del mediodía (12 PM) y antes del atardecer, usas \"good afternoon\".",
    "options": [
      {"text": "Good afternoon", "is_correct": true},
      {"text": "Good morning", "is_correct": false},
      {"text": "Good evening", "is_correct": false},
      {"text": "Good night", "is_correct": false}
    ]
  }}'::jsonb,
  true
)
WHERE id = 'english_a1_greetings_introductions';

-- Section: greeting_exercise_2
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{sections,5,translations}',
  '{"es": {
    "question": "¿Qué saludo se puede usar en cualquier momento del día?",
    "explanation": "\"Hello\" e \"Hi\" son saludos versátiles que funcionan en cualquier momento del día.",
    "options": [
      {"text": "Hello", "is_correct": true},
      {"text": "Good morning", "is_correct": false},
      {"text": "Good night", "is_correct": false},
      {"text": "Good afternoon", "is_correct": false}
    ]
  }}'::jsonb,
  true
)
WHERE id = 'english_a1_greetings_introductions';

-- Section: introductions_intro
UPDATE lessons
SET content_json = jsonb_set(
  content_json,
  '{sections,6,translations}',
  '{"es": {
    "title": "Presentándote",
    "content": "¡Ahora aprendamos cómo presentarte! En inglés, hay algunas formas diferentes de decirle a alguien tu nombre. Las formas más comunes son \"My name is...\" o \"I am...\" (que se puede abreviar a \"I''m...\").",
    "examples": [
      "\"My name is Sarah\" significa \"Mi nombre es Sarah\"",
      "\"I''m John\" significa \"Soy John\" (I''m es la forma corta de I am)",
      "Después de presentarte, di \"Nice to meet you\" o \"Pleased to meet you\""
    ]
  }}'::jsonb,
  true
)
WHERE id = 'english_a1_greetings_introductions';

-- Continue with remaining sections following the same pattern...
-- (This would continue for all sections in all lessons)

-- ====================================================
-- PATTERN FOR OTHER LESSONS:
-- ====================================================
-- Follow the same structure:
-- 1. Add lesson-level translations (title, description)
-- 2. Add section-level translations for each section
-- 3. Use jsonb_set with the correct path for each section
--
-- Section paths follow the pattern: '{sections,INDEX,translations}'
-- where INDEX is the 0-based index of the section in the array
-- ====================================================

-- ====================================================
-- NOTE: This is a template showing the structure.
-- For production, you would need to:
-- 1. Translate all lesson titles and descriptions
-- 2. Translate all section titles, content, explanations
-- 3. Translate all exercise questions and options
-- 4. Translate all matching exercise instructions
-- 5. Translate all pronunciation exercise instructions
-- ====================================================
-- This is a large migration that requires:
-- - Manual translation review
-- - Testing each lesson after updates
-- - Verification of all JSON paths
-- ====================================================
