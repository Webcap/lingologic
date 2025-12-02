# Supabase Database Setup

This directory contains SQL migration scripts for setting up the LingoLogic database schema.

## Setup Instructions

1. **Open Supabase Dashboard**
   - Go to your project: https://kqqtpthxbugymrmqqkzt.supabase.co
   - Navigate to the SQL Editor

2. **Run the Migration**
   - Copy the contents of `migrations/001_initial_schema.sql`
   - Paste it into the SQL Editor
   - Click "Run" to execute

3. **Enable Authentication**
   - Go to Authentication → Providers
   - Enable "Email" provider
   - Enable "Anonymous" provider (for guest users)

4. **Verify Tables**
   - Go to Table Editor
   - You should see these tables:
     - `user_profiles`
     - `words`
     - `word_mastery`
     - `game_sessions`
     - `sync_queue`

5. **Seed Initial Data (Optional)**
   - Run the seed script to populate initial Spanish vocabulary
   - See `seed_data.sql` for seed data

## Tables Overview

- **user_profiles**: User progress and stats
- **words**: Vocabulary database (public, read-only)
- **word_mastery**: User-specific word learning progress
- **game_sessions**: Game session tracking
- **sync_queue**: Offline sync queue

## Security

All tables have Row Level Security (RLS) enabled:
- Users can only access their own data
- Words table is public read-only for authenticated users
- All policies use `auth.uid()` to ensure data isolation

