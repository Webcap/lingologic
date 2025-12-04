-- Query to retrieve all lessons
-- This query returns all lessons with all fields

-- Basic query: Get all lessons
SELECT 
  id,
  title,
  description,
  language,
  category,
  level,
  order_index,
  estimated_minutes,
  content_json,
  unlocks_word_ids,
  unlocks_grammar_concepts,
  created_at,
  updated_at
FROM lessons
ORDER BY language, level, order_index;

-- Query with filters: Get lessons by language
SELECT 
  id,
  title,
  description,
  language,
  category,
  level,
  order_index,
  estimated_minutes,
  content_json,
  unlocks_word_ids,
  unlocks_grammar_concepts,
  created_at,
  updated_at
FROM lessons
WHERE language = 'spanish'  -- Replace with desired language code
ORDER BY level, order_index;

-- Query with filters: Get lessons by category
SELECT 
  id,
  title,
  description,
  language,
  category,
  level,
  order_index,
  estimated_minutes,
  content_json,
  unlocks_word_ids,
  unlocks_grammar_concepts,
  created_at,
  updated_at
FROM lessons
WHERE category = 'social'  -- Replace with desired category
ORDER BY language, level, order_index;

-- Query with filters: Get lessons by level (CEFR)
SELECT 
  id,
  title,
  description,
  language,
  category,
  level,
  order_index,
  estimated_minutes,
  content_json,
  unlocks_word_ids,
  unlocks_grammar_concepts,
  created_at,
  updated_at
FROM lessons
WHERE level = 'A2'  -- Replace with desired level (A1, A2, B1, B2, C1, C2)
ORDER BY language, order_index;

-- Combined filters: Get lessons by language and category
SELECT 
  id,
  title,
  description,
  language,
  category,
  level,
  order_index,
  estimated_minutes,
  content_json,
  unlocks_word_ids,
  unlocks_grammar_concepts,
  created_at,
  updated_at
FROM lessons
WHERE language = 'spanish'
  AND category = 'social'
ORDER BY level, order_index;

-- Summary query: Get lesson counts by language and level
SELECT 
  language,
  level,
  COUNT(*) as lesson_count,
  SUM(estimated_minutes) as total_minutes
FROM lessons
GROUP BY language, level
ORDER BY language, level;

-- Summary query: Get all unique languages
SELECT DISTINCT language
FROM lessons
ORDER BY language;

-- Summary query: Get all unique categories
SELECT DISTINCT category
FROM lessons
WHERE category IS NOT NULL
ORDER BY category;

-- Summary query: Get all unique levels
SELECT DISTINCT level
FROM lessons
WHERE level IS NOT NULL
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

