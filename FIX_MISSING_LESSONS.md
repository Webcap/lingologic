# Fix Missing English Lessons

## Problem
Your app logs show only **4 English lessons** are being loaded, but you should have **12 lessons**:

```
SupabaseRepository: Successfully parsed 4 lessons (language: english, category: null)
First lesson: english_a1_likes_dislikes - Likes, Dislikes, and Preferences (level: A1)
```

## Solution

### Step 1: Verify What's in Database

Run this query in Supabase SQL Editor:

```sql
SELECT id, title, level, order_index
FROM lessons
WHERE language = 'english'
ORDER BY order_index;
```

This will show you which 4 lessons currently exist.

### Step 2: Check Which Migrations Are Missing

Run the diagnostic query: `supabase/queries/verify_current_lessons.sql`

This will show:
- ✅ Which lessons exist
- ❌ Which lessons are missing
- 📁 Which migration file to run for each missing lesson

### Step 3: Apply Missing Migrations

You have two options:

#### Option A: Apply Migrations via Supabase Dashboard

1. Go to Supabase Dashboard → SQL Editor
2. For each missing lesson, open the corresponding migration file from `supabase/migrations/`
3. Copy the SQL and run it in the SQL Editor
4. Repeat for all 8 missing lessons

#### Option B: Create a Single Combined Migration

I can create a single SQL file that will insert all 8 missing lessons at once. This is faster but requires running one larger migration.

### Step 4: Verify All Lessons Appear

After applying migrations:
1. Restart your app
2. Check the logs - you should see: `Successfully parsed 12 lessons`
3. All 12 lessons should appear in the Lessons screen

## Expected Lessons (12 total)

### A1 Level (10 lessons)
1. `english_a1_greetings_introductions` → Migration: `010_create_english_a1_greetings_introductions_lesson.sql`
2. `english_a1_personal_information` → Migration: `013_create_english_a1_personal_information_lesson.sql`
3. `english_a1_numbers_dates_time` → Migration: `015_create_english_a1_numbers_dates_time_lesson.sql`
4. `english_a1_likes_dislikes` → Migration: `017_create_english_a1_likes_dislikes_lesson.sql`
5. `english_a1_family_relationships` → Migration: `019_create_english_a1_family_relationships_lesson.sql`
6. `english_a1_home_describing_places` → Migration: `021_create_english_a1_home_describing_places_lesson.sql`
7. `english_a1_daily_routines_actions` → Migration: `023_create_english_a1_daily_routines_actions_lesson.sql`
8. `english_a1_descriptions` → Migration: `026_create_english_a1_descriptions_lesson.sql`
9. `english_a1_food_drink_ordering` → Migration: `029_create_english_a1_food_drink_ordering_lesson.sql`
10. `english_a1_shopping_prices` → Migration: `031_create_english_a1_shopping_prices_lesson.sql`

### A2 Level (2 lessons)
11. `english_a2_narration_time` → Migration: `033_create_english_a2_narration_time_lesson.sql`
12. `english_a2_social_functional_language` → Migration: `038_create_english_a2_social_functional_language_lesson.sql`

## Quick Fix

If you want, I can create a single SQL migration file that inserts all 8 missing lessons. Just let me know which 4 you currently have, and I'll create the combined migration for the remaining 8.

