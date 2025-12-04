-- Check all English lessons in the database
SELECT 
  id,
  title,
  language,
  level,
  category,
  order_index,
  created_at
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;

-- Count English lessons by level
SELECT 
  level,
  COUNT(*) as lesson_count
FROM lessons
WHERE language = 'english'
GROUP BY level
ORDER BY 
  CASE level
    WHEN 'A1' THEN 1
    WHEN 'A2' THEN 2
    WHEN 'B1' THEN 3
    WHEN 'B2' THEN 4
    WHEN 'C1' THEN 5
    WHEN 'C2' THEN 6
    ELSE 7
  END;

-- Total count of English lessons
SELECT COUNT(*) as total_english_lessons
FROM lessons
WHERE language = 'english';

-- Check if lessons have proper content_json structure
SELECT 
  id,
  title,
  jsonb_typeof(content_json) as content_type,
  jsonb_array_length(content_json->'sections') as section_count
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;

