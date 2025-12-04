-- Verify which 4 English lessons are currently in your database
-- Based on log output showing only 4 lessons

-- Show what's actually in the database
SELECT 
  id,
  title,
  level,
  order_index,
  category,
  created_at
FROM lessons
WHERE language = 'english'
ORDER BY order_index;

-- The log shows the first lesson as: english_a1_likes_dislikes
-- This is order_index 4, so you likely have the first 4 lessons:
-- But let's verify exactly which 4 exist:

SELECT 
  'Currently in Database' as status,
  id,
  title,
  order_index
FROM lessons
WHERE language = 'english'
ORDER BY order_index;

-- Compare with expected list - show which are missing
SELECT 
  expected.id,
  expected.title,
  expected.order_index,
  CASE 
    WHEN l.id IS NOT NULL THEN '✅ EXISTS'
    ELSE '❌ MISSING - Needs migration'
  END as status,
  CASE 
    WHEN l.id IS NULL THEN CONCAT('supabase/migrations/', 
      CASE expected.id
        WHEN 'english_a1_greetings_introductions' THEN '010_create_english_a1_greetings_introductions_lesson.sql'
        WHEN 'english_a1_personal_information' THEN '013_create_english_a1_personal_information_lesson.sql'
        WHEN 'english_a1_numbers_dates_time' THEN '015_create_english_a1_numbers_dates_time_lesson.sql'
        WHEN 'english_a1_likes_dislikes' THEN '017_create_english_a1_likes_dislikes_lesson.sql'
        WHEN 'english_a1_family_relationships' THEN '019_create_english_a1_family_relationships_lesson.sql'
        WHEN 'english_a1_home_describing_places' THEN '021_create_english_a1_home_describing_places_lesson.sql'
        WHEN 'english_a1_daily_routines_actions' THEN '023_create_english_a1_daily_routines_actions_lesson.sql'
        WHEN 'english_a1_descriptions' THEN '026_create_english_a1_descriptions_lesson.sql'
        WHEN 'english_a1_food_drink_ordering' THEN '029_create_english_a1_food_drink_ordering_lesson.sql'
        WHEN 'english_a1_shopping_prices' THEN '031_create_english_a1_shopping_prices_lesson.sql'
        WHEN 'english_a2_narration_time' THEN '033_create_english_a2_narration_time_lesson.sql'
        WHEN 'english_a2_social_functional_language' THEN '038_create_english_a2_social_functional_language_lesson.sql'
      END
    )
    ELSE NULL
  END as migration_file
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

