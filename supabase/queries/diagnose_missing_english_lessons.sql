-- =====================================================
-- DIAGNOSTIC: Check which English lessons exist
-- =====================================================
-- Run this query in Supabase SQL Editor to see what's in your database

-- 1. Show ALL English lessons currently in database
SELECT 
  id,
  title,
  level,
  order_index,
  category,
  CASE 
    WHEN content_json IS NULL THEN 'NO CONTENT'
    WHEN jsonb_array_length(content_json->'sections') = 0 THEN 'EMPTY CONTENT'
    ELSE 'HAS CONTENT'
  END as content_status,
  created_at
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;

-- 2. Count lessons by level
SELECT 
  level,
  COUNT(*) as count_in_database
FROM lessons
WHERE language = 'english'
GROUP BY level
ORDER BY 
  CASE level
    WHEN 'A1' THEN 1
    WHEN 'A2' THEN 2
    ELSE 3
  END;

-- 3. Check which expected lessons are MISSING
WITH expected_lessons AS (
  SELECT * FROM (VALUES 
    ('english_a1_greetings_introductions', 'Greetings and Introductions', 'A1', 1),
    ('english_a1_personal_information', 'Personal Information', 'A1', 2),
    ('english_a1_numbers_dates_time', 'Numbers, Dates, and Time', 'A1', 3),
    ('english_a1_likes_dislikes', 'Likes, Dislikes, and Preferences', 'A1', 4),
    ('english_a1_family_relationships', 'The Family and Relationships', 'A1', 5),
    ('english_a1_home_describing_places', 'The Home and Describing Places', 'A1', 6),
    ('english_a1_daily_routines_actions', 'Daily Routines and Actions', 'A1', 7),
    ('english_a1_descriptions', 'Descriptions', 'A1', 8),
    ('english_a1_food_drink_ordering', 'Food, Drink, and Ordering', 'A1', 9),
    ('english_a1_shopping_prices', 'Shopping and Prices', 'A1', 10),
    ('english_a2_narration_time', 'Narration and Time (The Key Jump from A1)', 'A2', 1),
    ('english_a2_social_functional_language', 'Social & Functional Language', 'A2', 2)
  ) AS t(lesson_id, lesson_title, lesson_level, lesson_order)
)
SELECT 
  e.lesson_id,
  e.lesson_title,
  e.lesson_level,
  e.lesson_order,
  CASE 
    WHEN l.id IS NULL THEN '❌ MISSING - Migration not applied?'
    ELSE '✅ EXISTS'
  END as status
FROM expected_lessons e
LEFT JOIN lessons l ON l.id = e.lesson_id AND l.language = 'english'
ORDER BY e.lesson_level, e.lesson_order;

-- 4. Summary
SELECT 
  'Summary' as info,
  (SELECT COUNT(*) FROM lessons WHERE language = 'english') as lessons_in_database,
  12 as expected_lessons,
  12 - (SELECT COUNT(*) FROM lessons WHERE language = 'english') as missing_lessons,
  (SELECT COUNT(*) FROM lessons WHERE language = 'english' AND level = 'A1') as a1_lessons,
  (SELECT COUNT(*) FROM lessons WHERE language = 'english' AND level = 'A2') as a2_lessons;

