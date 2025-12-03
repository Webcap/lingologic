-- A1 Spanish Lesson: Daily Routines and Actions
-- This lesson teaches daily routine vocabulary and how to describe daily activities in Spanish

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Morning Routine
('spanish_despertarse', 'spanish', 'despertarse', 'to wake up', 'routines'),
('spanish_levantarse', 'spanish', 'levantarse', 'to get up', 'routines'),
('spanish_ducharse', 'spanish', 'ducharse', 'to shower', 'routines'),
('spanish_banarse', 'spanish', 'bañarse', 'to bathe', 'routines'),
('spanish_cepillarse_dientes', 'spanish', 'cepillarse los dientes', 'to brush teeth', 'routines'),
('spanish_peinarse', 'spanish', 'peinarse', 'to comb hair', 'routines'),
('spanish_vestirse', 'spanish', 'vestirse', 'to get dressed', 'routines'),
('spanish_desayunar', 'spanish', 'desayunar', 'to have breakfast', 'routines'),
-- Daily Activities
('spanish_trabajar', 'spanish', 'trabajar', 'to work', 'activities'),
('spanish_estudiar', 'spanish', 'estudiar', 'to study', 'activities'),
('spanish_comer', 'spanish', 'comer', 'to eat', 'activities'),
('spanish_almorzar', 'spanish', 'almorzar', 'to have lunch', 'activities'),
('spanish_cenar', 'spanish', 'cenar', 'to have dinner', 'activities'),
('spanish_beber', 'spanish', 'beber', 'to drink', 'activities'),
('spanish_cocinar', 'spanish', 'cocinar', 'to cook', 'activities'),
('spanish_limpiar', 'spanish', 'limpiar', 'to clean', 'activities'),
('spanish_hacer_tarea', 'spanish', 'hacer la tarea', 'to do homework', 'activities'),
('spanish_leer', 'spanish', 'leer', 'to read', 'activities'),
('spanish_ver_tv', 'spanish', 'ver la televisión', 'to watch TV', 'activities'),
('spanish_escuchar_musica', 'spanish', 'escuchar música', 'to listen to music', 'activities'),
('spanish_salir', 'spanish', 'salir', 'to go out', 'activities'),
('spanish_regresar', 'spanish', 'regresar', 'to return', 'activities'),
('spanish_llegar', 'spanish', 'llegar', 'to arrive', 'activities'),
-- Evening/Night Routine
('spanish_descansar', 'spanish', 'descansar', 'to rest', 'routines'),
('spanish_relajarse', 'spanish', 'relajarse', 'to relax', 'routines'),
('spanish_dormir', 'spanish', 'dormir', 'to sleep', 'routines'),
('spanish_acostarse', 'spanish', 'acostarse', 'to go to bed', 'routines'),
-- Time Expressions
('spanish_manana_early', 'spanish', 'por la mañana', 'in the morning', 'time'),
('spanish_tarde', 'spanish', 'por la tarde', 'in the afternoon', 'time'),
('spanish_noche', 'spanish', 'por la noche', 'at night', 'time'),
('spanish_temprano', 'spanish', 'temprano', 'early', 'time'),
('spanish_tarde_late', 'spanish', 'tarde', 'late', 'time'),
-- Sequence Words
('spanish_primero', 'spanish', 'primero', 'first', 'sequence'),
('spanish_despues', 'spanish', 'después', 'after/then', 'sequence'),
('spanish_luego', 'spanish', 'luego', 'then/later', 'sequence'),
('spanish_finalmente', 'spanish', 'finalmente', 'finally', 'sequence'),
('spanish_antes_de', 'spanish', 'antes de', 'before', 'sequence'),
-- Questions
('spanish_que_haces', 'spanish', '¿qué haces?', 'what do you do?', 'questions'),
('spanish_a_que_hora', 'spanish', '¿a qué hora...?', 'at what time...?', 'questions'),
('spanish_cuando', 'spanish', '¿cuándo...?', 'when...?', 'questions')
ON CONFLICT (id) DO NOTHING;

-- Create the A1 Spanish lesson with comprehensive content
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
  'spanish_a1_daily_routines_actions',
  'Daily Routines and Actions',
  'Learn to describe your daily routines and activities in Spanish. Essential vocabulary for talking about what you do every day!',
  'spanish',
  'vocabulary',
  'A1',
  7,
  35,
  $lesson_json${
    "sections": [
      {
        "type": "text",
        "id": "morning_routine_intro",
        "title": "Morning Routine",
        "content": "Let's learn vocabulary for your morning routine! These reflexive verbs describe actions you do to yourself every morning.",
        "examples": [
          "despertarse (to wake up)",
          "levantarse (to get up)",
          "ducharse (to shower)",
          "cepillarse los dientes (to brush teeth)",
          "desayunar (to have breakfast)"
        ]
      },
      {
        "type": "example",
        "id": "morning_routine_example_1",
        "spanish_example": "Por la mañana, me despierto a las siete. Me levanto, me ducho y desayuno.",
        "english_translation": "In the morning, I wake up at seven. I get up, shower, and have breakfast.",
        "explanation": "Notice how reflexive verbs use 'me' (me despierto, me levanto, me ducho). 'A las siete' means 'at seven o'clock'."
      },
      {
        "type": "example",
        "id": "morning_routine_example_2",
        "spanish_example": "Primero me cepillo los dientes, después me peino y finalmente me visto.",
        "english_translation": "First I brush my teeth, then I comb my hair, and finally I get dressed.",
        "explanation": "Use 'primero' (first), 'después' (after/then), and 'finalmente' (finally) to sequence your routine. Reflexive verbs end in '-se'."
      },
      {
        "type": "matching",
        "id": "morning_routine_matching_1",
        "instruction": "Match the morning routine verbs with their English translations",
        "pairs": [
          {"word": "despertarse", "translation": "to wake up"},
          {"word": "levantarse", "translation": "to get up"},
          {"word": "ducharse", "translation": "to shower"},
          {"word": "cepillarse los dientes", "translation": "to brush teeth"},
          {"word": "vestirse", "translation": "to get dressed"},
          {"word": "desayunar", "translation": "to have breakfast"}
        ],
        "distractors": ["to eat", "to sleep"],
        "explanation": "Great job! These are reflexive verbs - they use 'me', 'te', 'se' depending on who is doing the action. 'Me despierto' = I wake up."
      },
      {
        "type": "exercise",
        "id": "morning_routine_exercise_1",
        "question": "How do you say 'to wake up' in Spanish?",
        "options": [
          {"text": "despertarse", "is_correct": true},
          {"text": "levantarse", "is_correct": false},
          {"text": "dormir", "is_correct": false},
          {"text": "acostarse", "is_correct": false}
        ],
        "explanation": "'Despertarse' means 'to wake up'. It's a reflexive verb, so you say 'me despierto' (I wake up)."
      },
      {
        "type": "text",
        "id": "daily_activities_intro",
        "title": "Daily Activities",
        "content": "Now let's learn verbs for common daily activities like working, studying, eating, and other things you do during the day!",
        "examples": [
          "trabajar (to work)",
          "estudiar (to study)",
          "comer (to eat)",
          "leer (to read)",
          "limpiar (to clean)"
        ]
      },
      {
        "type": "example",
        "id": "daily_activities_example_1",
        "spanish_example": "Por la tarde trabajo y estudio. Después almuerzo con mis amigos.",
        "english_translation": "In the afternoon I work and study. After that I have lunch with my friends.",
        "explanation": "'Por la tarde' means 'in the afternoon'. Notice how we use 'y' (and) to connect activities."
      },
      {
        "type": "example",
        "id": "daily_activities_example_2",
        "spanish_example": "Me gusta leer y escuchar música por la noche. Después ceno y me relajo.",
        "english_translation": "I like to read and listen to music at night. After that I have dinner and relax.",
        "explanation": "'Por la noche' means 'at night'. Use 'después' (after/then) to connect actions in sequence."
      },
      {
        "type": "matching",
        "id": "daily_activities_matching_1",
        "instruction": "Match the daily activity verbs with their translations",
        "pairs": [
          {"word": "trabajar", "translation": "to work"},
          {"word": "estudiar", "translation": "to study"},
          {"word": "comer", "translation": "to eat"},
          {"word": "beber", "translation": "to drink"},
          {"word": "leer", "translation": "to read"},
          {"word": "cocinar", "translation": "to cook"}
        ],
        "distractors": ["to sleep", "to wake up"],
        "explanation": "Excellent! These are regular verbs for daily activities. They follow standard conjugation patterns: 'trabajo' (I work), 'estudias' (you study)."
      },
      {
        "type": "exercise",
        "id": "daily_activities_exercise_1",
        "question": "Complete: 'Por la tarde ___ y luego ___' (In the afternoon I work and then I study)",
        "options": [
          {"text": "trabajo, estudio", "is_correct": true},
          {"text": "trabajar, estudiar", "is_correct": false},
          {"text": "trabaja, estudia", "is_correct": false},
          {"text": "trabajamos, estudiamos", "is_correct": false}
        ],
        "explanation": "Use conjugated verbs: 'trabajo' (I work) and 'estudio' (I study). The infinitive forms (trabajar, estudiar) don't work here."
      },
      {
        "type": "text",
        "id": "evening_routine_intro",
        "title": "Evening and Night Routine",
        "content": "Let's learn vocabulary for your evening and night routine. These verbs describe how you end your day!",
        "examples": [
          "descansar (to rest)",
          "relajarse (to relax)",
          "dormir (to sleep)",
          "acostarse (to go to bed)"
        ]
      },
      {
        "type": "example",
        "id": "evening_routine_example_1",
        "spanish_example": "Por la noche, después de cenar, me relajo. Finalmente me acuesto a las once.",
        "english_translation": "At night, after dinner, I relax. Finally I go to bed at eleven.",
        "explanation": "'Después de cenar' means 'after having dinner'. 'Me acuesto' means 'I go to bed' (reflexive verb)."
      },
      {
        "type": "matching",
        "id": "evening_routine_matching_1",
        "instruction": "Match the evening/night activities with their meanings",
        "pairs": [
          {"word": "descansar", "translation": "to rest"},
          {"word": "relajarse", "translation": "to relax"},
          {"word": "dormir", "translation": "to sleep"},
          {"word": "acostarse", "translation": "to go to bed"}
        ],
        "explanation": "Perfect! 'Dormir' means 'to sleep' (the action), while 'acostarse' means 'to go to bed' (getting into bed)."
      },
      {
        "type": "exercise",
        "id": "evening_routine_exercise_1",
        "question": "How do you say 'to go to bed' in Spanish?",
        "options": [
          {"text": "acostarse", "is_correct": true},
          {"text": "dormir", "is_correct": false},
          {"text": "descansar", "is_correct": false},
          {"text": "levantarse", "is_correct": false}
        ],
        "explanation": "'Acostarse' means 'to go to bed'. 'Dormir' is just 'to sleep'. Say 'me acuesto' for 'I go to bed'."
      },
      {
        "type": "text",
        "id": "time_expressions_intro",
        "title": "Time Expressions",
        "content": "Let's learn how to talk about when you do things. Time expressions help you organize your daily routine!",
        "examples": [
          "por la mañana (in the morning)",
          "por la tarde (in the afternoon)",
          "por la noche (at night)",
          "temprano (early)",
          "tarde (late)"
        ]
      },
      {
        "type": "example",
        "id": "time_expressions_example_1",
        "spanish_example": "Me despierto temprano por la mañana. Trabajo por la tarde y descanso por la noche.",
        "english_translation": "I wake up early in the morning. I work in the afternoon and rest at night.",
        "explanation": "Use 'por la mañana/tarde/noche' to specify time of day. 'Temprano' means early, 'tarde' means late."
      },
      {
        "type": "matching",
        "id": "time_expressions_matching_1",
        "instruction": "Match the time expressions with their meanings",
        "pairs": [
          {"word": "por la mañana", "translation": "in the morning"},
          {"word": "por la tarde", "translation": "in the afternoon"},
          {"word": "por la noche", "translation": "at night"},
          {"word": "temprano", "translation": "early"},
          {"word": "tarde", "translation": "late"}
        ],
        "explanation": "Great! 'Por la mañana/tarde/noche' describe parts of the day. Remember to use 'por' before these time expressions."
      },
      {
        "type": "text",
        "id": "sequence_words_intro",
        "title": "Sequence Words",
        "content": "Let's learn words to describe the order of your daily activities. These help you tell a story about your day!",
        "examples": [
          "primero (first)",
          "después (after/then)",
          "luego (then/later)",
          "finalmente (finally)",
          "antes de (before)"
        ]
      },
      {
        "type": "example",
        "id": "sequence_words_example_1",
        "spanish_example": "Primero me levanto, después me ducho. Luego desayuno y finalmente salgo de casa.",
        "english_translation": "First I get up, then I shower. Later I have breakfast and finally I leave home.",
        "explanation": "Sequence words help organize your routine: 'primero', 'después', 'luego', 'finalmente' show the order of actions."
      },
      {
        "type": "exercise",
        "id": "sequence_words_exercise_1",
        "question": "Which word means 'first' in Spanish?",
        "options": [
          {"text": "primero", "is_correct": true},
          {"text": "después", "is_correct": false},
          {"text": "luego", "is_correct": false},
          {"text": "finalmente", "is_correct": false}
        ],
        "explanation": "'Primero' means 'first'. Use it to start describing a sequence: 'Primero...' (First...)"
      },
      {
        "type": "text",
        "id": "asking_questions_intro",
        "title": "Asking About Daily Routines",
        "content": "Let's learn how to ask questions about daily routines and activities. These are very useful in conversations!",
        "examples": [
          "¿Qué haces? (What do you do?)",
          "¿A qué hora te levantas? (At what time do you get up?)",
          "¿Cuándo comes? (When do you eat?)"
        ]
      },
      {
        "type": "example",
        "id": "asking_questions_example_1",
        "spanish_example": "A: ¿A qué hora te despiertas? / B: Me despierto a las seis y media.",
        "english_translation": "A: At what time do you wake up? / B: I wake up at six thirty.",
        "explanation": "'¿A qué hora...?' asks 'At what time...?'. Answer with 'a las [time]' (at [time]). 'Y media' means 'and a half' (30 minutes)."
      },
      {
        "type": "exercise",
        "id": "asking_questions_exercise_1",
        "question": "How do you ask 'At what time do you get up?' in Spanish?",
        "options": [
          {"text": "¿A qué hora te levantas?", "is_correct": true},
          {"text": "¿Qué hora te levantas?", "is_correct": false},
          {"text": "¿Cuándo te levantas?", "is_correct": false},
          {"text": "¿Qué haces?", "is_correct": false}
        ],
        "explanation": "'¿A qué hora te levantas?' is the correct way to ask at what time someone gets up. 'Te levantas' is the reflexive form."
      },
      {
        "type": "text",
        "id": "putting_it_together",
        "title": "Putting It All Together",
        "content": "Now you can describe your complete daily routine! Practice using all the vocabulary you've learned about routines, activities, time, and sequence.",
        "examples": [
          "Full routine: 'Por la mañana me levanto temprano. Primero me ducho, después desayuno y finalmente voy a trabajar.'",
          "Asking questions: '¿Qué haces por la tarde?' (What do you do in the afternoon?)",
          "Talking about time: 'Almuerzo a la una y ceno a las ocho.' (I have lunch at one and dinner at eight.)"
        ]
      },
      {
        "type": "matching",
        "id": "comprehensive_matching_1",
        "instruction": "Match the daily routine words with their translations",
        "pairs": [
          {"word": "despertarse", "translation": "to wake up"},
          {"word": "trabajar", "translation": "to work"},
          {"word": "almorzar", "translation": "to have lunch"},
          {"word": "por la mañana", "translation": "in the morning"},
          {"word": "primero", "translation": "first"},
          {"word": "acostarse", "translation": "to go to bed"},
          {"word": "dormir", "translation": "to sleep"},
          {"word": "temprano", "translation": "early"}
        ],
        "distractors": ["late", "afternoon"],
        "explanation": "Fantastic! You've mastered daily routines and actions vocabulary. Keep practicing to remember all these verbs and time expressions!"
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "Complete: '___ me levanto, ___ desayuno y ___ voy a trabajar' (First I get up, then I have breakfast, and finally I go to work)",
        "options": [
          {"text": "Primero, después, finalmente", "is_correct": true},
          {"text": "Después, primero, luego", "is_correct": false},
          {"text": "Luego, finalmente, primero", "is_correct": false},
          {"text": "Finalmente, primero, después", "is_correct": false}
        ],
        "explanation": "The correct sequence is: 'Primero' (first), 'después' (then), 'finalmente' (finally). This shows the order of actions."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "How would you say 'I wake up early in the morning'?",
        "options": [
          {"text": "Me despierto temprano por la mañana", "is_correct": true},
          {"text": "Me levanto temprano por la mañana", "is_correct": false},
          {"text": "Despierto temprano por la mañana", "is_correct": false},
          {"text": "Me despierto tarde por la mañana", "is_correct": false}
        ],
        "explanation": "'Me despierto' (I wake up) is reflexive. 'Temprano' means early, and 'por la mañana' means in the morning."
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'spanish_despertarse',
    'spanish_levantarse',
    'spanish_ducharse',
    'spanish_banarse',
    'spanish_cepillarse_dientes',
    'spanish_peinarse',
    'spanish_vestirse',
    'spanish_desayunar',
    'spanish_trabajar',
    'spanish_estudiar',
    'spanish_comer',
    'spanish_almorzar',
    'spanish_cenar',
    'spanish_beber',
    'spanish_cocinar',
    'spanish_limpiar',
    'spanish_hacer_tarea',
    'spanish_leer',
    'spanish_ver_tv',
    'spanish_escuchar_musica',
    'spanish_salir',
    'spanish_regresar',
    'spanish_llegar',
    'spanish_descansar',
    'spanish_relajarse',
    'spanish_dormir',
    'spanish_acostarse',
    'spanish_manana_early',
    'spanish_tarde',
    'spanish_noche',
    'spanish_temprano',
    'spanish_tarde_late',
    'spanish_primero',
    'spanish_despues',
    'spanish_luego',
    'spanish_finalmente',
    'spanish_antes_de',
    'spanish_que_haces',
    'spanish_a_que_hora',
    'spanish_cuando'
  ]::TEXT[],
  ARRAY['daily_routines', 'reflexive_verbs', 'time_expressions', 'sequence_words', 'present_tense']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  level = EXCLUDED.level,
  updated_at = NOW();

