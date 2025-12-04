# Debug: Why App Shows 4 Lessons When Database Has 12

## Problem
- ✅ Supabase database has **12 English lessons**
- ❌ App only loads **4 English lessons**

## Possible Causes

### 1. Parsing Errors (Most Likely)
When lessons are loaded from the database, if there's an error parsing a lesson's JSON, it gets skipped silently. Check your app logs for:

```
SupabaseRepository: Error parsing lesson: ...
SupabaseRepository: Stack trace: ...
SupabaseRepository: Lesson data: ...
```

These errors will show which lessons are failing to parse.

### 2. Content JSON Format Issues
Some lessons might have invalid `content_json` that fails to parse into `LessonContent`. The app will skip these lessons.

### 3. App Caching
The app might be caching old lesson data.

## Debugging Steps

### Step 1: Check App Logs for Parsing Errors

Look for error messages like:
- `Error parsing lesson`
- `Skipping invalid lesson item`
- `Invalid content_json format`

### Step 2: Verify All 12 Lessons in Supabase

Run this query to see which lessons exist:

```sql
SELECT 
  id,
  title,
  level,
  order_index,
  CASE 
    WHEN content_json IS NULL THEN 'NO CONTENT'
    WHEN jsonb_typeof(content_json) != 'object' THEN 'INVALID JSON TYPE'
    WHEN content_json->'sections' IS NULL THEN 'NO SECTIONS'
    ELSE 'OK'
  END as content_status
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;
```

### Step 3: Check for Invalid JSON

Some lessons might have invalid `content_json`. Check with:

```sql
SELECT 
  id,
  title,
  jsonb_typeof(content_json) as json_type,
  CASE 
    WHEN content_json->'sections' IS NULL THEN 'MISSING SECTIONS'
    WHEN jsonb_typeof(content_json->'sections') != 'array' THEN 'SECTIONS NOT ARRAY'
    ELSE 'OK'
  END as sections_status
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;
```

### Step 4: Force App Refresh

1. **Completely close** the Flutter app
2. **Clear app data** (or uninstall/reinstall if needed)
3. **Restart** the app
4. Check logs again

## Quick Fix: Add More Debugging

The repository already has error logging. Check your console/logs for:
- `SupabaseRepository: Raw response count: X` - This should be 12
- `SupabaseRepository: Successfully parsed X lessons` - This shows how many actually parsed

If "Raw response count" is 12 but "Successfully parsed" is 4, then 8 lessons are failing to parse.

## Common Issues

1. **Missing sections array**: `content_json` doesn't have a `sections` key
2. **Invalid JSON structure**: JSON doesn't match expected format
3. **Missing required fields**: Lesson is missing `id`, `title`, or `level`

## Next Steps

1. Share the app logs showing any parsing errors
2. Run the diagnostic queries above in Supabase
3. Check which specific lessons are failing to load

