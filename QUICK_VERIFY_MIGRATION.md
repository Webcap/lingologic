# Quick Verification After Running Migration

## Before Migration (Current State)
Your logs show:
```
SupabaseRepository: Successfully parsed 4 lessons (language: english, category: null)
First lesson: english_a1_likes_dislikes - Likes, Dislikes, and Preferences
```

## After Running Migration

### Step 1: Run the Migration
1. Go to **Supabase Dashboard → SQL Editor**
2. Open `supabase/migrations/040_insert_missing_english_lessons.sql`
3. Copy all SQL (Ctrl+A, Ctrl+C)
4. Paste into SQL Editor (Ctrl+V)
5. Click **"Run"** button
6. Wait for success message

### Step 2: Verify in Database

Run this query in Supabase SQL Editor:

```sql
SELECT id, title, level, order_index
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;
```

**Expected:** You should see **12 lessons** total:
- 10 A1 lessons (order_index 1-10)
- 2 A2 lessons (order_index 1-2)

### Step 3: Verify in App

1. **Completely restart your Flutter app** (close and reopen)
2. Check the logs - you should now see:
   ```
   SupabaseRepository: Successfully parsed 12 lessons (language: english, category: null)
   ```
3. Open the Lessons screen - you should see all 12 lessons

## Troubleshooting

- **Still seeing 4 lessons?**
  - Make sure you completely restarted the app
  - Check Supabase to verify all 12 lessons exist in database
  - Clear app cache if needed

- **Migration error?**
  - Check which lesson failed in the error message
  - You can run individual migration files instead

- **Only some lessons showing?**
  - Check the database query above
  - Verify all 12 lesson IDs exist

## Expected Lesson List (All 12)

After migration, you should have:

**A1 Level:**
1. Greetings and Introductions (order_index: 1)
2. Personal Information (order_index: 2)
3. Numbers, Dates, and Time (order_index: 3)
4. Likes, Dislikes, and Preferences (order_index: 4) ✅ *You already have this*
5. The Family and Relationships (order_index: 5) ⬅️ *Missing - will be added*
6. The Home and Describing Places (order_index: 6) ⬅️ *Missing - will be added*
7. Daily Routines and Actions (order_index: 7) ⬅️ *Missing - will be added*
8. Descriptions (order_index: 8) ⬅️ *Missing - will be added*
9. Food, Drink, and Ordering (order_index: 9) ⬅️ *Missing - will be added*
10. Shopping and Prices (order_index: 10) ⬅️ *Missing - will be added*

**A2 Level:**
11. Narration and Time (order_index: 1) ⬅️ *Missing - will be added*
12. Social & Functional Language (order_index: 2) ⬅️ *Missing - will be added*

