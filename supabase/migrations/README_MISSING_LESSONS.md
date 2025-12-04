# Insert Missing English Lessons

## Problem
Only 4 English lessons are showing in your app, but you should have 12 lessons total.

## Solution: Run These 8 Migration Files

Run each of these migration files in order in your Supabase SQL Editor:

### Missing Lessons (Run in this order):

1. **`019_create_english_a1_family_relationships_lesson.sql`** - Order Index: 5
2. **`021_create_english_a1_home_describing_places_lesson.sql`** - Order Index: 6
3. **`023_create_english_a1_daily_routines_actions_lesson.sql`** - Order Index: 7
4. **`026_create_english_a1_descriptions_lesson.sql`** - Order Index: 8
5. **`029_create_english_a1_food_drink_ordering_lesson.sql`** - Order Index: 9
6. **`031_create_english_a1_shopping_prices_lesson.sql`** - Order Index: 10
7. **`033_create_english_a2_narration_time_lesson.sql`** - A2, Order Index: 1
8. **`038_create_english_a2_social_functional_language_lesson.sql`** - A2, Order Index: 2

## How to Apply

1. Go to Supabase Dashboard → SQL Editor
2. Open each migration file from the list above
3. Copy all SQL from the file
4. Paste into SQL Editor
5. Click "Run"
6. Verify no errors
7. Repeat for next file

## Verification

After running all migrations, verify with:

```sql
SELECT COUNT(*) as total_lessons,
       COUNT(CASE WHEN level = 'A1' THEN 1 END) as a1_lessons,
       COUNT(CASE WHEN level = 'A2' THEN 1 END) as a2_lessons
FROM lessons
WHERE language = 'english';
```

Expected: total_lessons = 12, a1_lessons = 10, a2_lessons = 2

## Alternative: Single Combined Migration

If you prefer, there's also `040_insert_missing_english_lessons.sql` which combines all 8 lessons into one file. However, it's very large. The individual files are recommended for easier debugging.

