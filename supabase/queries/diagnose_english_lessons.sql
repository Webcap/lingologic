-- Diagnostic query to check all English lessons
-- Run this to see what English lessons exist in your database

-- 1. List ALL English lessons with details
SELECT 
  id,
  title,
  language,
  level,
  category,
  order_index,
  estimated_minutes,
  created_at
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;

-- 2. Count by level
SELECT 
  level,
  COUNT(*) as count
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

-- 3. List lesson IDs to verify they match what you expect
SELECT id, title, level
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;

-- 4. Check for any lessons without a level (these might not show)
SELECT id, title, level
FROM lessons
WHERE language = 'english' AND level IS NULL;

