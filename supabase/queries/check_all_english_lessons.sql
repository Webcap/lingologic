-- Check which English lessons are actually in the database
-- Compare this with the expected list of 12 lessons

SELECT 
  id,
  title,
  level,
  order_index,
  category,
  created_at
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;

-- Count by level
SELECT 
  level,
  COUNT(*) as lesson_count,
  STRING_AGG(id, ', ' ORDER BY order_index) as lesson_ids
FROM lessons
WHERE language = 'english'
GROUP BY level
ORDER BY 
  CASE level
    WHEN 'A1' THEN 1
    WHEN 'A2' THEN 2
    ELSE 3
  END;

-- Check for any lessons with missing or invalid data
SELECT 
  id,
  title,
  CASE 
    WHEN level IS NULL THEN 'MISSING LEVEL'
    WHEN order_index IS NULL THEN 'MISSING ORDER_INDEX'
    WHEN title IS NULL OR title = '' THEN 'MISSING TITLE'
    WHEN content_json IS NULL THEN 'MISSING CONTENT_JSON'
    ELSE 'OK'
  END as status
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;

-- Expected lessons checklist
SELECT 
  'Expected Lesson' as type,
  expected.id,
  expected.title,
  expected.level,
  expected.order_index,
  CASE 
    WHEN l.id IS NOT NULL THEN '✓ EXISTS'
    ELSE '✗ MISSING'
  END as status
FROM (
  VALUES 
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
) AS expected(id, title, level, order_index)
LEFT JOIN lessons l ON l.id = expected.id AND l.language = 'english'
ORDER BY expected.level, expected.order_index;

