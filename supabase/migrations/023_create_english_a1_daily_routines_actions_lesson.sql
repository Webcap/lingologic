-- A1 English Lesson: Daily Routines and Actions
-- This lesson teaches daily routine vocabulary and how to describe daily activities in English

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Morning Routine
('english_wake_up', 'english', 'wake up', 'wake up', 'routines'),
('english_get_up', 'english', 'get up', 'get up', 'routines'),
('english_shower', 'english', 'shower', 'shower', 'routines'),
('english_take_a_shower', 'english', 'take a shower', 'take a shower', 'routines'),
('english_brush_teeth', 'english', 'brush teeth', 'brush teeth', 'routines'),
('english_comb_hair', 'english', 'comb hair', 'comb hair', 'routines'),
('english_get_dressed', 'english', 'get dressed', 'get dressed', 'routines'),
('english_have_breakfast', 'english', 'have breakfast', 'have breakfast', 'routines'),
('english_eat_breakfast', 'english', 'eat breakfast', 'eat breakfast', 'routines'),
-- Daily Activities
('english_work', 'english', 'work', 'work', 'activities'),
('english_study', 'english', 'study', 'study', 'activities'),
('english_eat', 'english', 'eat', 'eat', 'activities'),
('english_have_lunch', 'english', 'have lunch', 'have lunch', 'activities'),
('english_eat_lunch', 'english', 'eat lunch', 'eat lunch', 'activities'),
('english_have_dinner', 'english', 'have dinner', 'have dinner', 'activities'),
('english_eat_dinner', 'english', 'eat dinner', 'eat dinner', 'activities'),
('english_drink', 'english', 'drink', 'drink', 'activities'),
('english_cook', 'english', 'cook', 'cook', 'activities'),
('english_clean', 'english', 'clean', 'clean', 'activities'),
('english_do_homework', 'english', 'do homework', 'do homework', 'activities'),
('english_read', 'english', 'read', 'read', 'activities'),
('english_watch_tv', 'english', 'watch TV', 'watch TV', 'activities'),
('english_listen_to_music', 'english', 'listen to music', 'listen to music', 'activities'),
('english_go_out', 'english', 'go out', 'go out', 'activities'),
('english_come_back', 'english', 'come back', 'come back', 'activities'),
('english_arrive', 'english', 'arrive', 'arrive', 'activities'),
-- Evening/Night Routine
('english_rest', 'english', 'rest', 'rest', 'routines'),
('english_relax', 'english', 'relax', 'relax', 'routines'),
('english_sleep', 'english', 'sleep', 'sleep', 'routines'),
('english_go_to_bed', 'english', 'go to bed', 'go to bed', 'routines'),
-- Time Expressions
('english_in_the_morning', 'english', 'in the morning', 'in the morning', 'time'),
('english_in_the_afternoon', 'english', 'in the afternoon', 'in the afternoon', 'time'),
('english_in_the_evening', 'english', 'in the evening', 'in the evening', 'time'),
('english_at_night', 'english', 'at night', 'at night', 'time'),
('english_early', 'english', 'early', 'early', 'time'),
('english_late', 'english', 'late', 'late', 'time'),
-- Sequence Words
('english_first', 'english', 'first', 'first', 'sequence'),
('english_then', 'english', 'then', 'then', 'sequence'),
('english_after', 'english', 'after', 'after', 'sequence'),
('english_after_that', 'english', 'after that', 'after that', 'sequence'),
('english_finally', 'english', 'finally', 'finally', 'sequence'),
('english_before', 'english', 'before', 'before', 'sequence'),
-- Questions
('english_what_do_you_do', 'english', 'what do you do?', 'what do you do?', 'questions'),
('english_what_time', 'english', 'what time...?', 'what time...?', 'questions'),
('english_when', 'english', 'when...?', 'when...?', 'questions')
ON CONFLICT (id) DO NOTHING;

-- Create the A1 English lesson with comprehensive content
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
  'english_a1_daily_routines_actions',
  'Daily Routines and Actions',
  'Learn to describe your daily routines and activities in English. Essential vocabulary for talking about what you do every day!',
  'english',
  'vocabulary',
  'A1',
  7,
  35,
  $lesson_json${
    "translations": {
      "es": {
        "title": "Rutinas Diarias y Acciones",
        "description": "Aprende a describir tus rutinas diarias y actividades en inglés. ¡Vocabulario esencial para hablar sobre lo que haces todos los días!"
      }
    },
    "sections": [
      {
        "type": "text",
        "id": "morning_routine_intro",
        "title": "Morning Routine",
        "content": "Let's learn vocabulary for your morning routine! These are the activities you do when you start your day.",
        "examples": [
          "wake up (open your eyes after sleeping)",
          "get up (leave your bed)",
          "take a shower (wash yourself)",
          "brush teeth (clean your teeth)",
          "have breakfast (eat morning meal)"
        ],
        "translations": {
          "es": {
            "title": "Rutina Matutina",
            "content": "¡Aprendamos vocabulario para tu rutina matutina! Estas son las actividades que haces cuando comienzas tu día.",
            "examples": [
              "wake up (abrir los ojos después de dormir)",
              "get up (salir de la cama)",
              "take a shower (lavarse)",
              "brush teeth (cepillarse los dientes)",
              "have breakfast (comer el desayuno)"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "morning_routine_example_1",
        "english_example": "In the morning, I wake up at seven. I get up, take a shower, and have breakfast.",
        "explanation": "Notice the sequence: 'wake up' (open eyes), then 'get up' (leave bed). We say 'take a shower' (not 'shower' as a verb).",
        "translations": {
          "es": {
            "explanation": "Nota la secuencia: 'wake up' (abrir los ojos), luego 'get up' (salir de la cama). Decimos 'take a shower' (no 'shower' como verbo)."
          }
        }
      },
      {
        "type": "example",
        "id": "morning_routine_example_2",
        "english_example": "First I brush my teeth, then I comb my hair, and finally I get dressed.",
        "explanation": "Use 'first', 'then', and 'finally' to show the order of actions. 'Brush my teeth' and 'comb my hair' use possessive pronouns (my).",
        "translations": {
          "es": {
            "explanation": "Usa 'first', 'then' y 'finally' para mostrar el orden de las acciones. 'Brush my teeth' y 'comb my hair' usan pronombres posesivos (my)."
          }
        }
      },
      {
        "type": "matching",
        "id": "morning_routine_matching_1",
        "instruction": "Match the morning routine actions with their meanings",
        "pairs": [
          {"word": "wake up", "translation": "open eyes after sleeping"},
          {"word": "get up", "translation": "leave the bed"},
          {"word": "take a shower", "translation": "wash yourself with water"},
          {"word": "brush teeth", "translation": "clean your teeth"},
          {"word": "get dressed", "translation": "put on clothes"},
          {"word": "have breakfast", "translation": "eat the morning meal"}
        ],
        "distractors": ["eat", "sleep"],
        "explanation": "Great job! 'Wake up' and 'get up' are different: you wake up first (open your eyes), then you get up (leave the bed).",
        "translations": {
          "es": {
            "instruction": "Empareja las acciones de la rutina matutina con sus significados",
            "explanation": "¡Buen trabajo! 'Wake up' y 'get up' son diferentes: primero te despiertas (abres los ojos), luego te levantas (sales de la cama)."
          }
        }
      },
      {
        "type": "exercise",
        "id": "morning_routine_exercise_1",
        "question": "What's the difference between 'wake up' and 'get up'?",
        "options": [
          {"text": "Wake up means open your eyes, get up means leave the bed", "is_correct": true},
          {"text": "They mean the same thing", "is_correct": false},
          {"text": "Wake up means leave the bed, get up means open your eyes", "is_correct": false},
          {"text": "Wake up is for morning, get up is for evening", "is_correct": false}
        ],
        "explanation": "'Wake up' is when you open your eyes and become conscious. 'Get up' is the physical action of leaving your bed.",
        "translations": {
          "es": {
            "question": "¿Cuál es la diferencia entre 'wake up' y 'get up'?",
            "options": [
              {"text": "Wake up means open your eyes, get up means leave the bed", "is_correct": true},
              {"text": "They mean the same thing", "is_correct": false},
              {"text": "Wake up means leave the bed, get up means open your eyes", "is_correct": false},
              {"text": "Wake up is for morning, get up is for evening", "is_correct": false}
            ],
            "explanation": "'Wake up' es cuando abres los ojos y te vuelves consciente. 'Get up' es la acción física de salir de tu cama."
          }
        }
      },
      {
        "type": "text",
        "id": "daily_activities_intro",
        "title": "Daily Activities",
        "content": "Now let's learn verbs for common daily activities like working, studying, eating, and other things you do during the day!",
        "examples": [
          "work (do your job)",
          "study (learn at school or home)",
          "eat (consume food)",
          "read (look at and understand words)",
          "clean (make something tidy)"
        ],
        "translations": {
          "es": {
            "title": "Actividades Diarias",
            "content": "¡Ahora aprendamos verbos para actividades diarias comunes como trabajar, estudiar, comer y otras cosas que haces durante el día!",
            "examples": [
              "work (hacer tu trabajo)",
              "study (aprender en la escuela o en casa)",
              "eat (consumir comida)",
              "read (mirar y entender palabras)",
              "clean (hacer algo ordenado)"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "daily_activities_example_1",
        "english_example": "In the afternoon I work and study. After that I have lunch with my friends.",
        "explanation": "'In the afternoon' means the time between noon and evening. Use 'and' to connect activities, 'after that' to show sequence.",
        "translations": {
          "es": {
            "explanation": "'In the afternoon' significa el tiempo entre el mediodía y la noche. Usa 'and' para conectar actividades, 'after that' para mostrar secuencia."
          }
        }
      },
      {
        "type": "example",
        "id": "daily_activities_example_2",
        "english_example": "I like to read and listen to music at night. After that I have dinner and relax.",
        "explanation": "'At night' means during the evening or nighttime. 'Have dinner' means to eat the evening meal.",
        "translations": {
          "es": {
            "explanation": "'At night' significa durante la noche o la noche. 'Have dinner' significa comer la comida de la noche."
          }
        }
      },
      {
        "type": "matching",
        "id": "daily_activities_matching_1",
        "instruction": "Match the daily activity verbs with their meanings",
        "pairs": [
          {"word": "work", "translation": "do your job"},
          {"word": "study", "translation": "learn at school or home"},
          {"word": "eat", "translation": "consume food"},
          {"word": "drink", "translation": "consume liquids"},
          {"word": "read", "translation": "look at and understand words"},
          {"word": "cook", "translation": "prepare food"}
        ],
        "distractors": ["sleep", "wake up"],
        "explanation": "Excellent! These are common daily activity verbs. Notice 'work' and 'study' don't need an object - you just 'work' or 'study'.",
        "translations": {
          "es": {
            "instruction": "Empareja los verbos de actividades diarias con sus significados",
            "explanation": "¡Excelente! Estos son verbos comunes de actividades diarias. Nota que 'work' y 'study' no necesitan un objeto - simplemente 'work' o 'study'."
          }
        }
      },
      {
        "type": "exercise",
        "id": "daily_activities_exercise_1",
        "question": "Complete: 'In the afternoon I ___ and then I ___'",
        "options": [
          {"text": "work, study", "is_correct": true},
          {"text": "working, studying", "is_correct": false},
          {"text": "worked, studied", "is_correct": false},
          {"text": "to work, to study", "is_correct": false}
        ],
        "explanation": "Use the base form of verbs: 'work' and 'study'. 'Working' and 'studying' are continuous forms, used differently.",
        "translations": {
          "es": {
            "question": "Completa: 'In the afternoon I ___ and then I ___'",
            "options": [
              {"text": "work, study", "is_correct": true},
              {"text": "working, studying", "is_correct": false},
              {"text": "worked, studied", "is_correct": false},
              {"text": "to work, to study", "is_correct": false}
            ],
            "explanation": "Usa la forma base de los verbos: 'work' y 'study'. 'Working' y 'studying' son formas continuas, usadas de manera diferente."
          }
        }
      },
      {
        "type": "text",
        "id": "evening_routine_intro",
        "title": "Evening and Night Routine",
        "content": "Let's learn vocabulary for your evening and night routine. These verbs describe how you end your day!",
        "examples": [
          "rest (relax and recover energy)",
          "relax (calm down, be peaceful)",
          "sleep (rest with eyes closed)",
          "go to bed (get into bed to sleep)"
        ],
        "translations": {
          "es": {
            "title": "Rutina Nocturna",
            "content": "¡Aprendamos vocabulario para tu rutina nocturna. ¡Estos verbos describen cómo terminas tu día!",
            "examples": [
              "rest (relajarse y recuperar energía)",
              "relax (calmarse, estar tranquilo)",
              "sleep (descansar con los ojos cerrados)",
              "go to bed (acostarse para dormir)"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "evening_routine_example_1",
        "english_example": "At night, after dinner, I relax. Finally I go to bed at eleven.",
        "explanation": "'After dinner' means following the evening meal. 'Go to bed' means to get into bed, while 'sleep' is the action of sleeping.",
        "translations": {
          "es": {
            "explanation": "'After dinner' significa después de la comida de la noche. 'Go to bed' significa acostarse en la cama, mientras que 'sleep' es la acción de dormir."
          }
        }
      },
      {
        "type": "matching",
        "id": "evening_routine_matching_1",
        "instruction": "Match the evening/night activities with their meanings",
        "pairs": [
          {"word": "rest", "translation": "relax and recover energy"},
          {"word": "relax", "translation": "calm down, be peaceful"},
          {"word": "sleep", "translation": "rest with eyes closed"},
          {"word": "go to bed", "translation": "get into bed to sleep"}
        ],
        "explanation": "Perfect! 'Go to bed' means the action of getting into bed, while 'sleep' is the state of being asleep.",
        "translations": {
          "es": {
            "instruction": "Empareja las actividades nocturnas con sus significados",
            "explanation": "¡Perfecto! 'Go to bed' significa la acción de acostarse en la cama, mientras que 'sleep' es el estado de estar dormido."
          }
        }
      },
      {
        "type": "exercise",
        "id": "evening_routine_exercise_1",
        "question": "How do you say 'to get into bed' in English?",
        "options": [
          {"text": "go to bed", "is_correct": true},
          {"text": "sleep", "is_correct": false},
          {"text": "rest", "is_correct": false},
          {"text": "get up", "is_correct": false}
        ],
        "explanation": "'Go to bed' means to get into bed. 'Sleep' is the action of being asleep, not getting into bed.",
        "translations": {
          "es": {
            "question": "¿Cómo se dice 'acostarse en la cama' en inglés?",
            "options": [
              {"text": "go to bed", "is_correct": true},
              {"text": "sleep", "is_correct": false},
              {"text": "rest", "is_correct": false},
              {"text": "get up", "is_correct": false}
            ],
            "explanation": "'Go to bed' significa acostarse en la cama. 'Sleep' es la acción de estar dormido, no acostarse en la cama."
          }
        }
      },
      {
        "type": "text",
        "id": "time_expressions_intro",
        "title": "Time Expressions",
        "content": "Let's learn how to talk about when you do things. Time expressions help you organize your daily routine!",
        "examples": [
          "in the morning (early part of the day)",
          "in the afternoon (middle part of the day)",
          "in the evening (late part of the day)",
          "at night (during nighttime)",
          "early (before the usual time)",
          "late (after the usual time)"
        ],
        "translations": {
          "es": {
            "title": "Expresiones de Tiempo",
            "content": "¡Aprendamos a hablar sobre cuándo haces las cosas. Las expresiones de tiempo te ayudan a organizar tu rutina diaria!",
            "examples": [
              "in the morning (parte temprana del día)",
              "in the afternoon (parte media del día)",
              "in the evening (parte tardía del día)",
              "at night (durante la noche)",
              "early (antes de la hora usual)",
              "late (después de la hora usual)"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "time_expressions_example_1",
        "english_example": "I wake up early in the morning. I work in the afternoon and rest at night.",
        "explanation": "Use 'in the morning/afternoon/evening' and 'at night'. Notice 'at night' (not 'in the night').",
        "translations": {
          "es": {
            "explanation": "Usa 'in the morning/afternoon/evening' y 'at night'. Nota 'at night' (no 'in the night')."
          }
        }
      },
      {
        "type": "matching",
        "id": "time_expressions_matching_1",
        "instruction": "Match the time expressions with their meanings",
        "pairs": [
          {"word": "in the morning", "translation": "early part of the day"},
          {"word": "in the afternoon", "translation": "middle part of the day"},
          {"word": "in the evening", "translation": "late part of the day"},
          {"word": "at night", "translation": "during nighttime"},
          {"word": "early", "translation": "before the usual time"}
        ],
        "explanation": "Great! Remember: 'in the morning/afternoon/evening' but 'at night'. 'Early' and 'late' describe timing.",
        "translations": {
          "es": {
            "instruction": "Empareja las expresiones de tiempo con sus significados",
            "explanation": "¡Genial! Recuerda: 'in the morning/afternoon/evening' pero 'at night'. 'Early' y 'late' describen el tiempo."
          }
        }
      },
      {
        "type": "text",
        "id": "sequence_words_intro",
        "title": "Sequence Words",
        "content": "Let's learn words to describe the order of your daily activities. These help you tell a story about your day!",
        "examples": [
          "first (before all others)",
          "then (after that, next)",
          "after (following in time)",
          "finally (at the end)",
          "before (earlier than)"
        ],
        "translations": {
          "es": {
            "title": "Palabras de Secuencia",
            "content": "¡Aprendamos palabras para describir el orden de tus actividades diarias. ¡Estas te ayudan a contar una historia sobre tu día!",
            "examples": [
              "first (antes que todos los demás)",
              "then (después de eso, siguiente)",
              "after (siguiendo en el tiempo)",
              "finally (al final)",
              "before (antes que)"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "sequence_words_example_1",
        "english_example": "First I get up, then I take a shower. After that I have breakfast and finally I leave home.",
        "explanation": "Sequence words organize your routine: 'first' (start), 'then' or 'after that' (next), 'finally' (end).",
        "translations": {
          "es": {
            "explanation": "Las palabras de secuencia organizan tu rutina: 'first' (comienzo), 'then' o 'after that' (siguiente), 'finally' (final)."
          }
        }
      },
      {
        "type": "exercise",
        "id": "sequence_words_exercise_1",
        "question": "Which word means 'before all others'?",
        "options": [
          {"text": "first", "is_correct": true},
          {"text": "then", "is_correct": false},
          {"text": "after", "is_correct": false},
          {"text": "finally", "is_correct": false}
        ],
        "explanation": "'First' means before all others. Use it to start describing a sequence: 'First I...'",
        "translations": {
          "es": {
            "question": "¿Qué palabra significa 'antes que todos los demás'?",
            "options": [
              {"text": "first", "is_correct": true},
              {"text": "then", "is_correct": false},
              {"text": "after", "is_correct": false},
              {"text": "finally", "is_correct": false}
            ],
            "explanation": "'First' significa antes que todos los demás. Úsalo para comenzar a describir una secuencia: 'First I...'"
          }
        }
      },
      {
        "type": "text",
        "id": "asking_questions_intro",
        "title": "Asking About Daily Routines",
        "content": "Let's learn how to ask questions about daily routines and activities. These are very useful in conversations!",
        "examples": [
          "What do you do? (asking about activities)",
          "What time do you get up? (asking about specific time)",
          "When do you eat? (asking about timing)"
        ],
        "translations": {
          "es": {
            "title": "Preguntar sobre Rutinas Diarias",
            "content": "¡Aprendamos cómo hacer preguntas sobre rutinas diarias y actividades. ¡Estas son muy útiles en las conversaciones!",
            "examples": [
              "What do you do? (preguntando sobre actividades)",
              "What time do you get up? (preguntando sobre hora específica)",
              "When do you eat? (preguntando sobre el tiempo)"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "asking_questions_example_1",
        "english_example": "A: What time do you wake up? / B: I wake up at six thirty.",
        "explanation": "'What time...?' asks for a specific time. Answer with 'at [time]' or 'at [time] [AM/PM]'.",
        "translations": {
          "es": {
            "explanation": "'What time...?' pregunta por una hora específica. Responde con 'at [hora]' o 'at [hora] [AM/PM]'."
          }
        }
      },
      {
        "type": "exercise",
        "id": "asking_questions_exercise_1",
        "question": "How do you ask 'At what time do you get up?' in English?",
        "options": [
          {"text": "What time do you get up?", "is_correct": true},
          {"text": "What time you get up?", "is_correct": false},
          {"text": "What do you get up?", "is_correct": false},
          {"text": "When time do you get up?", "is_correct": false}
        ],
        "explanation": "'What time do you get up?' is correct. We use 'do' as a helping verb. 'When' is used differently.",
        "translations": {
          "es": {
            "question": "¿Cómo preguntas '¿A qué hora te levantas?' en inglés?",
            "options": [
              {"text": "What time do you get up?", "is_correct": true},
              {"text": "What time you get up?", "is_correct": false},
              {"text": "What do you get up?", "is_correct": false},
              {"text": "When time do you get up?", "is_correct": false}
            ],
            "explanation": "'What time do you get up?' es correcto. Usamos 'do' como verbo auxiliar. 'When' se usa de manera diferente."
          }
        }
      },
      {
        "type": "text",
        "id": "putting_it_together",
        "title": "Putting It All Together",
        "content": "Now you can describe your complete daily routine! Practice using all the vocabulary you've learned about routines, activities, time, and sequence.",
        "examples": [
          "Full routine: 'In the morning I get up early. First I take a shower, then I have breakfast, and finally I go to work.'",
          "Asking questions: 'What do you do in the afternoon?'",
          "Talking about time: 'I have lunch at one and dinner at eight.'"
        ],
        "translations": {
          "es": {
            "title": "Poniendo Todo Junto",
            "content": "¡Ahora puedes describir tu rutina diaria completa! Practica usando todo el vocabulario que has aprendido sobre rutinas, actividades, tiempo y secuencia.",
            "examples": [
              "Rutina completa: 'In the morning I get up early. First I take a shower, then I have breakfast, and finally I go to work.'",
              "Hacer preguntas: 'What do you do in the afternoon?'",
              "Hablar sobre el tiempo: 'I have lunch at one and dinner at eight.'"
            ]
          }
        }
      },
      {
        "type": "matching",
        "id": "comprehensive_matching_1",
        "instruction": "Match the daily routine words with their meanings",
        "pairs": [
          {"word": "wake up", "translation": "open eyes after sleeping"},
          {"word": "work", "translation": "do your job"},
          {"word": "have lunch", "translation": "eat the midday meal"},
          {"word": "in the morning", "translation": "early part of the day"},
          {"word": "first", "translation": "before all others"},
          {"word": "go to bed", "translation": "get into bed"},
          {"word": "sleep", "translation": "rest with eyes closed"},
          {"word": "early", "translation": "before the usual time"}
        ],
        "distractors": ["late", "afternoon"],
        "explanation": "Fantastic! You've mastered daily routines and actions vocabulary. Keep practicing to remember all these verbs and time expressions!",
        "translations": {
          "es": {
            "instruction": "Empareja las palabras de rutina diaria con sus significados",
            "explanation": "¡Fantástico! Has dominado el vocabulario de rutinas diarias y acciones. ¡Sigue practicando para recordar todos estos verbos y expresiones de tiempo!"
          }
        }
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "Complete: '___ I get up, ___ I have breakfast, and ___ I go to work'",
        "options": [
          {"text": "First, then, finally", "is_correct": true},
          {"text": "Then, first, after", "is_correct": false},
          {"text": "After, finally, first", "is_correct": false},
          {"text": "Finally, first, then", "is_correct": false}
        ],
        "explanation": "The correct sequence is: 'First' (beginning), 'then' (next), 'finally' (end). This shows the order of actions.",
        "translations": {
          "es": {
            "question": "Completa: '___ I get up, ___ I have breakfast, and ___ I go to work'",
            "options": [
              {"text": "First, then, finally", "is_correct": true},
              {"text": "Then, first, after", "is_correct": false},
              {"text": "After, finally, first", "is_correct": false},
              {"text": "Finally, first, then", "is_correct": false}
            ],
            "explanation": "La secuencia correcta es: 'First' (comienzo), 'then' (siguiente), 'finally' (final). Esto muestra el orden de las acciones."
          }
        }
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "How would you say 'I wake up early in the morning'?",
        "options": [
          {"text": "I wake up early in the morning", "is_correct": true},
          {"text": "I get up early in the morning", "is_correct": false},
          {"text": "I wake up late in the morning", "is_correct": false},
          {"text": "I wake up early at the morning", "is_correct": false}
        ],
        "explanation": "'I wake up early in the morning' is correct. Use 'in the morning' (not 'at the morning'), and 'wake up' not 'get up' for opening your eyes.",
        "translations": {
          "es": {
            "question": "¿Cómo dirías 'Me despierto temprano en la mañana'?",
            "options": [
              {"text": "I wake up early in the morning", "is_correct": true},
              {"text": "I get up early in the morning", "is_correct": false},
              {"text": "I wake up late in the morning", "is_correct": false},
              {"text": "I wake up early at the morning", "is_correct": false}
            ],
            "explanation": "'I wake up early in the morning' es correcto. Usa 'in the morning' (no 'at the morning'), y 'wake up' no 'get up' para abrir los ojos."
          }
        }
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'english_wake_up',
    'english_get_up',
    'english_shower',
    'english_take_a_shower',
    'english_brush_teeth',
    'english_comb_hair',
    'english_get_dressed',
    'english_have_breakfast',
    'english_eat_breakfast',
    'english_work',
    'english_study',
    'english_eat',
    'english_have_lunch',
    'english_eat_lunch',
    'english_have_dinner',
    'english_eat_dinner',
    'english_drink',
    'english_cook',
    'english_clean',
    'english_do_homework',
    'english_read',
    'english_watch_tv',
    'english_listen_to_music',
    'english_go_out',
    'english_come_back',
    'english_arrive',
    'english_rest',
    'english_relax',
    'english_sleep',
    'english_go_to_bed',
    'english_in_the_morning',
    'english_in_the_afternoon',
    'english_in_the_evening',
    'english_at_night',
    'english_early',
    'english_late',
    'english_first',
    'english_then',
    'english_after',
    'english_after_that',
    'english_finally',
    'english_before',
    'english_what_do_you_do',
    'english_what_time',
    'english_when'
  ]::TEXT[],
  ARRAY['daily_routines', 'action_verbs', 'time_expressions', 'sequence_words', 'present_tense']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  level = EXCLUDED.level,
  updated_at = NOW();

