-- Verify which English lessons exist vs which should exist
-- This will help identify missing lessons

-- 1. Show what's currently in the database
SELECT 
  'IN DATABASE' as status,
  id,
  title,
  level,
  order_index
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;

-- 2. Expected English lessons list (from your JSON):
-- A1 Level:
--   - english_a1_greetings_introductions (order_index: 1)
--   - english_a1_personal_information (order_index: 2)
--   - english_a1_numbers_dates_time (order_index: 3)
--   - english_a1_likes_dislikes (order_index: 4)
--   - english_a1_family_relationships (order_index: 5)
--   - english_a1_home_describing_places (order_index: 6)
--   - english_a1_daily_routines_actions (order_index: 7)
--   - english_a1_descriptions (order_index: 8)
--   - english_a1_food_drink_ordering (order_index: 9)
--   - english_a1_shopping_prices (order_index: 10)
-- A2 Level:
--   - english_a2_narration_time (order_index: 1)
--   - english_a2_social_functional_language (order_index: 2)

-- 3. Find missing lessons
SELECT 
  expected_id,
  expected_title,
  expected_level,
  CASE 
    WHEN l.id IS NULL THEN 'MISSING - NEEDS TO BE INSERTED'
    ELSE 'EXISTS'
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
) AS expected(expected_id, expected_title, expected_level, expected_order)
LEFT JOIN lessons l ON l.id = expected.expected_id AND l.language = 'english'
ORDER BY expected_level, expected_order;

-- 4. Quick summary count
SELECT 
  COUNT(*) as lessons_in_database,
  12 as expected_lessons,
  12 - COUNT(*) as missing_lessons
FROM lessons
WHERE language = 'english';

