<!-- 7cc6bb25-558b-4b87-a25f-1d2020c049ef f718588f-2182-4fec-95da-4c4d1bdddcd6 -->
# LingoLogic MVP Implementation Plan

## Architecture Overview

The MVP will be built using Flutter with Supabase for backend storage. The architecture will follow a layered approach:

- **Data Layer**: Supabase client + local SQLite (sqflite) for offline support
- **Business Logic Layer**: SRS algorithm, DDA system, game logic
- **Presentation Layer**: Flutter widgets with state management (Riverpod)
- **Sync Layer**: Background service to sync local data with Supabase

## Phase 1: Project Setup & Infrastructure

### 1.1 Dependencies & Configuration

- Add required packages to `pubspec.yaml`:
  - `supabase_flutter` - Backend integration
  - `sqflite` - Local database for offline mode
  - `flutter_riverpod` - State management
  - `path_provider` - File system access
  - `shared_preferences` - Local settings
  - `audioplayers` - Audio playback
  - `flutter_svg` - Image assets
  - `go_router` - Navigation
- Configure Supabase client initialization in `lib/main.dart`
- Set up environment configuration for Supabase URL and keys

### 1.2 Database Schema Design

Create Supabase tables:

- `user_profiles` - Anonymous user tracking (id, created_at, streak_days, total_time_minutes)
- `words` - Vocabulary database (id, language, word_text, translation, image_url, audio_url, category)
- `word_mastery` - SRS tracking (user_id, word_id, mastery_level, next_review_date, ease_factor, interval_days, last_reviewed)
- `game_sessions` - Session tracking (user_id, game_type, start_time, end_time, score, difficulty_level)
- `sync_queue` - Offline sync tracking (id, user_id, table_name, operation, data, synced_at)

### 1.3 Local Database Setup

- Create SQLite schema matching Supabase tables
- Implement database helper class (`lib/data/local/database_helper.dart`)
- Set up migration system for schema updates

## Phase 2: Core Learning System (Cognitive Engine)

### 2.1 Spaced Repetition System (SRS)

- Implement modified SuperMemo 2 algorithm in `lib/services/srs_service.dart`:
  - 3-tier mastery scale: Novice (0-2), Intermediate (3-4), Mastered (5+)
  - Calculate next review date based on ease factor and interval
  - Update ease factor based on performance (quality 0-5 scale)
- Create `lib/models/word_mastery.dart` model
- Implement review queue generation prioritizing Novice → Intermediate → Mastered

### 2.2 Dynamic Difficulty Adjustment (DDA)

- Implement DDA service in `lib/services/dda_service.dart`:
  - Track session performance (success rate, reaction time)
  - Adjust speed/time limits based on 90%+ success rate and <2s reaction time
  - Increase difficulty by 10% increments within session
- Create difficulty parameters model for each game type

### 2.3 User Profile & Progress Tracking

- Implement `lib/services/user_service.dart`:
  - Create anonymous user profile on first launch
  - Track streak days (daily login detection)
  - Track time spent per game module
  - Update progress in real-time during sessions

### 2.4 Data Synchronization

- Implement sync service in `lib/services/sync_service.dart`:
  - Queue local changes when offline
  - Sync to Supabase on connection restore (<1s latency target)
  - Handle conflict resolution (last-write-wins for MVP)
  - Background sync on app resume

## Phase 3: Game Module 1 - Neuro-Match

### 3.1 Game Core

- Create `lib/games/neuro_match/neuro_match_game.dart`:
  - Vertical scrolling game loop using `AnimationController`
  - Falling word animation with physics
  - Multiple target zones (images) at bottom
  - Swipe gesture detection to match word to target
- Implement game state management (lives, score, current word)

### 3.2 Visual Assets & UI

- Create `lib/games/neuro_match/widgets/falling_word_widget.dart`
- Create `lib/games/neuro_match/widgets/target_zone_widget.dart`
- Design game screen layout with lives indicator, score, timer
- Add visual feedback for correct/incorrect matches

### 3.3 SRS Integration

- Fetch words from SRS review queue (prioritize Novice → Intermediate)
- Update word mastery on match result (correct/incorrect)
- Update SRS scores in real-time during gameplay

### 3.4 DDA Integration

- Adjust falling speed based on DDA service
- Adjust time limits per word based on performance
- Update difficulty parameters during session

## Phase 4: Game Module 2 - Syntax Constructor

### 4.1 Grammar Engine

- Create `lib/services/grammar_service.dart`:
  - Spanish grammar rules (subject-verb agreement, simple tenses)
  - Sentence validation logic
  - Grammar hint generation for Guided mode
- Create grammar rule models for Spanish

### 4.2 Game Core

- Create `lib/games/syntax_constructor/syntax_constructor_game.dart`:
  - Drag-and-drop word blocks using `Draggable` and `DragTarget`
  - Sentence construction area ("bridge")
  - Visual feedback: snap into place (correct) or break (incorrect)
  - Sentence validation on drop

### 4.3 Difficulty Modes

- Implement Guided mode: highlight potential word types with hints
- Implement Expert mode: no hints, full challenge
- Mode selection UI

### 4.4 SRS & DDA Integration

- Track grammar concept mastery in SRS
- Adjust sentence complexity based on DDA
- Update difficulty within session

## Phase 5: Seed Data & Content

### 5.1 Spanish Vocabulary Seed Data

- Create `lib/data/seed/spanish_vocabulary.dart`:
  - 50-100 initial Spanish words with:
    - Word text and English translation
    - Category (nouns, verbs, adjectives, etc.)
    - Image references (placeholder paths)
    - Audio references (placeholder paths)
- Create vocabulary categories/themes

### 5.2 Grammar Rules Seed Data

- Create `lib/data/seed/spanish_grammar_rules.dart`:
  - Subject-verb agreement rules
  - Simple tense rules (present, past, future)
  - Sentence templates for Syntax Constructor

### 5.3 Asset Structure

- Set up `assets/` directory structure:
  - `assets/images/words/` - Word images (placeholder)
  - `assets/audio/words/` - Word audio (placeholder)
  - `assets/images/game/` - Game UI assets

## Phase 6: UI & Navigation

### 6.1 Main Menu

- Create `lib/screens/main_menu_screen.dart`:
  - Game selection (Neuro-Match, Syntax Constructor)
  - User stats display (streak, total time)
  - Settings access
- Design modern, engaging UI matching "brain training" aesthetic

### 6.2 Navigation

- Set up `go_router` configuration in `lib/router/app_router.dart`
- Define routes: main menu, game screens, settings, progress

### 6.3 Progress & Stats

- Create `lib/screens/progress_screen.dart`:
  - Display mastery levels
  - Words learned count
  - Time spent per game
  - Streak visualization

### 6.4 Settings

- Create `lib/screens/settings_screen.dart`:
  - Audio volume controls
  - Offline mode indicator
  - Sync status

## Phase 7: Performance & Polish

### 7.1 Performance Optimization

- Implement asset preloading for <2s load time
- Optimize game animations for 60fps
- Use `const` constructors where possible
- Implement efficient state updates

### 7.2 Offline Mode

- Detect network connectivity
- Show offline indicator
- Queue all data changes locally
- Auto-sync on connection restore

### 7.3 Error Handling

- Network error handling
- Database error recovery
- Graceful degradation when offline

## File Structure

```
lib/
├── main.dart
├── config/
│   └── supabase_config.dart
├── data/
│   ├── local/
│   │   └── database_helper.dart
│   ├── remote/
│   │   └── supabase_repository.dart
│   └── seed/
│       ├── spanish_vocabulary.dart
│       └── spanish_grammar_rules.dart
├── models/
│   ├── word.dart
│   ├── word_mastery.dart
│   ├── user_profile.dart
│   └── game_session.dart
├── services/
│   ├── auth_service.dart
│   ├── srs_service.dart
│   ├── dda_service.dart
│   ├── user_service.dart
│   ├── sync_service.dart
│   └── grammar_service.dart
├── games/
│   ├── neuro_match/
│   │   ├── neuro_match_game.dart
│   │   └── widgets/
│   └── syntax_constructor/
│       ├── syntax_constructor_game.dart
│       └── widgets/
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── main_menu_screen.dart
│   ├── progress_screen.dart
│   └── settings_screen.dart
├── router/
│   └── app_router.dart
└── widgets/
    └── (shared UI components)
```

## Key Implementation Notes

1. **Supabase Setup**: Will need Supabase project URL and anon key in environment config
2. **Anonymous Users**: Use device ID or generated UUID for user identification
3. **Audio Placeholders**: Use silent audio files or simple beeps for MVP; structure ready for real recordings
4. **Seed Data**: Include 50-100 Spanish words covering basic vocabulary categories
5. **Performance**: Target <2s app launch, <0.5s transitions, 60fps gameplay
6. **Offline First**: All game functionality works offline; sync happens in background

## Testing Strategy

- Unit tests for SRS algorithm calculations
- Unit tests for grammar validation
- Widget tests for game UI components
- Integration tests for sync service
- Manual testing for performance targets

### To-dos

- [ ] Add all required Flutter packages (Supabase, Riverpod, sqflite, etc.) to pubspec.yaml and configure project structure
- [ ] Design and create Supabase database schema (user_profiles, words, word_mastery, game_sessions, sync_queue tables)
- [ ] Implement local SQLite database with matching schema and database helper class for offline support
- [ ] Implement modified SuperMemo 2 SRS algorithm with 3-tier mastery scale and review queue generation
- [ ] Implement Dynamic Difficulty Adjustment service that adjusts game pace based on 90%+ success rate and <2s reaction time
- [ ] Build data synchronization service for offline-first architecture with <1s sync latency on connection restore
- [ ] Create Spanish vocabulary seed data (50-100 words) with categories, translations, and placeholder asset references
- [ ] Build Neuro-Match game module with vertical scrolling, swipe mechanics, falling words, and target matching
- [ ] Build Syntax Constructor game with drag-and-drop, Spanish grammar validation, and Guided/Expert modes
- [ ] Implement Spanish grammar service with subject-verb agreement and simple tense validation rules
- [ ] Create main menu, navigation system, progress screen, and settings screen with modern UI design
- [ ] Optimize for <2s load time, <0.5s transitions, implement asset preloading, and ensure 60fps gameplay