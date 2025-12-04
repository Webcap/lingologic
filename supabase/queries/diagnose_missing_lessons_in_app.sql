-- Diagnostic: Why app shows 4 lessons when database has 12
-- Run this to identify which lessons might be failing to parse in the app

-- 1. List all English lessons with content validation
SELECT 
  id,
  title,
  level,
  order_index,
  CASE 
    WHEN content_json IS NULL THEN '❌ NO CONTENT_JSON'
    WHEN jsonb_typeof(content_json) != 'object' THEN '❌ INVALID JSON TYPE'
    WHEN content_json->'sections' IS NULL THEN '❌ NO SECTIONS KEY'
    WHEN jsonb_typeof(content_json->'sections') != 'array' THEN '❌ SECTIONS NOT ARRAY'
    WHEN jsonb_array_length(content_json->'sections') = 0 THEN '⚠️ EMPTY SECTIONS ARRAY'
    ELSE '✅ VALID'
  END as content_status,
  CASE 
    WHEN content_json->'sections' IS NOT NULL 
    THEN jsonb_array_length(content_json->'sections')
    ELSE 0
  END as section_count
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;

-- 2. Check which lessons might fail parsing
SELECT 
  id,
  title,
  level,
  CASE 
    WHEN id IS NULL THEN 'MISSING ID'
    WHEN title IS NULL OR title = '' THEN 'MISSING TITLE'
    WHEN level IS NULL THEN 'MISSING LEVEL'
    WHEN language IS NULL THEN 'MISSING LANGUAGE'
    WHEN content_json IS NULL THEN 'MISSING CONTENT_JSON'
    WHEN content_json->'sections' IS NULL THEN 'MISSING SECTIONS'
    ELSE 'OK - Should parse'
  END as parse_status
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;

-- 3. Compare: Which lessons exist vs which should exist
WITH expected_lessons AS (
  SELECT unnest(ARRAY[
    'english_a1_greetings_introductions',
    'english_a1_personal_information',
    'english_a1_numbers_dates_time',
    'english_a1_likes_dislikes',
    'english_a1_family_relationships',
    'english_a1_home_describing_places',
    'english_a1_daily_routines_actions',
    'english_a1_descriptions',
    'english_a1_food_drink_ordering',
    'english_a1_shopping_prices',
    'english_a2_narration_time',
    'english_a2_social_functional_language'
  ]) AS lesson_id
)
SELECT 
  e.lesson_id,
  CASE 
    WHEN l.id IS NOT NULL THEN '✅ EXISTS IN DB'
    ELSE '❌ MISSING FROM DB'
  END as db_status,
  CASE 
    WHEN l.id IS NOT NULL AND l.content_json IS NULL THEN '❌ NO CONTENT'
    WHEN l.id IS NOT NULL AND l.content_json->'sections' IS NULL THEN '❌ NO SECTIONS'
    WHEN l.id IS NOT NULL THEN '✅ SHOULD LOAD'
    ELSE 'N/A'
  END as should_load_in_app
FROM expected_lessons e
LEFT JOIN lessons l ON l.id = e.lesson_id AND l.language = 'english'
ORDER BY e.lesson_id;

