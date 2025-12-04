-- Find which English lessons are missing from database
-- Compare this with your expected list of lessons

-- List all English lessons currently in database
SELECT 
  id,
  title,
  level,
  category,
  order_index,
  created_at
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;

-- Expected English lessons based on your JSON (for reference):
-- 1. english_a1_greetings_introductions (A1)
-- 2. english_a1_personal_information (A1)
-- 3. english_a1_numbers_dates_time (A1)
-- 4. english_a1_likes_dislikes (A1)
-- 5. english_a1_family_relationships (A1)
-- 6. english_a1_home_describing_places (A1)
-- 7. english_a1_daily_routines_actions (A1)
-- 8. english_a1_descriptions (A1)
-- 9. english_a1_food_drink_ordering (A1)
-- 10. english_a1_shopping_prices (A1)
-- 11. english_a2_narration_time (A2)
-- 12. english_a2_social_functional_language (A2)

-- Check which expected lessons are missing
WITH expected_lessons AS (
  SELECT unnest(ARRAY[
    'english_a1_greetings_introductions',
    'english_a1_personal_information',
    'english_a1_numbers_dates_time',
    'english_a1_likes_dislikes',
    'english_a1_family_relationships',
    'english_a1_home_describing_places',
    'english_a1_daily_routines_actions',
    'english_a1_descriptions',
    'english_a1_food_drink_ordering',
    'english_a1_shopping_prices',
    'english_a2_narration_time',
    'english_a2_social_functional_language'
  ]) AS lesson_id
)
SELECT 
  e.lesson_id as missing_lesson_id,
  'NOT IN DATABASE' as status
FROM expected_lessons e
LEFT JOIN lessons l ON e.lesson_id = l.id AND l.language = 'english'
WHERE l.id IS NULL
ORDER BY e.lesson_id;

-- Show lessons that ARE in database vs expected
SELECT 
  CASE 
    WHEN id IN (
      'english_a1_greetings_introductions',
      'english_a1_personal_information',
      'english_a1_numbers_dates_time',
      'english_a1_likes_dislikes',
      'english_a1_family_relationships',
      'english_a1_home_describing_places',
      'english_a1_daily_routines_actions',
      'english_a1_descriptions',
      'english_a1_food_drink_ordering',
      'english_a1_shopping_prices',
      'english_a2_narration_time',
      'english_a2_social_functional_language'
    ) THEN 'EXPECTED'
    ELSE 'UNEXPECTED'
  END as status,
  id,
  title,
  level
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;

