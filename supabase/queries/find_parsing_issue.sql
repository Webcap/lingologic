-- Find why the 8 new lessons are failing to parse
-- Compare structure with working lessons

-- Check if failed lessons have sections
SELECT 
  id,
  title,
  CASE 
    WHEN content_json IS NULL THEN '❌ NO CONTENT_JSON'
    WHEN content_json->'sections' IS NULL THEN '❌ NO SECTIONS KEY'
    WHEN jsonb_typeof(content_json->'sections') != 'array' THEN '❌ SECTIONS NOT ARRAY'
    WHEN jsonb_array_length(content_json->'sections') = 0 THEN '⚠️ EMPTY SECTIONS'
    ELSE '✅ HAS SECTIONS'
  END as status,
  jsonb_array_length(content_json->'sections') as section_count
FROM lessons
WHERE language = 'english'
  AND id IN (
    'english_a1_family_relationships',
    'english_a1_home_describing_places',
    'english_a1_daily_routines_actions',
    'english_a1_descriptions',
    'english_a1_food_drink_ordering',
    'english_a1_shopping_prices',
    'english_a2_narration_time',
    'english_a2_social_functional_language'
  )
ORDER BY id;

-- Compare with working lesson
SELECT 
  'WORKING' as type,
  id,
  jsonb_typeof(content_json) as json_type,
  content_json->'sections' IS NOT NULL as has_sections,
  jsonb_array_length(content_json->'sections') as section_count
FROM lessons
WHERE id = 'english_a1_greetings_introductions'

UNION ALL

-- Check one failed lesson in detail
SELECT 
  'FAILED' as type,
  id,
  jsonb_typeof(content_json) as json_type,
  content_json->'sections' IS NOT NULL as has_sections,
  CASE 
    WHEN content_json->'sections' IS NOT NULL 
    THEN jsonb_array_length(content_json->'sections')
    ELSE 0
  END as section_count
FROM lessons
WHERE id = 'english_a1_family_relationships';

-- Show raw content_json structure for first failed lesson
SELECT 
  id,
  content_json::text as raw_json_preview
FROM lessons
WHERE id = 'english_a1_family_relationships';

