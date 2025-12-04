# Troubleshoot: Only 4 Lessons Showing When Database Has 12

## Issue
- ✅ Database has **12 English lessons**
- ❌ App only shows **4 lessons**

## Most Likely Causes

### 1. Parsing Errors (8 lessons failing to parse)
The repository code catches parsing errors and skips lessons silently. Check your app logs for:

**Look for these log messages:**
```
SupabaseRepository: Total lessons in database: 12
SupabaseRepository: Successfully parsed: 4 lessons
SupabaseRepository: Failed to parse: 8 lessons
SupabaseRepository: Failed lesson IDs: [...]
```

This will tell you which 8 lessons are failing.

### 2. Level Filtering
The lessons list screen filters by current level. If you're at A1, you should see all A1 lessons. But if only 4 A1 lessons are loaded, the filter isn't the issue.

### 3. Content JSON Format Issues
Some lessons might have invalid `content_json` structure that fails when parsing into `LessonContent`.

## Quick Diagnostic Queries

### Check which lessons have valid content_json:

```sql
SELECT 
  id,
  title,
  level,
  CASE 
    WHEN content_json IS NULL THEN 'NO CONTENT'
    WHEN content_json->'sections' IS NULL THEN 'NO SECTIONS KEY'
    WHEN jsonb_typeof(content_json->'sections') != 'array' THEN 'SECTIONS NOT ARRAY'
    ELSE 'OK'
  END as content_status
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;
```

### Check for lessons with missing required fields:

```sql
SELECT 
  id,
  title,
  level,
  CASE 
    WHEN id IS NULL THEN 'MISSING ID'
    WHEN title IS NULL OR title = '' THEN 'MISSING TITLE'
    WHEN level IS NULL THEN 'MISSING LEVEL'
    WHEN content_json IS NULL THEN 'MISSING CONTENT_JSON'
    ELSE 'OK'
  END as status
FROM lessons
WHERE language = 'english'
ORDER BY level, order_index;
```

## Enhanced Debugging Added

I've added more detailed logging to `supabase_repository.dart`. After restarting your app, check logs for:

1. **Total lessons from database**: Should be 12
2. **Successfully parsed**: Should be 12 (or show how many parsed)
3. **Failed lesson IDs**: Will list which lessons failed to parse

## Next Steps

1. **Restart your app** to get the new debug logs
2. **Check the logs** for parsing errors
3. **Share the failed lesson IDs** so we can fix them
4. **Run the diagnostic queries** in Supabase to check for invalid JSON

## Quick Fix Test

To test if it's a parsing issue, try loading lessons directly:

```sql
-- Test loading one of the "missing" lessons
SELECT 
  id,
  title,
  level,
  jsonb_pretty(content_json) as content
FROM lessons
WHERE language = 'english' 
  AND id = 'english_a1_family_relationships';
```

If this returns data, the lesson exists. If it fails to parse in the app, we need to fix the JSON structure.

