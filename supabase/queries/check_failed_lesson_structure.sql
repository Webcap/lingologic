-- Check the structure of the 8 failed lessons
-- These lessons are failing to parse in the app

-- Check one of the failed lessons in detail
SELECT 
  id,
  title,
  level,
  -- Check content_json structure
  jsonb_typeof(content_json) as content_json_type,
  CASE 
    WHEN content_json IS NULL THEN 'NULL'
    WHEN content_json->'sections' IS NULL THEN 'NO SECTIONS KEY'
    WHEN jsonb_typeof(content_json->'sections') != 'array' THEN 'SECTIONS NOT ARRAY'
    WHEN jsonb_array_length(content_json->'sections') = 0 THEN 'EMPTY SECTIONS'
    ELSE 'OK'
  END as sections_status,
  CASE 
    WHEN content_json->'sections' IS NOT NULL 
    THEN jsonb_array_length(content_json->'sections')
    ELSE 0
  END as section_count,
  -- Show first section structure if exists
  CASE 
    WHEN content_json->'sections' IS NOT NULL AND jsonb_array_length(content_json->'sections') > 0
    THEN (content_json->'sections'->0->>'type')
    ELSE NULL
  END as first_section_type
FROM lessons
WHERE language = 'english' 
  AND id IN (
    'english_a1_shopping_prices',
    'english_a1_food_drink_ordering',
    'english_a1_descriptions',
    'english_a1_daily_routines_actions',
    'english_a1_home_describing_places',
    'english_a1_family_relationships',
    'english_a2_social_functional_language',
    'english_a2_narration_time'
  )
ORDER BY level, order_index;

-- Compare with a working lesson structure
SELECT 
  'WORKING LESSON' as lesson_type,
  id,
  jsonb_typeof(content_json) as content_json_type,
  content_json->'sections' IS NOT NULL as has_sections,
  jsonb_array_length(content_json->'sections') as section_count
FROM lessons
WHERE language = 'english' 
  AND id = 'english_a1_greetings_introductions';

-- Check if content_json is stored as text instead of jsonb
SELECT 
  id,
  pg_typeof(content_json) as storage_type,
  jsonb_typeof(content_json) as json_type
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;

