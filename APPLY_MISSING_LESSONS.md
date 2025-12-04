# Apply Missing English Lessons

## Current Status
- **4 lessons** currently in database
- **8 lessons** missing (need to be inserted)
- All 12 migration files exist in `supabase/migrations/`

## Solution Options

### Option 1: Run Each Migration Individually (Recommended)

1. Go to Supabase Dashboard → SQL Editor
2. For each missing lesson, open the migration file and run it:

**Missing Lessons (assuming first 4 exist):**

5. `019_create_english_a1_family_relationships_lesson.sql`
6. `021_create_english_a1_home_describing_places_lesson.sql`
7. `023_create_english_a1_daily_routines_actions_lesson.sql`
8. `026_create_english_a1_descriptions_lesson.sql`
9. `029_create_english_a1_food_drink_ordering_lesson.sql`
10. `031_create_english_a1_shopping_prices_lesson.sql`
11. `033_create_english_a2_narration_time_lesson.sql`
12. `038_create_english_a2_social_functional_language_lesson.sql`

**Steps:**
- Open each file
- Copy all SQL
- Paste into Supabase SQL Editor
- Run it
- Verify no errors
- Repeat for next lesson

### Option 2: Verify Which 4 You Have First

Before running migrations, verify which 4 lessons currently exist:

1. Run this in Supabase SQL Editor:

```sql
SELECT id, title, order_index
FROM lessons
WHERE language = 'english'
ORDER BY order_index;
```

2. Share the results with me, and I can create a single combined migration for just the missing ones.

### Option 3: Apply All Migrations in Order

Run migrations in this order to ensure dependencies are met:

1. `010_create_english_a1_greetings_introductions_lesson.sql`
2. `013_create_english_a1_personal_information_lesson.sql`
3. `015_create_english_a1_numbers_dates_time_lesson.sql`
4. `017_create_english_a1_likes_dislikes_lesson.sql`
5. `019_create_english_a1_family_relationships_lesson.sql`
6. `021_create_english_a1_home_describing_places_lesson.sql`
7. `023_create_english_a1_daily_routines_actions_lesson.sql`
8. `026_create_english_a1_descriptions_lesson.sql`
9. `029_create_english_a1_food_drink_ordering_lesson.sql`
10. `031_create_english_a1_shopping_prices_lesson.sql`
11. `033_create_english_a2_narration_time_lesson.sql`
12. `038_create_english_a2_social_functional_language_lesson.sql`

**Note:** If a lesson already exists, the migration should handle it gracefully with `ON CONFLICT DO NOTHING` clauses.

## Verification

After applying migrations, verify all 12 lessons exist:

```sql
SELECT COUNT(*) as total_lessons,
       COUNT(CASE WHEN level = 'A1' THEN 1 END) as a1_lessons,
       COUNT(CASE WHEN level = 'A2' THEN 1 END) as a2_lessons
FROM lessons
WHERE language = 'english';
```

Expected result:
- total_lessons: 12
- a1_lessons: 10
- a2_lessons: 2

## Next Steps

1. **First, verify which 4 lessons you currently have**
2. **Then, I can help you either:**
   - Create a single combined migration for the missing 8
   - Guide you through applying them one by one
   - Troubleshoot any migration errors

Share the results of the verification query, and I'll help you get all 12 lessons into your database!

