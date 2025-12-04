-- =====================================================
-- SQL Queries to Retrieve All Lessons
-- =====================================================

-- 1. Get ALL lessons (simplest query)
SELECT * 
FROM lessons
ORDER BY language, level, order_index;

-- 2. Get all lessons with specific fields only
SELECT 
  id,
  title,
  description,
  language,
  category,
  level,
  order_index,
  estimated_minutes,
  created_at,
  updated_at
FROM lessons
ORDER BY language, level, order_index;

-- 3. Get all lessons by language
SELECT * 
FROM lessons
WHERE language = 'spanish'  -- Change to: 'english', 'spanish', etc.
ORDER BY level, order_index;

-- 4. Get all lessons by level (CEFR)
SELECT * 
FROM lessons
WHERE level = 'A2'  -- Change to: 'A1', 'A2', 'B1', 'B2', 'C1', 'C2'
ORDER BY language, order_index;

-- 5. Get all lessons by category
SELECT * 
FROM lessons
WHERE category = 'social'  -- Change to desired category
ORDER BY language, level, order_index;

-- 6. Get lessons with content (includes content_json)
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

-- 7. Get lesson summary statistics
SELECT 
  COUNT(*) as total_lessons,
  COUNT(DISTINCT language) as languages_count,
  COUNT(DISTINCT category) as categories_count,
  COUNT(DISTINCT level) as levels_count,
  SUM(estimated_minutes) as total_minutes
FROM lessons;

-- 8. Get lessons grouped by language
SELECT 
  language,
  COUNT(*) as lesson_count,
  STRING_AGG(DISTINCT level, ', ' ORDER BY level) as available_levels
FROM lessons
GROUP BY language
ORDER BY language;

-- 9. Get lessons grouped by level
SELECT 
  level,
  COUNT(*) as lesson_count,
  STRING_AGG(DISTINCT language, ', ' ORDER BY language) as available_languages
FROM lessons
WHERE level IS NOT NULL
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

