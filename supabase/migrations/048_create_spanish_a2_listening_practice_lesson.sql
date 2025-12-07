-- A2 Spanish Lesson: Listening and Speaking Practice
-- This lesson focuses on fill-in-the-blank exercises and pronunciation practice for Spanish A2 level

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Common Phrases
('spanish_tengo_que', 'spanish', 'tengo que', 'I have to', 'phrases'),
('spanish_necesito_ir', 'spanish', 'necesito ir', 'I need to go', 'phrases'),
('spanish_me_gusta', 'spanish', 'me gusta', 'I like', 'phrases'),
('spanish_no_me_gusta', 'spanish', 'no me gusta', 'I don''t like', 'phrases'),
('spanish_quiero', 'spanish', 'quiero', 'I want', 'phrases'),
('spanish_prefiero', 'spanish', 'prefiero', 'I prefer', 'phrases'),
-- Time and Frequency
('spanish_siempre', 'spanish', 'siempre', 'always', 'time'),
('spanish_nunca', 'spanish', 'nunca', 'never', 'time'),
('spanish_a_veces', 'spanish', 'a veces', 'sometimes', 'time'),
('spanish_todos_los_dias', 'spanish', 'todos los días', 'every day', 'time'),
('spanish_una_vez', 'spanish', 'una vez', 'once', 'time'),
('spanish_dos_veces', 'spanish', 'dos veces', 'twice', 'time'),
-- Common Verbs
('spanish_hacer', 'spanish', 'hacer', 'to do/to make', 'verbs'),
('spanish_decir', 'spanish', 'decir', 'to say/to tell', 'verbs'),
('spanish_venir', 'spanish', 'venir', 'to come', 'verbs'),
('spanish_ir', 'spanish', 'ir', 'to go', 'verbs'),
('spanish_salir', 'spanish', 'salir', 'to go out/to leave', 'verbs'),
('spanish_llegar', 'spanish', 'llegar', 'to arrive', 'verbs'),
-- Places and Activities
('spanish_trabajo', 'spanish', 'trabajo', 'work', 'places'),
('spanish_escuela', 'spanish', 'escuela', 'school', 'places'),
('spanish_casa', 'spanish', 'casa', 'house/home', 'places'),
('spanish_parque', 'spanish', 'parque', 'park', 'places'),
('spanish_tienda', 'spanish', 'tienda', 'store/shop', 'places'),
('spanish_restaurante', 'spanish', 'restaurante', 'restaurant', 'places'),
-- Daily Activities
('spanish_cocinar', 'spanish', 'cocinar', 'to cook', 'activities'),
('spanish_leer', 'spanish', 'leer', 'to read', 'activities'),
('spanish_estudiar', 'spanish', 'estudiar', 'to study', 'activities'),
('spanish_jugar', 'spanish', 'jugar', 'to play', 'activities'),
('spanish_ver', 'spanish', 'ver', 'to see/to watch', 'activities'),
('spanish_escuchar', 'spanish', 'escuchar', 'to listen', 'activities'),
-- Descriptive Words
('spanish_interesante', 'spanish', 'interesante', 'interesting', 'descriptive'),
('spanish_dificil', 'spanish', 'difícil', 'difficult', 'descriptive'),
('spanish_facil', 'spanish', 'fácil', 'easy', 'descriptive'),
('spanish_importante', 'spanish', 'importante', 'important', 'descriptive'),
('spanish_divertido', 'spanish', 'divertido', 'fun', 'descriptive'),
('spanish_aburrido', 'spanish', 'aburrido', 'boring', 'descriptive')
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
  'spanish_a2_listening_practice',
  'Listening and Speaking Practice',
  'Practice your listening and speaking skills with fill-in-the-blank exercises and pronunciation practice! Master common phrases, verb conjugations, and everyday vocabulary through interactive exercises.',
  'spanish',
  'practice',
  'A2',
  4,
  50,
  $lesson_json${
    "sections": [
      {
        "type": "text",
        "id": "practice_intro",
        "title": "Listening and Speaking Practice",
        "content": "Welcome! This lesson focuses on active practice through fill-in-the-blank exercises and pronunciation. You'll practice common phrases, verb conjugations, and everyday vocabulary to improve your listening and speaking skills.",
        "examples": [
          "Fill in the blank: 'Yo ___ español todos los días' (I study Spanish every day)",
          "Pronunciation practice: 'interesante', 'difícil', 'divertido'",
          "Complete sentences with the correct verb forms"
        ]
      },
      {
        "type": "pronunciation",
        "id": "common_phrases_pronunciation_1",
        "instruction": "Practice pronouncing these common phrases. Listen carefully and repeat each one.",
        "language_code": "es-ES",
        "words": [
          {
            "word": "tengo que",
            "phonetic": "TEN-go ke",
            "translation": "I have to"
          },
          {
            "word": "necesito ir",
            "phonetic": "ne-se-SEE-to eer",
            "translation": "I need to go"
          },
          {
            "word": "me gusta",
            "phonetic": "me GOOS-ta",
            "translation": "I like"
          },
          {
            "word": "no me gusta",
            "phonetic": "no me GOOS-ta",
            "translation": "I don't like"
          },
          {
            "word": "prefiero",
            "phonetic": "pre-FYEH-ro",
            "translation": "I prefer"
          }
        ],
        "explanation": "Great pronunciation practice! Notice how 'gusta' has the stress on the first syllable. 'Tengo que' is a very common phrase - practice it until it feels natural!"
      },
      {
        "type": "exercise",
        "id": "fill_blank_1",
        "question": "Complete the sentence: 'Yo ___ español todos los días.'",
        "options": [
          {"text": "estudio", "is_correct": true},
          {"text": "estudias", "is_correct": false},
          {"text": "estudiamos", "is_correct": false},
          {"text": "estudian", "is_correct": false}
        ],
        "explanation": "Correct! 'Estudio' is the 'yo' (I) form of 'estudiar'. Remember: yo estudio, tú estudias, él/ella estudia."
      },
      {
        "type": "exercise",
        "id": "fill_blank_2",
        "question": "Complete the sentence: 'María ___ al parque los fines de semana.'",
        "options": [
          {"text": "va", "is_correct": true},
          {"text": "voy", "is_correct": false},
          {"text": "vas", "is_correct": false},
          {"text": "vamos", "is_correct": false}
        ],
        "explanation": "Perfect! 'Va' is the third person singular form (él/ella). 'María va' means 'Maria goes'. The verb 'ir' (to go) is irregular: voy, vas, va, vamos, van."
      },
      {
        "type": "pronunciation",
        "id": "verb_pronunciation_1",
        "instruction": "Practice pronouncing these common verbs. Pay attention to the vowel sounds.",
        "language_code": "es-ES",
        "words": [
          {
            "word": "hacer",
            "phonetic": "a-SER",
            "translation": "to do/to make"
          },
          {
            "word": "decir",
            "phonetic": "de-SEER",
            "translation": "to say/to tell"
          },
          {
            "word": "venir",
            "phonetic": "be-NEER",
            "translation": "to come"
          },
          {
            "word": "salir",
            "phonetic": "sa-LEER",
            "translation": "to go out/to leave"
          },
          {
            "word": "llegar",
            "phonetic": "ye-GAR",
            "translation": "to arrive"
          }
        ],
        "explanation": "Excellent! Notice how 'hacer' starts with a silent 'h'. 'Llegar' has a double 'll' which sounds like 'y' in Spanish. Practice these until you can say them naturally!"
      },
      {
        "type": "exercise",
        "id": "fill_blank_3",
        "question": "Complete the sentence: 'Yo ___ que estudiar más para el examen.'",
        "options": [
          {"text": "tengo", "is_correct": true},
          {"text": "tienes", "is_correct": false},
          {"text": "tenemos", "is_correct": false},
          {"text": "tienen", "is_correct": false}
        ],
        "explanation": "Correct! 'Tengo que' means 'I have to'. It's a very common expression. 'Tengo que estudiar' = 'I have to study'."
      },
      {
        "type": "exercise",
        "id": "fill_blank_4",
        "question": "Complete the sentence: 'A mí ___ leer libros interesantes.'",
        "options": [
          {"text": "me gusta", "is_correct": true},
          {"text": "me gustan", "is_correct": false},
          {"text": "te gusta", "is_correct": false},
          {"text": "le gusta", "is_correct": false}
        ],
        "explanation": "Perfect! 'Me gusta' is used with singular nouns (like 'leer' which is an infinitive). 'Me gustan' would be used with plural nouns like 'libros'."
      },
      {
        "type": "pronunciation",
        "id": "time_expressions_pronunciation",
        "instruction": "Practice pronouncing time expressions. Notice the rhythm and stress patterns.",
        "language_code": "es-ES",
        "words": [
          {
            "word": "siempre",
            "phonetic": "SYEM-pre",
            "translation": "always"
          },
          {
            "word": "nunca",
            "phonetic": "NOON-ka",
            "translation": "never"
          },
          {
            "word": "a veces",
            "phonetic": "a BE-ces",
            "translation": "sometimes"
          },
          {
            "word": "todos los días",
            "phonetic": "TO-dos los DEE-as",
            "translation": "every day"
          },
          {
            "word": "una vez",
            "phonetic": "OO-na bes",
            "translation": "once"
          },
          {
            "word": "dos veces",
            "phonetic": "dos BE-ces",
            "translation": "twice"
          }
        ],
        "explanation": "Great job! Notice how 'a veces' sounds like 'a bes-es'. 'Todos los días' emphasizes 'días'. Practice these until the rhythm feels natural!"
      },
      {
        "type": "exercise",
        "id": "fill_blank_5",
        "question": "Complete the sentence: 'Juan ___ va al cine, solo dos veces al mes.'",
        "options": [
          {"text": "no siempre", "is_correct": true},
          {"text": "siempre", "is_correct": false},
          {"text": "nunca", "is_correct": false},
          {"text": "a veces", "is_correct": false}
        ],
        "explanation": "Correct! 'No siempre' means 'not always' or 'not often'. The context (solo dos veces al mes = only twice a month) tells us he doesn't go often."
      },
      {
        "type": "exercise",
        "id": "fill_blank_6",
        "question": "Complete the sentence: 'Yo ___ cocinar, pero es difícil.'",
        "options": [
          {"text": "quiero aprender a", "is_correct": true},
          {"text": "quiero aprender", "is_correct": false},
          {"text": "quiero a aprender", "is_correct": false},
          {"text": "aprender quiero", "is_correct": false}
        ],
        "explanation": "Perfect! 'Quiero aprender a cocinar' means 'I want to learn to cook'. In Spanish, use 'aprender a' before another verb."
      },
      {
        "type": "pronunciation",
        "id": "places_pronunciation",
        "instruction": "Practice pronouncing these common places. Focus on clear pronunciation of each syllable.",
        "language_code": "es-ES",
        "words": [
          {
            "word": "trabajo",
            "phonetic": "tra-BA-ho",
            "translation": "work"
          },
          {
            "word": "escuela",
            "phonetic": "es-KWE-la",
            "translation": "school"
          },
          {
            "word": "casa",
            "phonetic": "KA-sa",
            "translation": "house/home"
          },
          {
            "word": "parque",
            "phonetic": "PAR-ke",
            "translation": "park"
          },
          {
            "word": "tienda",
            "phonetic": "TYEN-da",
            "translation": "store/shop"
          },
          {
            "word": "restaurante",
            "phonetic": "res-tau-RAN-te",
            "translation": "restaurant"
          }
        ],
        "explanation": "Excellent pronunciation! Notice how 'restaurante' has the stress on 'ran'. 'Tienda' has a 'ty' sound at the beginning. Keep practicing!"
      },
      {
        "type": "exercise",
        "id": "fill_blank_7",
        "question": "Complete the sentence: 'Los estudiantes ___ a la escuela todos los días.'",
        "options": [
          {"text": "van", "is_correct": true},
          {"text": "va", "is_correct": false},
          {"text": "vamos", "is_correct": false},
          {"text": "voy", "is_correct": false}
        ],
        "explanation": "Correct! 'Van' is the third person plural form (ellos/ellas). 'Los estudiantes van' means 'The students go'."
      },
      {
        "type": "exercise",
        "id": "fill_blank_8",
        "question": "Complete the sentence: '¿A qué hora ___ tú al trabajo?'",
        "options": [
          {"text": "llegas", "is_correct": true},
          {"text": "llego", "is_correct": false},
          {"text": "llega", "is_correct": false},
          {"text": "llegamos", "is_correct": false}
        ],
        "explanation": "Perfect! 'Llegas' is the 'tú' (you, informal) form. '¿A qué hora llegas?' means 'What time do you arrive?'"
      },
      {
        "type": "pronunciation",
        "id": "activities_pronunciation",
        "instruction": "Practice pronouncing these activity verbs. Pay attention to the conjugation endings.",
        "language_code": "es-ES",
        "words": [
          {
            "word": "cocino",
            "phonetic": "ko-SEE-no",
            "translation": "I cook"
          },
          {
            "word": "leo",
            "phonetic": "LE-o",
            "translation": "I read"
          },
          {
            "word": "estudio",
            "phonetic": "es-TOO-dyo",
            "translation": "I study"
          },
          {
            "word": "juego",
            "phonetic": "HWE-go",
            "translation": "I play"
          },
          {
            "word": "veo",
            "phonetic": "BE-o",
            "translation": "I see/watch"
          },
          {
            "word": "escucho",
            "phonetic": "es-KOO-cho",
            "translation": "I listen"
          }
        ],
        "explanation": "Great pronunciation! Notice how 'juego' has an 'h' sound at the beginning. 'Veo' and 'leo' both end with '-eo' which sounds like 'e-o'. Practice these conjugations!"
      },
      {
        "type": "exercise",
        "id": "fill_blank_9",
        "question": "Complete the sentence: 'Nosotros ___ deportes los sábados.'",
        "options": [
          {"text": "practicamos", "is_correct": true},
          {"text": "practico", "is_correct": false},
          {"text": "practicas", "is_correct": false},
          {"text": "practica", "is_correct": false}
        ],
        "explanation": "Correct! 'Practicamos' is the 'nosotros' (we) form. 'Nosotros practicamos' means 'We practice'."
      },
      {
        "type": "exercise",
        "id": "fill_blank_10",
        "question": "Complete the sentence: 'Yo ___ la música clásica, pero mi hermana prefiere el rock.'",
        "options": [
          {"text": "prefiero", "is_correct": true},
          {"text": "prefieres", "is_correct": false},
          {"text": "prefiere", "is_correct": false},
          {"text": "preferimos", "is_correct": false}
        ],
        "explanation": "Perfect! 'Prefiero' is the 'yo' (I) form. The verb 'preferir' changes the 'e' to 'ie' in some forms: prefiero, prefieres, prefiere, preferimos, prefieren."
      },
      {
        "type": "pronunciation",
        "id": "descriptive_words_pronunciation",
        "instruction": "Practice pronouncing these descriptive adjectives. Notice the stress patterns.",
        "language_code": "es-ES",
        "words": [
          {
            "word": "interesante",
            "phonetic": "in-te-re-SAN-te",
            "translation": "interesting"
          },
          {
            "word": "difícil",
            "phonetic": "dee-FEE-seel",
            "translation": "difficult"
          },
          {
            "word": "fácil",
            "phonetic": "FA-seel",
            "translation": "easy"
          },
          {
            "word": "importante",
            "phonetic": "im-por-TAN-te",
            "translation": "important"
          },
          {
            "word": "divertido",
            "phonetic": "dee-ber-TEE-do",
            "translation": "fun"
          },
          {
            "word": "aburrido",
            "phonetic": "a-boo-RREE-do",
            "translation": "boring"
          }
        ],
        "explanation": "Excellent pronunciation practice! Notice how 'difícil' and 'fácil' both have stress on the second-to-last syllable. 'Importante' and 'interesante' follow the same pattern!"
      },
      {
        "type": "exercise",
        "id": "fill_blank_11",
        "question": "Complete the sentence: 'El español es ___, pero muy ___ de aprender.'",
        "options": [
          {"text": "difícil, importante", "is_correct": true},
          {"text": "fácil, difícil", "is_correct": false},
          {"text": "divertido, aburrido", "is_correct": false},
          {"text": "interesante, fácil", "is_correct": false}
        ],
        "explanation": "Correct! The sentence means 'Spanish is difficult, but very important to learn.' This makes sense contextually."
      },
      {
        "type": "exercise",
        "id": "fill_blank_12",
        "question": "Complete the sentence: 'A mí no ___ las películas de terror, son muy ___ para mí.'",
        "options": [
          {"text": "me gustan, difíciles", "is_correct": true},
          {"text": "me gusta, fácil", "is_correct": false},
          {"text": "te gustan, divertidas", "is_correct": false},
          {"text": "le gusta, interesante", "is_correct": false}
        ],
        "explanation": "Perfect! 'Me gustan' is used because 'películas' is plural. 'Difíciles' is the plural form of 'difícil'. The sentence means 'I don't like horror movies, they're too difficult for me.'"
      },
      {
        "type": "pronunciation",
        "id": "complete_sentences_pronunciation",
        "instruction": "Practice pronouncing these complete sentences. Focus on natural flow and rhythm.",
        "language_code": "es-ES",
        "words": [
          {
            "word": "Yo siempre estudio en la biblioteca",
            "phonetic": "yo SYEM-pre es-TOO-dyo en la bee-blee-o-TE-ka",
            "translation": "I always study in the library"
          },
          {
            "word": "Nosotros vamos al parque los domingos",
            "phonetic": "no-SO-tros BA-mos al PAR-ke los do-MEEN-gos",
            "translation": "We go to the park on Sundays"
          },
          {
            "word": "Ella prefiere leer libros interesantes",
            "phonetic": "E-ya pre-FYEH-re le-ER LEE-bros in-te-re-SAN-tes",
            "translation": "She prefers to read interesting books"
          },
          {
            "word": "Tengo que llegar temprano al trabajo",
            "phonetic": "TEN-go ke ye-GAR tem-PRA-no al tra-BA-ho",
            "translation": "I have to arrive early to work"
          }
        ],
        "explanation": "Excellent! Practice these complete sentences to improve your fluency. Notice how words flow together naturally. Try to maintain the rhythm and stress patterns!"
      },
      {
        "type": "exercise",
        "id": "fill_blank_13",
        "question": "Complete the sentence: '¿Cuándo ___ tú a la universidad? ___ a las ocho de la mañana.'",
        "options": [
          {"text": "vas, Voy", "is_correct": true},
          {"text": "va, Va", "is_correct": false},
          {"text": "vamos, Vamos", "is_correct": false},
          {"text": "van, Van", "is_correct": false}
        ],
        "explanation": "Correct! '¿Cuándo vas tú?' means 'When do you go?' (tú form). The answer 'Voy' means 'I go' (yo form). The question uses 'tú' but the answer uses 'yo'."
      },
      {
        "type": "exercise",
        "id": "fill_blank_14",
        "question": "Complete the sentence: 'Ellos ___ cocinar porque ___ muy divertido.'",
        "options": [
          {"text": "prefieren, es", "is_correct": true},
          {"text": "prefiere, es", "is_correct": false},
          {"text": "preferimos, son", "is_correct": false},
          {"text": "prefieren, son", "is_correct": false}
        ],
        "explanation": "Perfect! 'Prefieren' is the third person plural (ellos form). 'Es' is used because 'cocinar' (to cook) is a singular infinitive, even though 'ellos' is plural."
      },
      {
        "type": "text",
        "id": "practice_tips",
        "title": "Practice Tips",
        "content": "Great job completing this lesson! Here are some tips to continue improving:",
        "examples": [
          "Practice pronunciation daily - even 5 minutes helps!",
          "Repeat fill-in-the-blank exercises until you get them all right",
          "Listen to Spanish speakers and try to repeat what they say",
          "Practice the complete sentences from the pronunciation exercises",
          "Focus on one verb conjugation at a time until it becomes natural",
          "Use these phrases in your daily conversations or practice"
        ]
      }
    ]
  }$lesson_json$,
  ARRAY[
    'spanish_tengo_que', 'spanish_necesito_ir', 'spanish_me_gusta', 'spanish_no_me_gusta', 'spanish_quiero', 'spanish_prefiero',
    'spanish_siempre', 'spanish_nunca', 'spanish_a_veces', 'spanish_todos_los_dias', 'spanish_una_vez', 'spanish_dos_veces',
    'spanish_hacer', 'spanish_decir', 'spanish_venir', 'spanish_ir', 'spanish_salir', 'spanish_llegar',
    'spanish_trabajo', 'spanish_escuela', 'spanish_casa', 'spanish_parque', 'spanish_tienda', 'spanish_restaurante',
    'spanish_cocinar', 'spanish_leer', 'spanish_estudiar', 'spanish_jugar', 'spanish_ver', 'spanish_escuchar',
    'spanish_interesante', 'spanish_dificil', 'spanish_facil', 'spanish_importante', 'spanish_divertido', 'spanish_aburrido'
  ],
  ARRAY['listening_practice', 'pronunciation', 'verb_conjugation', 'sentence_completion', 'everyday_vocabulary', 'speaking_practice']
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  updated_at = NOW();

COMMENT ON TABLE words IS 'Vocabulary words unlocked by this lesson include common phrases, time expressions, verbs, places, activities, and descriptive words for listening and speaking practice';


