# English Lessons Status

## Expected Lessons (12 total)

### A1 Level (10 lessons)
1. ✅ `english_a1_greetings_introductions` - Migration: `010_create_english_a1_greetings_introductions_lesson.sql`
2. ✅ `english_a1_personal_information` - Migration: `013_create_english_a1_personal_information_lesson.sql`
3. ✅ `english_a1_numbers_dates_time` - Migration: `015_create_english_a1_numbers_dates_time_lesson.sql`
4. ✅ `english_a1_likes_dislikes` - Migration: `017_create_english_a1_likes_dislikes_lesson.sql`
5. ✅ `english_a1_family_relationships` - Migration: `019_create_english_a1_family_relationships_lesson.sql`
6. ✅ `english_a1_home_describing_places` - Migration: `021_create_english_a1_home_describing_places_lesson.sql`
7. ✅ `english_a1_daily_routines_actions` - Migration: `023_create_english_a1_daily_routines_actions_lesson.sql`
8. ✅ `english_a1_descriptions` - Migration: `026_create_english_a1_descriptions_lesson.sql`
9. ✅ `english_a1_food_drink_ordering` - Migration: `029_create_english_a1_food_drink_ordering_lesson.sql`
10. ✅ `english_a1_shopping_prices` - Migration: `031_create_english_a1_shopping_prices_lesson.sql`

### A2 Level (2 lessons)
11. ✅ `english_a2_narration_time` - Migration: `033_create_english_a2_narration_time_lesson.sql`
12. ✅ `english_a2_social_functional_language` - Migration: `038_create_english_a2_social_functional_language_lesson.sql`

## Issue

Only **4 lessons** are showing in the app, but all **12 migration files exist**. This means some migrations may not have been applied to your database.

## Solution

### Step 1: Check What's in Your Database

Run this query in your Supabase SQL Editor:

```sql
SELECT id, title, level, order_index
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;
```

### Step 2: Identify Missing Lessons

Run the diagnostic query: `supabase/queries/diagnose_missing_english_lessons.sql`

This will show you exactly which lessons are missing.

### Step 3: Apply Missing Migrations

If lessons are missing, you need to apply their migrations. Options:

#### Option A: Apply All Migrations in Supabase Dashboard
1. Go to Supabase Dashboard → SQL Editor
2. Run each missing migration file's SQL manually

#### Option B: Check Migration Status
In Supabase, check if migrations have been applied:
- Go to Database → Migrations
- See which migrations show as "Applied"

#### Option C: Re-run Migrations
If migrations failed, you may need to:
1. Check for errors in migration files
2. Fix any conflicts (e.g., duplicate word IDs)
3. Re-run the migrations

## Common Issues

1. **Duplicate word IDs**: Some lessons might share vocabulary words. Migrations should use `ON CONFLICT DO NOTHING` for words.
2. **Missing vocabulary**: Some lessons depend on words created in earlier migrations.
3. **Migration order**: Migrations are numbered sequentially - ensure they run in order.

## Next Steps

1. Run the diagnostic query to see what's missing
2. Check Supabase migration logs for errors
3. Apply any missing migrations
4. Verify all 12 lessons appear in the app

