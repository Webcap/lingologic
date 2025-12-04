-- A1 Spanish Lesson: The Family and Relationships
-- This lesson teaches family members and relationship vocabulary in Spanish

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Immediate Family
('spanish_familia', 'spanish', 'familia', 'family', 'family'),
('spanish_padre', 'spanish', 'padre', 'father', 'family'),
('spanish_madre', 'spanish', 'madre', 'mother', 'family'),
('spanish_papa', 'spanish', 'papá', 'dad', 'family'),
('spanish_mama', 'spanish', 'mamá', 'mom', 'family'),
('spanish_hijo', 'spanish', 'hijo', 'son', 'family'),
('spanish_hija', 'spanish', 'hija', 'daughter', 'family'),
('spanish_hermano', 'spanish', 'hermano', 'brother', 'family'),
('spanish_hermana', 'spanish', 'hermana', 'sister', 'family'),
-- Extended Family
('spanish_abuelo', 'spanish', 'abuelo', 'grandfather', 'family'),
('spanish_abuela', 'spanish', 'abuela', 'grandmother', 'family'),
('spanish_abuelos', 'spanish', 'abuelos', 'grandparents', 'family'),
('spanish_tio', 'spanish', 'tío', 'uncle', 'family'),
('spanish_tia', 'spanish', 'tía', 'aunt', 'family'),
('spanish_primo', 'spanish', 'primo', 'cousin (male)', 'family'),
('spanish_prima', 'spanish', 'prima', 'cousin (female)', 'family'),
('spanish_sobrino', 'spanish', 'sobrino', 'nephew', 'family'),
('spanish_sobrina', 'spanish', 'sobrina', 'niece', 'family'),
-- Relationship Terms
('spanish_esposo', 'spanish', 'esposo', 'husband', 'relationships'),
('spanish_esposa', 'spanish', 'esposa', 'wife', 'relationships'),
('spanish_marido', 'spanish', 'marido', 'husband', 'relationships'),
('spanish_mujer', 'spanish', 'mujer', 'wife/woman', 'relationships'),
('spanish_novio', 'spanish', 'novio', 'boyfriend', 'relationships'),
('spanish_novia', 'spanish', 'novia', 'girlfriend', 'relationships'),
('spanish_hijo_unico', 'spanish', 'hijo único', 'only child', 'family'),
('spanish_gemelos', 'spanish', 'gemelos', 'twins', 'family'),
-- Describing Family
('spanish_mayor', 'spanish', 'mayor', 'older', 'descriptors'),
('spanish_menor', 'spanish', 'menor', 'younger', 'descriptors'),
('spanish_casado', 'spanish', 'casado', 'married (male)', 'relationships'),
('spanish_casada', 'spanish', 'casada', 'married (female)', 'relationships'),
('spanish_soltero', 'spanish', 'soltero', 'single (male)', 'relationships'),
('spanish_soltera', 'spanish', 'soltera', 'single (female)', 'relationships'),
-- Questions
('spanish_cuantos_hermanos', 'spanish', '¿cuántos hermanos tienes?', 'how many siblings do you have?', 'questions'),
('spanish_tienes_hermanos', 'spanish', '¿tienes hermanos?', 'do you have siblings?', 'questions'),
('spanish_como_se_llama', 'spanish', '¿cómo se llama?', 'what is his/her name?', 'questions'),
('spanish_cuantos_anos_tiene', 'spanish', '¿cuántos años tiene?', 'how old is he/she?', 'questions')
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
  'spanish_a1_family_relationships',
  'The Family and Relationships',
  'Learn to talk about your family members and relationships in Spanish. Essential vocabulary for describing your loved ones!',
  'spanish',
  'vocabulary',
  'A1',
  5,
  35,
  $lesson_json${
    "sections": [
      {
        "type": "text",
        "id": "family_intro",
        "title": "Family Members",
        "content": "Talking about family is a common topic in conversations. In Spanish, family member words often have different forms for male and female. Let's learn the most important family vocabulary!",
        "examples": [
          "padre/madre (father/mother)",
          "hermano/hermana (brother/sister)",
          "hijo/hija (son/daughter)",
          "abuelo/abuela (grandfather/grandmother)"
        ]
      },
      {
        "type": "example",
        "id": "family_example_1",
        "spanish_example": "Mi familia es pequeña. Tengo un hermano y una hermana.",
        "english_translation": "My family is small. I have one brother and one sister.",
        "explanation": "Notice how we use 'un' for masculine nouns (hermano) and 'una' for feminine nouns (hermana). 'Tengo' means 'I have'."
      },
      {
        "type": "example",
        "id": "family_example_2",
        "spanish_example": "Mis abuelos viven en Madrid. Mi abuela cocina muy bien.",
        "english_translation": "My grandparents live in Madrid. My grandmother cooks very well.",
        "explanation": "'Mis' means 'my' for plural nouns. 'Abuelos' can mean 'grandparents' (plural) or just 'grandfathers' depending on context."
      },
      {
        "type": "matching",
        "id": "family_matching_1",
        "instruction": "Match the Spanish family words with their English translations",
        "pairs": [
          {"word": "padre", "translation": "father"},
          {"word": "madre", "translation": "mother"},
          {"word": "hermano", "translation": "brother"},
          {"word": "hermana", "translation": "sister"},
          {"word": "abuelo", "translation": "grandfather"},
          {"word": "abuela", "translation": "grandmother"}
        ],
        "distractors": ["son", "daughter"],
        "explanation": "Great job! These are the basic family member words. Remember: words ending in '-o' are usually masculine, and words ending in '-a' are usually feminine."
      },
      {
        "type": "exercise",
        "id": "family_exercise_1",
        "question": "How do you say 'sister' in Spanish?",
        "options": [
          {"text": "hermana", "is_correct": true},
          {"text": "hermano", "is_correct": false},
          {"text": "hija", "is_correct": false},
          {"text": "madre", "is_correct": false}
        ],
        "explanation": "'Hermana' is sister. 'Hermano' is brother. Notice the '-a' ending for feminine words."
      },
      {
        "type": "text",
        "id": "extended_family_intro",
        "title": "Extended Family",
        "content": "Now let's learn about extended family members - uncles, aunts, cousins, and more!",
        "examples": [
          "tío/tía (uncle/aunt)",
          "primo/prima (cousin)",
          "sobrino/sobrina (nephew/niece)"
        ]
      },
      {
        "type": "example",
        "id": "extended_family_example_1",
        "spanish_example": "Tengo dos tíos y tres tías. Mis primos viven en Barcelona.",
        "english_translation": "I have two uncles and three aunts. My cousins live in Barcelona.",
        "explanation": "Use 'tengo' (I have) followed by the number and family member. 'Primos' can mean male cousins or mixed gender cousins."
      },
      {
        "type": "matching",
        "id": "extended_family_matching_1",
        "instruction": "Match the extended family members with their translations",
        "pairs": [
          {"word": "tío", "translation": "uncle"},
          {"word": "tía", "translation": "aunt"},
          {"word": "primo", "translation": "cousin (male)"},
          {"word": "prima", "translation": "cousin (female)"},
          {"word": "sobrino", "translation": "nephew"},
          {"word": "sobrina", "translation": "niece"}
        ],
        "explanation": "Excellent! You're learning the extended family vocabulary. Remember that Spanish has separate words for male and female relatives."
      },
      {
        "type": "exercise",
        "id": "extended_family_exercise_1",
        "question": "Complete: 'Mi ___ se llama María' (My aunt is named María)",
        "options": [
          {"text": "tía", "is_correct": true},
          {"text": "tío", "is_correct": false},
          {"text": "prima", "is_correct": false},
          {"text": "abuela", "is_correct": false}
        ],
        "explanation": "'Tía' is aunt. Since we're talking about a female relative, we use the feminine form."
      },
      {
        "type": "text",
        "id": "relationships_intro",
        "title": "Describing Relationships",
        "content": "Let's learn how to talk about marital status and relationships in Spanish. This is important for describing your family members!",
        "examples": [
          "casado/casada (married)",
          "soltero/soltera (single)",
          "esposo/esposa (husband/wife)"
        ]
      },
      {
        "type": "example",
        "id": "relationships_example_1",
        "spanish_example": "Mi hermana está casada. Su esposo se llama Carlos.",
        "english_translation": "My sister is married. Her husband is named Carlos.",
        "explanation": "'Está casada' means 'is married' (for a woman). Notice we use 'su' (his/her) to say 'her husband'."
      },
      {
        "type": "example",
        "id": "relationships_example_2",
        "spanish_example": "Soy soltero. No tengo novia.",
        "english_translation": "I am single. I don't have a girlfriend.",
        "explanation": "'Soy soltero' means 'I am single' (for a man). 'No tengo' means 'I don't have'."
      },
      {
        "type": "matching",
        "id": "relationships_matching_1",
        "instruction": "Match the relationship terms with their meanings",
        "pairs": [
          {"word": "esposo", "translation": "husband"},
          {"word": "esposa", "translation": "wife"},
          {"word": "novio", "translation": "boyfriend"},
          {"word": "novia", "translation": "girlfriend"},
          {"word": "casado", "translation": "married (male)"},
          {"word": "soltero", "translation": "single (male)"}
        ],
        "explanation": "Perfect! You're learning relationship vocabulary. Notice how marital status adjectives change based on gender."
      },
      {
        "type": "exercise",
        "id": "relationships_exercise_1",
        "question": "How do you say 'I am married' (if you are a woman)?",
        "options": [
          {"text": "Estoy casada", "is_correct": true},
          {"text": "Soy casada", "is_correct": false},
          {"text": "Estoy casado", "is_correct": false},
          {"text": "Soy soltera", "is_correct": false}
        ],
        "explanation": "We use 'estoy casada' for 'I am married' (female). 'Estar' is used for temporary states like marital status."
      },
      {
        "type": "text",
        "id": "asking_questions_intro",
        "title": "Asking About Family",
        "content": "Now let's learn how to ask questions about someone's family. These are very useful in conversations!",
        "examples": [
          "¿Tienes hermanos? (Do you have siblings?)",
          "¿Cuántos hermanos tienes? (How many siblings do you have?)",
          "¿Cómo se llama tu hermano? (What is your brother's name?)"
        ]
      },
      {
        "type": "example",
        "id": "asking_questions_example_1",
        "spanish_example": "A: ¿Tienes hermanos? / B: Sí, tengo dos hermanas y un hermano.",
        "english_translation": "A: Do you have siblings? / B: Yes, I have two sisters and one brother.",
        "explanation": "'¿Tienes hermanos?' is a common question. You can answer with 'Sí' (yes) or 'No' (no), followed by details."
      },
      {
        "type": "example",
        "id": "asking_questions_example_2",
        "spanish_example": "¿Cuántos años tiene tu abuela? Tiene setenta años.",
        "english_translation": "How old is your grandmother? She is seventy years old.",
        "explanation": "'¿Cuántos años tiene?' means 'How old is...?'. To answer, say 'Tiene [number] años' (He/She is [number] years old)."
      },
      {
        "type": "exercise",
        "id": "asking_questions_exercise_1",
        "question": "How do you ask 'Do you have siblings?' in Spanish?",
        "options": [
          {"text": "¿Tienes hermanos?", "is_correct": true},
          {"text": "¿Tienes familia?", "is_correct": false},
          {"text": "¿Cuántos hermanos?", "is_correct": false},
          {"text": "¿Tienes padre?", "is_correct": false}
        ],
        "explanation": "'¿Tienes hermanos?' is the correct way to ask if someone has siblings. 'Hermanos' can mean 'brothers' or 'siblings' (brothers and sisters)."
      },
      {
        "type": "text",
        "id": "putting_it_together",
        "title": "Putting It All Together",
        "content": "Now you can describe your family and ask others about theirs! Practice using all the vocabulary you've learned.",
        "examples": [
          "Talking about family size: 'Tengo una familia grande' (I have a big family)",
          "Describing family members: 'Mi hermana mayor se llama Ana' (My older sister is named Ana)",
          "Asking about family: '¿Cuántos primos tienes?' (How many cousins do you have?)"
        ]
      },
      {
        "type": "matching",
        "id": "comprehensive_matching_1",
        "instruction": "Match the Spanish words with their English translations",
        "pairs": [
          {"word": "familia", "translation": "family"},
          {"word": "hijo", "translation": "son"},
          {"word": "hija", "translation": "daughter"},
          {"word": "abuelos", "translation": "grandparents"},
          {"word": "primo", "translation": "cousin (male)"},
          {"word": "esposa", "translation": "wife"},
          {"word": "novio", "translation": "boyfriend"},
          {"word": "sobrina", "translation": "niece"}
        ],
        "distractors": ["daughter", "wife"],
        "explanation": "Fantastic! You've mastered the family and relationship vocabulary. Keep practicing to remember all these words!"
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "Complete the sentence: 'Mi ___ tiene cinco años' (My son is five years old)",
        "options": [
          {"text": "hijo", "is_correct": true},
          {"text": "hija", "is_correct": false},
          {"text": "hermano", "is_correct": false},
          {"text": "sobrino", "is_correct": false}
        ],
        "explanation": "'Hijo' means 'son'. Since we're talking about a boy who is five years old, we use 'hijo'."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "How would you say 'I have three brothers and one sister'?",
        "options": [
          {"text": "Tengo tres hermanos y una hermana", "is_correct": true},
          {"text": "Tengo tres hermanas y un hermano", "is_correct": false},
          {"text": "Tengo tres hijos y una hija", "is_correct": false},
          {"text": "Tengo tres primos y una prima", "is_correct": false}
        ],
        "explanation": "'Tengo tres hermanos y una hermana' is correct. Notice 'hermanos' (brothers/male siblings) and 'hermana' (sister)."
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'spanish_familia',
    'spanish_padre',
    'spanish_madre',
    'spanish_papa',
    'spanish_mama',
    'spanish_hijo',
    'spanish_hija',
    'spanish_hermano',
    'spanish_hermana',
    'spanish_abuelo',
    'spanish_abuela',
    'spanish_abuelos',
    'spanish_tio',
    'spanish_tia',
    'spanish_primo',
    'spanish_prima',
    'spanish_sobrino',
    'spanish_sobrina',
    'spanish_esposo',
    'spanish_esposa',
    'spanish_marido',
    'spanish_mujer',
    'spanish_novio',
    'spanish_novia',
    'spanish_hijo_unico',
    'spanish_gemelos',
    'spanish_mayor',
    'spanish_menor',
    'spanish_casado',
    'spanish_casada',
    'spanish_soltero',
    'spanish_soltera',
    'spanish_cuantos_hermanos',
    'spanish_tienes_hermanos',
    'spanish_como_se_llama',
    'spanish_cuantos_anos_tiene'
  ]::TEXT[],
  ARRAY['family_vocabulary', 'possessive_adjectives', 'tener_verb', 'estar_verb']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  level = EXCLUDED.level,
  updated_at = NOW();


