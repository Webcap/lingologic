# Solution: Missing English Lessons

## Problem Solved ✅
Created a combined migration file that will insert all **8 missing English lessons** at once.

## Created Files

1. **`supabase/migrations/040_insert_missing_english_lessons.sql`** (137 KB)
   - Combined migration with all 8 missing lessons
   - Ready to run in Supabase SQL Editor

2. **`supabase/migrations/README_MISSING_LESSONS.md`**
   - Guide for running individual migrations if preferred

3. **`scripts/combine_missing_lesson_migrations.py`**
   - Script used to generate the combined migration

## The 8 Missing Lessons

### A1 Level (6 lessons):
1. **Family and Relationships** (order_index: 5)
2. **The Home and Describing Places** (order_index: 6)
3. **Daily Routines and Actions** (order_index: 7)
4. **Descriptions** (order_index: 8)
5. **Food, Drink, and Ordering** (order_index: 9)
6. **Shopping and Prices** (order_index: 10)

### A2 Level (2 lessons):
7. **Narration and Time** (A2, order_index: 1)
8. **Social & Functional Language** (A2, order_index: 2)

## How to Apply

### Option 1: Run Combined Migration (Easiest)
1. Go to **Supabase Dashboard → SQL Editor**
2. Open `supabase/migrations/040_insert_missing_english_lessons.sql`
3. Copy all SQL content
4. Paste into SQL Editor
5. Click **"Run"**
6. Wait for completion (may take a minute due to size)
7. Verify: You should see "Success" message

### Option 2: Run Individual Migrations (More Control)
Run each of these files individually in Supabase SQL Editor:
- `019_create_english_a1_family_relationships_lesson.sql`
- `021_create_english_a1_home_describing_places_lesson.sql`
- `023_create_english_a1_daily_routines_actions_lesson.sql`
- `026_create_english_a1_descriptions_lesson.sql`
- `029_create_english_a1_food_drink_ordering_lesson.sql`
- `031_create_english_a1_shopping_prices_lesson.sql`
- `033_create_english_a2_narration_time_lesson.sql`
- `038_create_english_a2_social_functional_language_lesson.sql`

## Verification

After running the migration(s), verify all lessons are in your database:

```sql
SELECT COUNT(*) as total_lessons,
       COUNT(CASE WHEN level = 'A1' THEN 1 END) as a1_lessons,
       COUNT(CASE WHEN level = 'A2' THEN 1 END) as a2_lessons
FROM lessons
WHERE language = 'english';
```

**Expected Results:**
- `total_lessons`: **12**
- `a1_lessons`: **10**
- `a2_lessons`: **2**

## After Migration

1. **Restart your Flutter app**
2. Check the logs - you should see:
   ```
   SupabaseRepository: Successfully parsed 12 lessons (language: english, category: null)
   ```
3. **All 12 lessons should appear** in your Lessons screen

## Troubleshooting

- **If migration fails**: Check for duplicate word IDs - the migrations use `ON CONFLICT DO NOTHING` so this shouldn't be an issue
- **If only some lessons appear**: Run the individual migration files one by one to identify which one failed
- **If app still shows 4 lessons**: Restart the app completely to refresh the lesson list

