-- A2 Spanish Lesson: Narration and Time (The Key Jump from A1)
-- This lesson teaches past tense narration and time expressions in Spanish

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Time Expressions
('spanish_ayer', 'spanish', 'ayer', 'yesterday', 'time'),
('spanish_anteayer', 'spanish', 'anteayer', 'the day before yesterday', 'time'),
('spanish_hoy', 'spanish', 'hoy', 'today', 'time'),
('spanish_mañana', 'spanish', 'mañana', 'tomorrow', 'time'),
('spanish_pasado_mañana', 'spanish', 'pasado mañana', 'the day after tomorrow', 'time'),
('spanish_hace', 'spanish', 'hace', 'ago', 'time'),
('spanish_esta_semana', 'spanish', 'esta semana', 'this week', 'time'),
('spanish_semana_pasada', 'spanish', 'la semana pasada', 'last week', 'time'),
('spanish_esta_mes', 'spanish', 'este mes', 'this month', 'time'),
('spanish_mes_pasado', 'spanish', 'el mes pasado', 'last month', 'time'),
('spanish_este_año', 'spanish', 'este año', 'this year', 'time'),
('spanish_año_pasado', 'spanish', 'el año pasado', 'last year', 'time'),
-- Narrative Connectors
('spanish_primero', 'spanish', 'primero', 'first', 'connectors'),
('spanish_despues', 'spanish', 'después', 'after/then', 'connectors'),
('spanish_luego', 'spanish', 'luego', 'then/later', 'connectors'),
('spanish_finalmente', 'spanish', 'finalmente', 'finally', 'connectors'),
('spanish_entonces', 'spanish', 'entonces', 'then/so', 'connectors'),
('spanish_mientras', 'spanish', 'mientras', 'while', 'connectors'),
-- Past Tense Verbs (Pretérito)
('spanish_fui', 'spanish', 'fui', 'I went/was', 'verbs'),
('spanish_fue', 'spanish', 'fue', 'he/she went/was', 'verbs'),
('spanish_comi', 'spanish', 'comí', 'I ate', 'verbs'),
('spanish_comio', 'spanish', 'comió', 'he/she ate', 'verbs'),
('spanish_vi', 'spanish', 'vi', 'I saw', 'verbs'),
('spanish_vio', 'spanish', 'vio', 'he/she saw', 'verbs'),
('spanish_hice', 'spanish', 'hice', 'I did/made', 'verbs'),
('spanish_hizo', 'spanish', 'hizo', 'he/she did/made', 'verbs'),
('spanish_dije', 'spanish', 'dije', 'I said', 'verbs'),
('spanish_dijo', 'spanish', 'dijo', 'he/she said', 'verbs'),
('spanish_estuve', 'spanish', 'estuve', 'I was (location)', 'verbs'),
('spanish_estuvo', 'spanish', 'estuvo', 'he/she was (location)', 'verbs'),
-- Common Past Actions
('spanish_visite', 'spanish', 'visité', 'I visited', 'verbs'),
('spanish_trabaje', 'spanish', 'trabajé', 'I worked', 'verbs'),
('spanish_estudie', 'spanish', 'estudié', 'I studied', 'verbs'),
('spanish_compre', 'spanish', 'compré', 'I bought', 'verbs'),
('spanish_viaje', 'spanish', 'viajé', 'I traveled', 'verbs')
ON CONFLICT (id) DO NOTHING;

-- Create the A2 Spanish lesson with comprehensive content
INSERT INTO lessons (
  id,
  title,
  description,
  language,
  category,
  level,
  order_index,
  estimated_minutes,
  content_json,
  unlocks_word_ids,
  unlocks_grammar_concepts
) VALUES (
  'spanish_a2_narration_time',
  'Narration and Time (The Key Jump from A1)',
  'Master past tense narration and time expressions in Spanish! Learn to tell stories and describe past events with confidence.',
  'spanish',
  'grammar',
  'A2',
  1,
  45,
  $lesson_json${
    "sections": [
      {
        "type": "text",
        "id": "narration_intro",
        "title": "The Key Jump from A1",
        "content": "Welcome to A2! This is where you learn to tell stories about the past. Being able to narrate past events is essential for real conversations. You'll learn the pretérito (simple past tense) and time expressions to talk about when things happened.",
        "examples": [
          "Ayer comí pizza (Yesterday I ate pizza)",
          "La semana pasada viajé (Last week I traveled)",
          "Hace dos años estudié español (Two years ago I studied Spanish)"
        ]
      },
      {
        "type": "text",
        "id": "pretérito_intro",
        "title": "The Pretérito (Simple Past Tense)",
        "content": "The pretérito is used for completed actions in the past. It's different from the present tense - you're telling a story about something that already happened.",
        "examples": [
          "comí (I ate)",
          "fuiste (you went)",
          "vio (he/she saw)",
          "estuvimos (we were)",
          "fueron (they went)"
        ]
      },
      {
        "type": "example",
        "id": "pretérito_example_1",
        "spanish_example": "Ayer fui al supermercado. Compré pan, leche y huevos. Después fui a casa y cociné.",
        "english_translation": "Yesterday I went to the supermarket. I bought bread, milk, and eggs. Then I went home and cooked.",
        "explanation": "Notice the pretérito verbs: 'fui' (went), 'compré' (bought), 'cociné' (cooked). All actions are completed in the past. 'Ayer' (yesterday) tells us when this happened."
      },
      {
        "type": "text",
        "id": "time_expressions",
        "title": "Time Expressions",
        "content": "Time expressions help you say when something happened. Learn these essential phrases to talk about the past!",
        "examples": [
          "ayer (yesterday)",
          "hace + tiempo (ago)",
          "la semana pasada (last week)",
          "el año pasado (last year)",
          "hace dos días (two days ago)"
        ]
      },
      {
        "type": "example",
        "id": "time_expressions_example",
        "spanish_example": "Hace tres años estudié en Madrid. El año pasado visité Barcelona. La semana pasada fui al cine.",
        "english_translation": "Three years ago I studied in Madrid. Last year I visited Barcelona. Last week I went to the movies.",
        "explanation": "'Hace + tiempo' means 'time ago'. 'Hace tres años' = 'three years ago'. Use 'hace' before the time period. 'La semana pasada' and 'el año pasado' mean 'last week' and 'last year'."
      },
      {
        "type": "text",
        "id": "narrative_connectors",
        "title": "Narrative Connectors",
        "content": "Use these words to connect events in a story and show the sequence of what happened!",
        "examples": [
          "primero (first)",
          "después (after/then)",
          "luego (then/later)",
          "entonces (then/so)",
          "finalmente (finally)"
        ]
      },
      {
        "type": "example",
        "id": "narrative_example",
        "spanish_example": "Primero me levanté. Después me duché y desayuné. Luego fui al trabajo. Finalmente, regresé a casa.",
        "english_translation": "First I got up. Then I showered and had breakfast. Later I went to work. Finally, I returned home.",
        "explanation": "These connectors help you tell a story in order: primero (first), después (then), luego (later), finalmente (finally). They make your narration clear and easy to follow."
      },
      {
        "type": "matching",
        "id": "time_expressions_matching",
        "instruction": "Match the Spanish time expressions with their English translations",
        "pairs": [
          {"word": "ayer", "translation": "yesterday"},
          {"word": "hace dos días", "translation": "two days ago"},
          {"word": "la semana pasada", "translation": "last week"},
          {"word": "el año pasado", "translation": "last year"},
          {"word": "primero", "translation": "first"},
          {"word": "finalmente", "translation": "finally"}
        ],
        "distractors": ["tomorrow", "today"],
        "explanation": "Excellent! These time expressions are essential for telling stories. Remember: 'hace' means 'ago' - 'hace dos días' = 'two days ago'. Use them with pretérito verbs to talk about the past."
      },
      {
        "type": "text",
        "id": "pretérito_irregular",
        "title": "Important Irregular Verbs",
        "content": "Some verbs are irregular in the pretérito. These are very common, so learn them well!",
        "examples": [
          "ser/ir: fui, fuiste, fue, fuimos, fueron",
          "hacer: hice, hiciste, hizo, hicimos, hicieron",
          "ver: vi, viste, vio, vimos, vieron",
          "dar: di, diste, dio, dimos, dieron"
        ]
      },
      {
        "type": "example",
        "id": "irregular_example",
        "spanish_example": "Ayer fui a la playa. Hice mucho sol. Vi a mis amigos. Les di un regalo.",
        "english_translation": "Yesterday I went to the beach. It was very sunny. I saw my friends. I gave them a gift.",
        "explanation": "Notice the irregular pretérito forms: 'fui' (went/was), 'hice' (did/made), 'vi' (saw), 'di' (gave). These don't follow the regular -é, -aste, -ó pattern, so you need to memorize them."
      },
      {
        "type": "text",
        "id": "telling_stories",
        "title": "Telling a Complete Story",
        "content": "Now you can combine everything: past tense verbs, time expressions, and connectors to tell complete stories!",
        "examples": [
          "Start with a time expression: 'Ayer...' or 'Hace un mes...'",
          "Use narrative connectors: 'Primero...', 'Después...', 'Finalmente...'",
          "Use pretérito verbs: 'fui', 'comí', 'vi', 'hice'"
        ]
      },
      {
        "type": "example",
        "id": "complete_story_example",
        "spanish_example": "Ayer fue un día muy bueno. Primero, desayuné con mi familia. Después, fui al parque y caminé. Luego, visité a un amigo. Finalmente, regresé a casa y descansé.",
        "english_translation": "Yesterday was a very good day. First, I had breakfast with my family. Then, I went to the park and walked. Later, I visited a friend. Finally, I returned home and rested.",
        "explanation": "This is a complete story! Notice how it uses: time expression (Ayer), narrative connectors (Primero, Después, Luego, Finalmente), and pretérito verbs (fue, desayuné, fui, caminé, visité, regresé, descansé)."
      },
      {
        "type": "exercise",
        "id": "pretérito_exercise",
        "question": "How do you say 'I went' in Spanish using the pretérito?",
        "options": [
          {"text": "fui", "is_correct": true},
          {"text": "voy", "is_correct": false},
          {"text": "iba", "is_correct": false},
          {"text": "fue", "is_correct": false}
        ],
        "explanation": "Perfect! 'Fui' is the pretérito (past tense) form of 'ir' (to go) for 'I'. 'Voy' is present tense (I go), 'iba' is imperfect (I was going), and 'fue' is 'he/she went'. Use 'fui' to say 'I went' in the past."
      },
      {
        "type": "text",
        "id": "practice_tips",
        "title": "Practice Tips",
        "content": "Here are tips to master past tense narration:",
        "examples": [
          "Practice telling what you did yesterday: 'Ayer...'",
          "Describe your last vacation: 'El año pasado viajé a...'",
          "Tell a story about last weekend: 'El fin de semana pasado...'",
          "Use narrative connectors to make your stories flow",
          "Focus on learning the most common irregular verbs first"
        ]
      }
    ]
  }$lesson_json$,
  ARRAY[
    'spanish_ayer', 'spanish_anteayer', 'spanish_hoy', 'spanish_mañana', 'spanish_pasado_mañana',
    'spanish_hace', 'spanish_esta_semana', 'spanish_semana_pasada', 'spanish_esta_mes', 'spanish_mes_pasado',
    'spanish_este_año', 'spanish_año_pasado',
    'spanish_primero', 'spanish_despues', 'spanish_luego', 'spanish_finalmente', 'spanish_entonces', 'spanish_mientras',
    'spanish_fui', 'spanish_fue', 'spanish_comi', 'spanish_comio', 'spanish_vi', 'spanish_vio',
    'spanish_hice', 'spanish_hizo', 'spanish_dije', 'spanish_dijo', 'spanish_estuve', 'spanish_estuvo',
    'spanish_visite', 'spanish_trabaje', 'spanish_estudie', 'spanish_compre', 'spanish_viaje'
  ],
  ARRAY['pretérito', 'irregular_verbs', 'time_expressions', 'narrative_connectors', 'past_tense_narration']
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  updated_at = NOW();

COMMENT ON TABLE words IS 'Vocabulary words unlocked by this lesson include time expressions, narrative connectors, and past tense verbs';

