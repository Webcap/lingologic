-- A2 English Lesson: Narration and Time (The Key Jump from A1)
-- This lesson teaches past tense narration and time expressions in English

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Time Expressions
('english_yesterday', 'english', 'yesterday', 'yesterday', 'time'),
('english_day_before_yesterday', 'english', 'the day before yesterday', 'the day before yesterday', 'time'),
('english_today', 'english', 'today', 'today', 'time'),
('english_tomorrow', 'english', 'tomorrow', 'tomorrow', 'time'),
('english_day_after_tomorrow', 'english', 'the day after tomorrow', 'the day after tomorrow', 'time'),
('english_ago', 'english', 'ago', 'ago', 'time'),
('english_this_week', 'english', 'this week', 'this week', 'time'),
('english_last_week', 'english', 'last week', 'last week', 'time'),
('english_this_month', 'english', 'this month', 'this month', 'time'),
('english_last_month', 'english', 'last month', 'last month', 'time'),
('english_this_year', 'english', 'this year', 'this year', 'time'),
('english_last_year', 'english', 'last year', 'last year', 'time'),
-- Narrative Connectors
('english_first', 'english', 'first', 'first', 'connectors'),
('english_then', 'english', 'then', 'then', 'connectors'),
('english_after', 'english', 'after', 'after', 'connectors'),
('english_afterward', 'english', 'afterward', 'afterward', 'connectors'),
('english_later', 'english', 'later', 'later', 'connectors'),
('english_finally', 'english', 'finally', 'finally', 'connectors'),
('english_while', 'english', 'while', 'while', 'connectors'),
-- Past Tense Verbs (Simple Past)
('english_went', 'english', 'went', 'went', 'verbs'),
('english_ate', 'english', 'ate', 'ate', 'verbs'),
('english_saw', 'english', 'saw', 'saw', 'verbs'),
('english_did', 'english', 'did', 'did', 'verbs'),
('english_said', 'english', 'said', 'said', 'verbs'),
('english_was', 'english', 'was', 'was', 'verbs'),
('english_were', 'english', 'were', 'were', 'verbs'),
-- Common Past Actions
('english_visited', 'english', 'visited', 'visited', 'verbs'),
('english_worked', 'english', 'worked', 'worked', 'verbs'),
('english_studied', 'english', 'studied', 'studied', 'verbs'),
('english_bought', 'english', 'bought', 'bought', 'verbs'),
('english_traveled', 'english', 'traveled', 'traveled', 'verbs'),
('english_cooked', 'english', 'cooked', 'cooked', 'verbs'),
('english_walked', 'english', 'walked', 'walked', 'verbs')
ON CONFLICT (id) DO NOTHING;

-- Create the A2 English lesson with comprehensive content
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
  'english_a2_narration_time',
  'Narration and Time (The Key Jump from A1)',
  'Master past tense narration and time expressions in English! Learn to tell stories and describe past events with confidence.',
  'english',
  'grammar',
  'A2',
  1,
  45,
  $lesson_json${
    "translations": {
      "es": {
        "title": "Narración y Tiempo (El Salto Clave de A1)",
        "description": "¡Domina la narración en tiempo pasado y las expresiones de tiempo en inglés! Aprende a contar historias y describir eventos pasados con confianza."
      }
    },
    "sections": [
      {
        "type": "text",
        "id": "narration_intro",
        "title": "The Key Jump from A1",
        "content": "Welcome to A2! This is where you learn to tell stories about the past. Being able to narrate past events is essential for real conversations. You'll learn the simple past tense and time expressions to talk about when things happened.",
        "examples": [
          "Yesterday I ate pizza",
          "Last week I traveled",
          "Two years ago I studied English"
        ],
        "translations": {
          "es": {
            "title": "El Salto Clave de A1",
            "content": "¡Bienvenido a A2! Aquí es donde aprendes a contar historias sobre el pasado. Poder narrar eventos pasados es esencial para conversaciones reales. Aprenderás el tiempo pasado simple y las expresiones de tiempo para hablar sobre cuándo sucedieron las cosas.",
            "examples": [
              "Yesterday I ate pizza",
              "Last week I traveled",
              "Two years ago I studied English"
            ]
          }
        }
      },
      {
        "type": "text",
        "id": "simple_past_intro",
        "title": "The Simple Past Tense",
        "content": "The simple past tense is used for completed actions in the past. It's different from the present tense - you're telling a story about something that already happened.",
        "examples": [
          "I went (not 'I go')",
          "you saw (not 'you see')",
          "he ate (not 'he eats')",
          "we were (not 'we are')",
          "they did (not 'they do')"
        ],
        "translations": {
          "es": {
            "title": "El Tiempo Pasado Simple",
            "content": "El tiempo pasado simple se usa para acciones completadas en el pasado. Es diferente del tiempo presente - estás contando una historia sobre algo que ya sucedió.",
            "examples": [
              "I went (no 'I go')",
              "you saw (no 'you see')",
              "he ate (no 'he eats')",
              "we were (no 'we are')",
              "they did (no 'they do')"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "simple_past_example_1",
        "english_example": "Yesterday I went to the supermarket. I bought bread, milk, and eggs. Then I went home and cooked.",
        "explanation": "Notice the simple past verbs: 'went' (not 'go'), 'bought' (not 'buy'), 'cooked' (not 'cook'). All actions are completed in the past. 'Yesterday' tells us when this happened.",
        "translations": {
          "es": {
            "explanation": "Nota los verbos en pasado simple: 'went' (no 'go'), 'bought' (no 'buy'), 'cooked' (no 'cook'). Todas las acciones están completadas en el pasado. 'Yesterday' nos dice cuándo sucedió esto."
          }
        }
      },
      {
        "type": "text",
        "id": "time_expressions",
        "title": "Time Expressions",
        "content": "Time expressions help you say when something happened. Learn these essential phrases to talk about the past!",
        "examples": [
          "yesterday",
          "time + ago (two days ago)",
          "last week",
          "last year",
          "the day before yesterday"
        ],
        "translations": {
          "es": {
            "title": "Expresiones de Tiempo",
            "content": "Las expresiones de tiempo te ayudan a decir cuándo sucedió algo. ¡Aprende estas frases esenciales para hablar sobre el pasado!",
            "examples": [
              "yesterday",
              "time + ago (two days ago)",
              "last week",
              "last year",
              "the day before yesterday"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "time_expressions_example",
        "english_example": "Three years ago I studied in London. Last year I visited Paris. Last week I went to the movies.",
        "explanation": "'Time + ago' means 'time ago'. 'Three years ago' means 'three years in the past'. Use 'ago' after the time period. 'Last week' and 'last year' mean 'the week/year before this one'.",
        "translations": {
          "es": {
            "explanation": "'Time + ago' significa 'hace tiempo'. 'Three years ago' significa 'hace tres años'. Usa 'ago' después del período de tiempo. 'Last week' y 'last year' significan 'la semana/el año anterior a este'."
          }
        }
      },
      {
        "type": "text",
        "id": "narrative_connectors",
        "title": "Narrative Connectors",
        "content": "Use these words to connect events in a story and show the sequence of what happened!",
        "examples": [
          "first",
          "then",
          "after",
          "later",
          "finally"
        ],
        "translations": {
          "es": {
            "title": "Conectores Narrativos",
            "content": "¡Usa estas palabras para conectar eventos en una historia y mostrar la secuencia de lo que sucedió!",
            "examples": [
              "first",
              "then",
              "after",
              "later",
              "finally"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "narrative_example",
        "english_example": "First I got up. Then I showered and had breakfast. Later I went to work. Finally, I returned home.",
        "explanation": "These connectors help you tell a story in order: first, then, later, finally. They make your narration clear and easy to follow. You can also use 'afterward' instead of 'then'.",
        "translations": {
          "es": {
            "explanation": "Estos conectores te ayudan a contar una historia en orden: first, then, later, finally. Hacen que tu narración sea clara y fácil de seguir. También puedes usar 'afterward' en lugar de 'then'."
          }
        }
      },
      {
        "type": "text",
        "id": "regular_irregular_verbs",
        "title": "Regular and Irregular Verbs",
        "content": "In the simple past, some verbs add '-ed' (regular), but many common verbs are irregular!",
        "examples": [
          "Regular: walked, cooked, worked, studied",
          "Irregular: went (go), saw (see), ate (eat), did (do), was/were (be)"
        ],
        "translations": {
          "es": {
            "title": "Verbos Regulares e Irregulares",
            "content": "En el pasado simple, algunos verbos agregan '-ed' (regulares), ¡pero muchos verbos comunes son irregulares!",
            "examples": [
              "Regulares: walked, cooked, worked, studied",
              "Irregulares: went (go), saw (see), ate (eat), did (do), was/were (be)"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "irregular_example",
        "english_example": "Yesterday I went to the beach. It was very sunny. I saw my friends. I gave them a gift.",
        "explanation": "Notice the irregular past forms: 'went' (not 'goed'), 'was' (not 'beed'), 'saw' (not 'seed'), 'gave' (not 'gived'). These don't follow the -ed pattern, so you need to memorize them.",
        "translations": {
          "es": {
            "explanation": "Nota las formas irregulares del pasado: 'went' (no 'goed'), 'was' (no 'beed'), 'saw' (no 'seed'), 'gave' (no 'gived'). Estas no siguen el patrón -ed, por lo que necesitas memorizarlas."
          }
        }
      },
      {
        "type": "matching",
        "id": "time_expressions_matching",
        "instruction": "Match the English time expressions with their meanings",
        "pairs": [
          {"word": "yesterday", "translation": "the day before today"},
          {"word": "two days ago", "translation": "two days in the past"},
          {"word": "last week", "translation": "the week before this week"},
          {"word": "last year", "translation": "the year before this year"},
          {"word": "first", "translation": "before everything else"},
          {"word": "finally", "translation": "at the end"}
        ],
        "distractors": ["tomorrow", "today"],
        "explanation": "Excellent! These time expressions are essential for telling stories. Remember: 'ago' goes after the time - 'two days ago', 'three years ago'. Use them with simple past verbs to talk about the past.",
        "translations": {
          "es": {
            "instruction": "Empareja las expresiones de tiempo en inglés con sus significados",
            "explanation": "¡Excelente! Estas expresiones de tiempo son esenciales para contar historias. Recuerda: 'ago' va después del tiempo - 'two days ago', 'three years ago'. Úsalas con verbos en pasado simple para hablar sobre el pasado."
          }
        }
      },
      {
        "type": "text",
        "id": "telling_stories",
        "title": "Telling a Complete Story",
        "content": "Now you can combine everything: past tense verbs, time expressions, and connectors to tell complete stories!",
        "examples": [
          "Start with a time expression: 'Yesterday...' or 'Last month...'",
          "Use narrative connectors: 'First...', 'Then...', 'Finally...'",
          "Use simple past verbs: 'went', 'ate', 'saw', 'did'"
        ],
        "translations": {
          "es": {
            "title": "Contar una Historia Completa",
            "content": "¡Ahora puedes combinar todo: verbos en tiempo pasado, expresiones de tiempo y conectores para contar historias completas!",
            "examples": [
              "Comienza con una expresión de tiempo: 'Yesterday...' o 'Last month...'",
              "Usa conectores narrativos: 'First...', 'Then...', 'Finally...'",
              "Usa verbos en pasado simple: 'went', 'ate', 'saw', 'did'"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "complete_story_example",
        "english_example": "Yesterday was a very good day. First, I had breakfast with my family. Then, I went to the park and walked. Later, I visited a friend. Finally, I returned home and rested.",
        "explanation": "This is a complete story! Notice how it uses: time expression (Yesterday), narrative connectors (First, Then, Later, Finally), and simple past verbs (was, had, went, walked, visited, returned, rested).",
        "translations": {
          "es": {
            "explanation": "¡Esta es una historia completa! Nota cómo usa: expresión de tiempo (Yesterday), conectores narrativos (First, Then, Later, Finally), y verbos en pasado simple (was, had, went, walked, visited, returned, rested)."
          }
        }
      },
      {
        "type": "exercise",
        "id": "simple_past_exercise",
        "question": "How do you say 'I went' in English using the simple past tense?",
        "options": [
          {"text": "went", "is_correct": true},
          {"text": "go", "is_correct": false},
          {"text": "going", "is_correct": false},
          {"text": "was going", "is_correct": false}
        ],
        "explanation": "Perfect! 'Went' is the simple past form of 'go'. 'Go' is present tense (I go), 'going' is present participle (I am going), and 'was going' is past continuous (I was going). Use 'went' to say 'I went' in the past.",
        "translations": {
          "es": {
            "question": "¿Cómo dices 'I went' en inglés usando el tiempo pasado simple?",
            "options": [
              {"text": "went", "is_correct": true},
              {"text": "go", "is_correct": false},
              {"text": "going", "is_correct": false},
              {"text": "was going", "is_correct": false}
            ],
            "explanation": "¡Perfecto! 'Went' es la forma del pasado simple de 'go'. 'Go' es tiempo presente (I go), 'going' es participio presente (I am going), y 'was going' es pasado continuo (I was going). Usa 'went' para decir 'I went' en el pasado."
          }
        }
      },
      {
        "type": "text",
        "id": "practice_tips",
        "title": "Practice Tips",
        "content": "Here are tips to master past tense narration:",
        "examples": [
          "Practice telling what you did yesterday: 'Yesterday I...'",
          "Describe your last vacation: 'Last year I traveled to...'",
          "Tell a story about last weekend: 'Last weekend...'",
          "Use narrative connectors to make your stories flow",
          "Focus on learning the most common irregular verbs first (go, see, eat, do, be)"
        ],
        "translations": {
          "es": {
            "title": "Consejos de Práctica",
            "content": "Aquí hay consejos para dominar la narración en tiempo pasado:",
            "examples": [
              "Practica contando lo que hiciste ayer: 'Yesterday I...'",
              "Describe tus últimas vacaciones: 'Last year I traveled to...'",
              "Cuenta una historia sobre el fin de semana pasado: 'Last weekend...'",
              "Usa conectores narrativos para que tus historias fluyan",
              "Enfócate en aprender primero los verbos irregulares más comunes (go, see, eat, do, be)"
            ]
          }
        }
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'english_yesterday', 'english_day_before_yesterday', 'english_today', 'english_tomorrow', 'english_day_after_tomorrow',
    'english_ago', 'english_this_week', 'english_last_week', 'english_this_month', 'english_last_month',
    'english_this_year', 'english_last_year',
    'english_first', 'english_then', 'english_after', 'english_afterward', 'english_later', 'english_finally', 'english_while',
    'english_went', 'english_ate', 'english_saw', 'english_did', 'english_said', 'english_was', 'english_were',
    'english_visited', 'english_worked', 'english_studied', 'english_bought', 'english_traveled', 'english_cooked', 'english_walked'
  ]::TEXT[],
  ARRAY['simple_past_tense', 'irregular_verbs', 'time_expressions', 'narrative_connectors', 'past_tense_narration']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  updated_at = NOW();

COMMENT ON TABLE words IS 'Vocabulary words unlocked by this lesson include time expressions, narrative connectors, and past tense verbs';


