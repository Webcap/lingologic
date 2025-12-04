-- Find which 4 English lessons are currently in the database
-- Based on the log: "First lesson: english_a1_likes_dislikes"

SELECT 
  id,
  title,
  level,
  order_index,
  created_at
FROM lessons
WHERE language = 'english'
ORDER BY order_index;

-- Based on the log output, you're seeing 4 lessons starting with:
-- english_a1_likes_dislikes (order_index: 4)
-- This suggests the first 4 lessons by order_index might be:
-- 1. english_a1_greetings_introductions (order_index: 1)
-- 2. english_a1_personal_information (order_index: 2)  
-- 3. english_a1_numbers_dates_time (order_index: 3)
-- 4. english_a1_likes_dislikes (order_index: 4)

-- Let's verify which ones actually exist:
SELECT 
  CASE 
    WHEN id = 'english_a1_greetings_introductions' THEN '✓'
    ELSE '✗'
  END as greetings,
  CASE 
    WHEN id = 'english_a1_personal_information' THEN '✓'
    ELSE '✗'
  END as personal_info,
  CASE 
    WHEN id = 'english_a1_numbers_dates_time' THEN '✓'
    ELSE '✗'
  END as numbers_dates,
  CASE 
    WHEN id = 'english_a1_likes_dislikes' THEN '✓'
    ELSE '✗'
  END as likes_dislikes
FROM lessons
WHERE language = 'english' 
  AND id IN (
    'english_a1_greetings_introductions',
    'english_a1_personal_information',
    'english_a1_numbers_dates_time',
    'english_a1_likes_dislikes'
  )
LIMIT 1;

-- Show the actual 4 lessons that exist
SELECT 
  id,
  title,
  order_index,
  'EXISTS' as status
FROM lessons
WHERE language = 'english'
ORDER BY order_index;

