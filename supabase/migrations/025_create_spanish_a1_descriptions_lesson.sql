-- A1 Spanish Lesson: Descriptions
-- This lesson teaches vocabulary for describing people, objects, and things in Spanish

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Physical Appearance
('spanish_alto', 'spanish', 'alto', 'tall', 'descriptions'),
('spanish_bajo', 'spanish', 'bajo', 'short', 'descriptions'),
('spanish_delgado', 'spanish', 'delgado', 'thin', 'descriptions'),
('spanish_gordo', 'spanish', 'gordo', 'fat', 'descriptions'),
('spanish_joven', 'spanish', 'joven', 'young', 'descriptions'),
('spanish_viejo', 'spanish', 'viejo', 'old', 'descriptions'),
('spanish_grande', 'spanish', 'grande', 'big/large', 'descriptions'),
('spanish_pequeno', 'spanish', 'pequeño', 'small', 'descriptions'),
-- Hair
('spanish_pelo_largo', 'spanish', 'pelo largo', 'long hair', 'descriptions'),
('spanish_pelo_corto', 'spanish', 'pelo corto', 'short hair', 'descriptions'),
('spanish_pelo_negro', 'spanish', 'pelo negro', 'black hair', 'descriptions'),
('spanish_pelo_rubio', 'spanish', 'pelo rubio', 'blonde hair', 'descriptions'),
('spanish_pelo_castaño', 'spanish', 'pelo castaño', 'brown hair', 'descriptions'),
-- Colors
('spanish_azul', 'spanish', 'azul', 'blue', 'descriptions'),
('spanish_rojo', 'spanish', 'rojo', 'red', 'descriptions'),
('spanish_verde', 'spanish', 'verde', 'green', 'descriptions'),
('spanish_amarillo', 'spanish', 'amarillo', 'yellow', 'descriptions'),
('spanish_blanco', 'spanish', 'blanco', 'white', 'descriptions'),
('spanish_negro', 'spanish', 'negro', 'black', 'descriptions'),
('spanish_gris', 'spanish', 'gris', 'gray', 'descriptions'),
('spanish_naranja', 'spanish', 'naranja', 'orange', 'descriptions'),
-- Characteristics
('spanish_bonito', 'spanish', 'bonito', 'pretty/nice', 'descriptions'),
('spanish_feo', 'spanish', 'feo', 'ugly', 'descriptions'),
('spanish_guapo', 'spanish', 'guapo', 'handsome/good-looking', 'descriptions'),
('spanish_inteligente', 'spanish', 'inteligente', 'intelligent', 'descriptions'),
('spanish_amable', 'spanish', 'amable', 'kind/friendly', 'descriptions'),
('spanish_divertido', 'spanish', 'divertido', 'fun/funny', 'descriptions'),
('spanish_serio', 'spanish', 'serio', 'serious', 'descriptions'),
('spanish_tranquilo', 'spanish', 'tranquilo', 'calm/quiet', 'descriptions'),
-- Material/Texture
('spanish_duro', 'spanish', 'duro', 'hard', 'descriptions'),
('spanish_blando', 'spanish', 'blando', 'soft', 'descriptions'),
('spanish_suave', 'spanish', 'suave', 'smooth', 'descriptions'),
('spanish_rugoso', 'spanish', 'rugoso', 'rough', 'descriptions'),
-- Temperature
('spanish_caliente', 'spanish', 'caliente', 'hot', 'descriptions'),
('spanish_frio', 'spanish', 'frío', 'cold', 'descriptions'),
-- Common Adjectives
('spanish_nuevo', 'spanish', 'nuevo', 'new', 'descriptions'),
('spanish_viejo_object', 'spanish', 'viejo', 'old', 'descriptions'),
('spanish_facil', 'spanish', 'fácil', 'easy', 'descriptions'),
('spanish_dificil', 'spanish', 'difícil', 'difficult', 'descriptions'),
('spanish_limpio', 'spanish', 'limpio', 'clean', 'descriptions'),
('spanish_sucio', 'spanish', 'sucio', 'dirty', 'descriptions'),
-- Questions
('spanish_como_es', 'spanish', '¿cómo es?', 'what is he/she/it like?', 'questions'),
('spanish_como_son', 'spanish', '¿cómo son?', 'what are they like?', 'questions'),
('spanish_que_color', 'spanish', '¿de qué color...?', 'what color...?', 'questions')
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
  'spanish_a1_descriptions',
  'Descriptions',
  'Learn to describe people, objects, and things in Spanish. Master adjectives, colors, and physical appearance vocabulary!',
  'spanish',
  'vocabulary',
  'A1',
  8,
  40,
  $lesson_json${
    "sections": [
      {
        "type": "text",
        "id": "descriptions_intro",
        "title": "Describing People and Things",
        "content": "Learning to describe is essential for communication! Let's learn how to describe people, objects, and things in Spanish using adjectives.",
        "examples": [
          "alto (tall)",
          "bajo (short)",
          "grande (big)",
          "pequeño (small)",
          "bonito (pretty)",
          "inteligente (intelligent)"
        ]
      },
      {
        "type": "example",
        "id": "physical_appearance_example_1",
        "spanish_example": "Mi hermana es alta y tiene pelo largo. Mi hermano es bajo y tiene pelo corto.",
        "english_translation": "My sister is tall and has long hair. My brother is short and has short hair.",
        "explanation": "Use 'ser' (es = is) with physical characteristics. 'Tiene' means 'has'. Adjectives match gender: 'alto' (masc), 'alta' (fem)."
      },
      {
        "type": "matching",
        "id": "physical_appearance_matching_1",
        "instruction": "Match the Spanish adjectives with their English translations",
        "pairs": [
          {"word": "alto", "translation": "tall"},
          {"word": "bajo", "translation": "short"},
          {"word": "delgado", "translation": "thin"},
          {"word": "gordo", "translation": "fat"},
          {"word": "joven", "translation": "young"},
          {"word": "viejo", "translation": "old"}
        ],
        "distractors": ["big", "small"],
        "explanation": "Great! These adjectives describe physical appearance. Remember that many adjectives change form: 'alto' (masc) / 'alta' (fem)."
      },
      {
        "type": "exercise",
        "id": "physical_appearance_exercise_1",
        "question": "How do you say 'tall' in Spanish?",
        "options": [
          {"text": "alto", "is_correct": true},
          {"text": "bajo", "is_correct": false},
          {"text": "grande", "is_correct": false},
          {"text": "pequeño", "is_correct": false}
        ],
        "explanation": "'Alto' means 'tall'. Use it with 'ser': 'Él es alto' (He is tall) or 'Ella es alta' (She is tall)."
      },
      {
        "type": "text",
        "id": "colors_intro",
        "title": "Colors",
        "content": "Let's learn colors in Spanish! Colors are adjectives, so they agree with the noun they describe.",
        "examples": [
          "azul (blue)",
          "rojo (red)",
          "verde (green)",
          "amarillo (yellow)",
          "blanco (white)",
          "negro (black)"
        ]
      },
      {
        "type": "example",
        "id": "colors_example_1",
        "spanish_example": "Tengo un coche azul. Mi amiga tiene un bolso rojo.",
        "english_translation": "I have a blue car. My friend has a red purse.",
        "explanation": "Colors usually come after the noun in Spanish: 'coche azul' (blue car). They agree in gender: 'coche azul' (masc), 'casa azul' (fem - same)."
      },
      {
        "type": "pronunciation",
        "id": "colors_pronunciation_1",
        "instruction": "Practice pronouncing these color words",
        "language_code": "es-ES",
        "words": [
          {
            "word": "azul",
            "phonetic": "ah-SOOL",
            "translation": "blue"
          },
          {
            "word": "rojo",
            "phonetic": "ROH-hoh",
            "translation": "red"
          },
          {
            "word": "verde",
            "phonetic": "BEHR-deh",
            "translation": "green"
          },
          {
            "word": "amarillo",
            "phonetic": "ah-mah-REE-yoh",
            "translation": "yellow"
          },
          {
            "word": "blanco",
            "phonetic": "BLAHN-koh",
            "translation": "white"
          },
          {
            "word": "negro",
            "phonetic": "NEH-groh",
            "translation": "black"
          }
        ],
        "explanation": "Excellent pronunciation practice! Notice how Spanish colors are pronounced. Keep practicing to sound natural!"
      },
      {
        "type": "matching",
        "id": "colors_matching_1",
        "instruction": "Match the Spanish colors with their English translations",
        "pairs": [
          {"word": "azul", "translation": "blue"},
          {"word": "rojo", "translation": "red"},
          {"word": "verde", "translation": "green"},
          {"word": "amarillo", "translation": "yellow"},
          {"word": "blanco", "translation": "white"},
          {"word": "negro", "translation": "black"},
          {"word": "gris", "translation": "gray"},
          {"word": "naranja", "translation": "orange"}
        ],
        "distractors": ["brown", "pink"],
        "explanation": "Perfect! You've learned the main colors in Spanish. Remember: most colors come after the noun: 'libro azul' (blue book)."
      },
      {
        "type": "text",
        "id": "hair_descriptions_intro",
        "title": "Describing Hair",
        "content": "Let's learn how to describe hair in Spanish. Use 'tener' (to have) with 'pelo' (hair).",
        "examples": [
          "pelo largo (long hair)",
          "pelo corto (short hair)",
          "pelo negro (black hair)",
          "pelo rubio (blonde hair)",
          "pelo castaño (brown hair)"
        ]
      },
      {
        "type": "example",
        "id": "hair_descriptions_example_1",
        "spanish_example": "María tiene pelo largo y rubio. Juan tiene pelo corto y negro.",
        "english_translation": "María has long, blonde hair. Juan has short, black hair.",
        "explanation": "Use 'tiene pelo' (has hair) to describe hair. Adjectives come after 'pelo': 'pelo largo' (long hair), 'pelo rubio' (blonde hair)."
      },
      {
        "type": "exercise",
        "id": "hair_descriptions_exercise_1",
        "question": "Complete: 'Ella ___ pelo largo' (She has long hair)",
        "options": [
          {"text": "tiene", "is_correct": true},
          {"text": "es", "is_correct": false},
          {"text": "tiene un", "is_correct": false},
          {"text": "es un", "is_correct": false}
        ],
        "explanation": "'Tiene' means 'has'. Use 'tiene pelo' to say someone has hair. Don't use an article with 'pelo' in this context."
      },
      {
        "type": "text",
        "id": "characteristics_intro",
        "title": "Personality and Characteristics",
        "content": "Now let's learn adjectives to describe personality and characteristics!",
        "examples": [
          "inteligente (intelligent)",
          "amable (kind/friendly)",
          "divertido (fun/funny)",
          "serio (serious)",
          "tranquilo (calm)"
        ]
      },
      {
        "type": "example",
        "id": "characteristics_example_1",
        "spanish_example": "Mi profesor es muy inteligente y amable. Mi amigo es divertido pero a veces es serio.",
        "english_translation": "My teacher is very intelligent and kind. My friend is funny but sometimes he is serious.",
        "explanation": "Use 'ser' with personality traits. 'Muy' means 'very'. You can combine adjectives with 'y' (and) or 'pero' (but)."
      },
      {
        "type": "pronunciation",
        "id": "characteristics_pronunciation_1",
        "instruction": "Practice pronouncing these personality adjectives",
        "language_code": "es-ES",
        "words": [
          {
            "word": "inteligente",
            "phonetic": "een-teh-lee-HEN-teh",
            "translation": "intelligent"
          },
          {
            "word": "amable",
            "phonetic": "ah-MAH-bleh",
            "translation": "kind/friendly"
          },
          {
            "word": "divertido",
            "phonetic": "dee-behr-TEE-doh",
            "translation": "fun/funny"
          },
          {
            "word": "tranquilo",
            "phonetic": "trahn-KEE-loh",
            "translation": "calm/quiet"
          }
        ],
        "explanation": "Good job! Notice the pronunciation of these personality adjectives. Practice makes perfect!"
      },
      {
        "type": "matching",
        "id": "characteristics_matching_1",
        "instruction": "Match the personality adjectives with their meanings",
        "pairs": [
          {"word": "inteligente", "translation": "intelligent"},
          {"word": "amable", "translation": "kind/friendly"},
          {"word": "divertido", "translation": "fun/funny"},
          {"word": "serio", "translation": "serious"},
          {"word": "tranquilo", "translation": "calm/quiet"},
          {"word": "guapo", "translation": "handsome/good-looking"}
        ],
        "distractors": ["ugly", "tall"],
        "explanation": "Excellent! These adjectives describe personality and appearance. Most don't change form for gender: 'inteligente' (same for masc/fem)."
      },
      {
        "type": "text",
        "id": "material_texture_intro",
        "title": "Describing Objects: Material and Texture",
        "content": "Let's learn how to describe objects! These adjectives describe what things feel like or are made of.",
        "examples": [
          "duro (hard)",
          "blando (soft)",
          "suave (smooth)",
          "caliente (hot)",
          "frío (cold)"
        ]
      },
      {
        "type": "example",
        "id": "material_texture_example_1",
        "spanish_example": "La cama es blanda y suave. La mesa es dura.",
        "english_translation": "The bed is soft and smooth. The table is hard.",
        "explanation": "Use 'ser' to describe characteristics of objects. 'Blanda' (soft, fem) agrees with 'cama' (bed, fem)."
      },
      {
        "type": "exercise",
        "id": "material_texture_exercise_1",
        "question": "How do you say 'soft' in Spanish?",
        "options": [
          {"text": "blando", "is_correct": true},
          {"text": "duro", "is_correct": false},
          {"text": "suave", "is_correct": false},
          {"text": "caliente", "is_correct": false}
        ],
        "explanation": "'Blando' means 'soft'. 'Suave' means 'smooth'. Both can describe textures, but 'blando' specifically means soft to touch."
      },
      {
        "type": "text",
        "id": "common_adjectives_intro",
        "title": "Common Descriptive Adjectives",
        "content": "Here are some very common adjectives you'll use often to describe things!",
        "examples": [
          "nuevo (new)",
          "viejo (old)",
          "fácil (easy)",
          "difícil (difficult)",
          "limpio (clean)",
          "sucio (dirty)"
        ]
      },
      {
        "type": "example",
        "id": "common_adjectives_example_1",
        "spanish_example": "Tengo un coche nuevo. La tarea es fácil. La casa está limpia.",
        "english_translation": "I have a new car. The homework is easy. The house is clean.",
        "explanation": "Notice: 'coche nuevo' (new car) - adjective after noun. 'Es fácil' (is easy). 'Está limpia' (is clean) - use 'estar' for temporary states."
      },
      {
        "type": "pronunciation",
        "id": "common_adjectives_pronunciation_1",
        "instruction": "Practice pronouncing these common adjectives",
        "language_code": "es-ES",
        "words": [
          {
            "word": "nuevo",
            "phonetic": "NWAY-voh",
            "translation": "new"
          },
          {
            "word": "fácil",
            "phonetic": "FAH-seel",
            "translation": "easy"
          },
          {
            "word": "difícil",
            "phonetic": "dee-FEE-seel",
            "translation": "difficult"
          },
          {
            "word": "limpio",
            "phonetic": "LEEM-pee-oh",
            "translation": "clean"
          }
        ],
        "explanation": "Great pronunciation! Notice the stress patterns: 'fácil' (stress on first syllable), 'difícil' (stress on second syllable)."
      },
      {
        "type": "text",
        "id": "asking_questions_intro",
        "title": "Asking About Descriptions",
        "content": "Let's learn how to ask about descriptions! These questions help you find out what things are like.",
        "examples": [
          "¿Cómo es? (What is he/she/it like?)",
          "¿Cómo son? (What are they like?)",
          "¿De qué color...? (What color...?)"
        ]
      },
      {
        "type": "example",
        "id": "asking_questions_example_1",
        "spanish_example": "A: ¿Cómo es tu hermana? / B: Es alta y tiene pelo rubio.",
        "english_translation": "A: What is your sister like? / B: She is tall and has blonde hair.",
        "explanation": "'¿Cómo es?' asks for a description of one person/thing. '¿Cómo son?' asks about multiple. Answer with 'es' + adjectives."
      },
      {
        "type": "exercise",
        "id": "asking_questions_exercise_1",
        "question": "How do you ask 'What color is it?' in Spanish?",
        "options": [
          {"text": "¿De qué color es?", "is_correct": true},
          {"text": "¿Qué color es?", "is_correct": false},
          {"text": "¿Cómo es el color?", "is_correct": false},
          {"text": "¿Cuál es el color?", "is_correct": false}
        ],
        "explanation": "'¿De qué color es?' is the correct way to ask what color something is. Use 'de' before 'qué color'."
      },
      {
        "type": "text",
        "id": "putting_it_together",
        "title": "Putting It All Together",
        "content": "Now you can describe people, objects, and things in Spanish! Practice combining different types of descriptions.",
        "examples": [
          "Complete description: 'Mi amigo es alto, joven, y tiene pelo corto y negro. Es muy inteligente y amable.'",
          "Describing objects: 'Tengo una mesa nueva. Es grande y de color marrón. La superficie es suave.'",
          "Asking questions: '¿Cómo es tu profesor?' (What is your teacher like?)"
        ]
      },
      {
        "type": "matching",
        "id": "comprehensive_matching_1",
        "instruction": "Match the Spanish description words with their English translations",
        "pairs": [
          {"word": "alto", "translation": "tall"},
          {"word": "azul", "translation": "blue"},
          {"word": "inteligente", "translation": "intelligent"},
          {"word": "nuevo", "translation": "new"},
          {"word": "pelo largo", "translation": "long hair"},
          {"word": "bonito", "translation": "pretty/nice"},
          {"word": "fácil", "translation": "easy"},
          {"word": "amable", "translation": "kind/friendly"}
        ],
        "distractors": ["difficult", "ugly"],
        "explanation": "Fantastic! You've learned a comprehensive set of descriptive vocabulary. Keep practicing to remember all these adjectives!"
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "Complete: 'Ella ___ alta y ___ pelo rubio' (She is tall and has blonde hair)",
        "options": [
          {"text": "es, tiene", "is_correct": true},
          {"text": "tiene, es", "is_correct": false},
          {"text": "es, es", "is_correct": false},
          {"text": "tiene, tiene", "is_correct": false}
        ],
        "explanation": "Use 'es' (is) for characteristics: 'es alta' (is tall). Use 'tiene' (has) for hair: 'tiene pelo rubio' (has blonde hair)."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "How do you say 'What is he/she/it like?' in Spanish?",
        "options": [
          {"text": "¿Cómo es?", "is_correct": true},
          {"text": "¿Qué es?", "is_correct": false},
          {"text": "¿Cómo está?", "is_correct": false},
          {"text": "¿Qué tiene?", "is_correct": false}
        ],
        "explanation": "'¿Cómo es?' asks for a description of what someone or something is like. '¿Cómo está?' asks how someone is feeling (temporary state)."
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'spanish_alto',
    'spanish_bajo',
    'spanish_delgado',
    'spanish_gordo',
    'spanish_joven',
    'spanish_viejo',
    'spanish_grande',
    'spanish_pequeno',
    'spanish_pelo_largo',
    'spanish_pelo_corto',
    'spanish_pelo_negro',
    'spanish_pelo_rubio',
    'spanish_pelo_castaño',
    'spanish_azul',
    'spanish_rojo',
    'spanish_verde',
    'spanish_amarillo',
    'spanish_blanco',
    'spanish_negro',
    'spanish_gris',
    'spanish_naranja',
    'spanish_bonito',
    'spanish_feo',
    'spanish_guapo',
    'spanish_inteligente',
    'spanish_amable',
    'spanish_divertido',
    'spanish_serio',
    'spanish_tranquilo',
    'spanish_duro',
    'spanish_blando',
    'spanish_suave',
    'spanish_rugoso',
    'spanish_caliente',
    'spanish_frio',
    'spanish_nuevo',
    'spanish_viejo_object',
    'spanish_facil',
    'spanish_dificil',
    'spanish_limpio',
    'spanish_sucio',
    'spanish_como_es',
    'spanish_como_son',
    'spanish_que_color'
  ]::TEXT[],
  ARRAY['descriptions', 'adjectives', 'colors', 'physical_appearance', 'personality', 'ser_estar']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  level = EXCLUDED.level,
  updated_at = NOW();

