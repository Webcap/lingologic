-- A1 Spanish Lesson: The Home and Describing Places
-- This lesson teaches vocabulary for rooms, furniture, and how to describe places in Spanish

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Rooms in the House
('spanish_casa', 'spanish', 'casa', 'house/home', 'home'),
('spanish_apartamento', 'spanish', 'apartamento', 'apartment', 'home'),
('spanish_cuarto', 'spanish', 'cuarto', 'room', 'home'),
('spanish_habitacion', 'spanish', 'habitación', 'bedroom', 'home'),
('spanish_sala', 'spanish', 'sala', 'living room', 'home'),
('spanish_salon', 'spanish', 'salón', 'living room', 'home'),
('spanish_cocina', 'spanish', 'cocina', 'kitchen', 'home'),
('spanish_banio', 'spanish', 'baño', 'bathroom', 'home'),
('spanish_comedor', 'spanish', 'comedor', 'dining room', 'home'),
('spanish_jardin', 'spanish', 'jardín', 'garden', 'home'),
-- Furniture and Items
('spanish_mesa', 'spanish', 'mesa', 'table', 'furniture'),
('spanish_silla', 'spanish', 'silla', 'chair', 'furniture'),
('spanish_sofá', 'spanish', 'sofá', 'sofa', 'furniture'),
('spanish_cama', 'spanish', 'cama', 'bed', 'furniture'),
('spanish_armario', 'spanish', 'armario', 'wardrobe/closet', 'furniture'),
('spanish_escritorio', 'spanish', 'escritorio', 'desk', 'furniture'),
('spanish_estanteria', 'spanish', 'estantería', 'bookshelf', 'furniture'),
('spanish_lampara', 'spanish', 'lámpara', 'lamp', 'furniture'),
('spanish_ventana', 'spanish', 'ventana', 'window', 'home'),
('spanish_puerta', 'spanish', 'puerta', 'door', 'home'),
('spanish_televisor', 'spanish', 'televisor', 'TV', 'furniture'),
('spanish_refrigerador', 'spanish', 'refrigerador', 'refrigerator', 'appliances'),
('spanish_cocina_stove', 'spanish', 'cocina', 'stove', 'appliances'),
-- Describing Places
('spanish_grande', 'spanish', 'grande', 'big/large', 'descriptors'),
('spanish_pequeno', 'spanish', 'pequeño', 'small', 'descriptors'),
('spanish_bonito', 'spanish', 'bonito', 'pretty/nice', 'descriptors'),
('spanish_feo', 'spanish', 'feo', 'ugly', 'descriptors'),
('spanish_moderno', 'spanish', 'moderno', 'modern', 'descriptors'),
('spanish_viejo', 'spanish', 'viejo', 'old', 'descriptors'),
('spanish_nuevo', 'spanish', 'nuevo', 'new', 'descriptors'),
('spanish_limpio', 'spanish', 'limpio', 'clean', 'descriptors'),
('spanish_sucio', 'spanish', 'sucio', 'dirty', 'descriptors'),
('spanish_comodo', 'spanish', 'cómodo', 'comfortable', 'descriptors'),
-- Location and Position
('spanish_en', 'spanish', 'en', 'in/on', 'prepositions'),
('spanish_debajo_de', 'spanish', 'debajo de', 'under/below', 'prepositions'),
('spanish_encima_de', 'spanish', 'encima de', 'on top of', 'prepositions'),
('spanish_al_lado_de', 'spanish', 'al lado de', 'next to', 'prepositions'),
('spanish_detras_de', 'spanish', 'detrás de', 'behind', 'prepositions'),
('spanish_delante_de', 'spanish', 'delante de', 'in front of', 'prepositions'),
-- Questions
('spanish_donde_vives', 'spanish', '¿dónde vives?', 'where do you live?', 'questions'),
('spanish_en_que_piso', 'spanish', '¿en qué piso vives?', 'what floor do you live on?', 'questions'),
('spanish_cuantas_habitaciones', 'spanish', '¿cuántas habitaciones tiene?', 'how many rooms does it have?', 'questions')
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
  'spanish_a1_home_describing_places',
  'The Home and Describing Places',
  'Learn vocabulary for rooms, furniture, and how to describe your home and other places in Spanish. Essential for talking about where you live!',
  'spanish',
  'vocabulary',
  'A1',
  6,
  35,
  $lesson_json${
    "sections": [
      {
        "type": "text",
        "id": "home_intro",
        "title": "Rooms in the House",
        "content": "Let's learn the names of different rooms in a house or apartment. This vocabulary is essential for describing where you live!",
        "examples": [
          "casa (house/home)",
          "habitación (bedroom)",
          "cocina (kitchen)",
          "baño (bathroom)",
          "sala/salón (living room)"
        ]
      },
      {
        "type": "example",
        "id": "home_example_1",
        "spanish_example": "Vivo en un apartamento pequeño. Tiene dos habitaciones y una cocina.",
        "english_translation": "I live in a small apartment. It has two bedrooms and a kitchen.",
        "explanation": "'Vivo en' means 'I live in'. Notice how we use 'un' for masculine nouns (apartamento) and 'una' for feminine nouns (cocina)."
      },
      {
        "type": "example",
        "id": "home_example_2",
        "spanish_example": "En mi casa hay tres habitaciones, una sala, una cocina y dos baños.",
        "english_translation": "In my house there are three bedrooms, a living room, a kitchen, and two bathrooms.",
        "explanation": "'Hay' means 'there is' or 'there are'. We use it to say what exists in a place."
      },
      {
        "type": "matching",
        "id": "rooms_matching_1",
        "instruction": "Match the Spanish room names with their English translations",
        "pairs": [
          {"word": "casa", "translation": "house"},
          {"word": "habitación", "translation": "bedroom"},
          {"word": "cocina", "translation": "kitchen"},
          {"word": "baño", "translation": "bathroom"},
          {"word": "sala", "translation": "living room"},
          {"word": "comedor", "translation": "dining room"}
        ],
        "distractors": ["garden", "window"],
        "explanation": "Great job! These are the basic room names. Remember that 'habitación' and 'cuarto' both mean 'room' or 'bedroom'."
      },
      {
        "type": "exercise",
        "id": "rooms_exercise_1",
        "question": "How do you say 'kitchen' in Spanish?",
        "options": [
          {"text": "cocina", "is_correct": true},
          {"text": "casa", "is_correct": false},
          {"text": "habitación", "is_correct": false},
          {"text": "baño", "is_correct": false}
        ],
        "explanation": "'Cocina' means kitchen. It's a feminine noun, so we use 'la cocina' (the kitchen)."
      },
      {
        "type": "text",
        "id": "furniture_intro",
        "title": "Furniture and Items",
        "content": "Now let's learn the names of common furniture and items you find in a home. These words will help you describe your living space!",
        "examples": [
          "mesa (table)",
          "silla (chair)",
          "cama (bed)",
          "sofá (sofa)",
          "armario (wardrobe)"
        ]
      },
      {
        "type": "example",
        "id": "furniture_example_1",
        "spanish_example": "En mi habitación hay una cama, un escritorio y un armario.",
        "english_translation": "In my bedroom there is a bed, a desk, and a wardrobe.",
        "explanation": "Notice how we use 'una' for feminine nouns (cama) and 'un' for masculine nouns (escritorio, armario)."
      },
      {
        "type": "matching",
        "id": "furniture_matching_1",
        "instruction": "Match the furniture items with their translations",
        "pairs": [
          {"word": "mesa", "translation": "table"},
          {"word": "silla", "translation": "chair"},
          {"word": "cama", "translation": "bed"},
          {"word": "sofá", "translation": "sofa"},
          {"word": "armario", "translation": "wardrobe"},
          {"word": "escritorio", "translation": "desk"}
        ],
        "distractors": ["door", "window"],
        "explanation": "Excellent! You're learning furniture vocabulary. Remember the gender: 'la mesa' (feminine) and 'el escritorio' (masculine)."
      },
      {
        "type": "exercise",
        "id": "furniture_exercise_1",
        "question": "Complete: 'En la sala hay un ___' (In the living room there is a sofa)",
        "options": [
          {"text": "sofá", "is_correct": true},
          {"text": "cama", "is_correct": false},
          {"text": "mesa", "is_correct": false},
          {"text": "armario", "is_correct": false}
        ],
        "explanation": "'Sofá' is sofa. Since it's masculine, we use 'un sofá'."
      },
      {
        "type": "text",
        "id": "describing_intro",
        "title": "Describing Places",
        "content": "Let's learn adjectives to describe rooms and places. These will help you talk about how your home looks and feels!",
        "examples": [
          "grande/pequeño (big/small)",
          "bonito/feo (pretty/ugly)",
          "moderno/viejo (modern/old)",
          "limpio/sucio (clean/dirty)"
        ]
      },
      {
        "type": "example",
        "id": "describing_example_1",
        "spanish_example": "Mi apartamento es pequeño pero muy cómodo. La cocina es moderna y limpia.",
        "english_translation": "My apartment is small but very comfortable. The kitchen is modern and clean.",
        "explanation": "Notice how adjectives come after the noun in Spanish: 'apartamento pequeño' (small apartment), 'cocina moderna' (modern kitchen)."
      },
      {
        "type": "matching",
        "id": "describing_matching_1",
        "instruction": "Match the descriptive adjectives with their meanings",
        "pairs": [
          {"word": "grande", "translation": "big"},
          {"word": "pequeño", "translation": "small"},
          {"word": "bonito", "translation": "pretty"},
          {"word": "moderno", "translation": "modern"},
          {"word": "limpio", "translation": "clean"},
          {"word": "cómodo", "translation": "comfortable"}
        ],
        "explanation": "Perfect! You're learning descriptive vocabulary. Remember that adjectives must agree with the noun's gender: 'casa bonita' (pretty house) vs 'apartamento bonito' (pretty apartment)."
      },
      {
        "type": "exercise",
        "id": "describing_exercise_1",
        "question": "How do you say 'My house is big' in Spanish?",
        "options": [
          {"text": "Mi casa es grande", "is_correct": true},
          {"text": "Mi casa es pequeña", "is_correct": false},
          {"text": "Mi casa grande", "is_correct": false},
          {"text": "Mi casa está grande", "is_correct": false}
        ],
        "explanation": "'Mi casa es grande' is correct. We use 'ser' (es) with adjectives that describe permanent characteristics like size."
      },
      {
        "type": "text",
        "id": "location_intro",
        "title": "Location and Position",
        "content": "Now let's learn prepositions to describe where things are located. These will help you describe the layout of your home!",
        "examples": [
          "en (in/on)",
          "debajo de (under)",
          "encima de (on top of)",
          "al lado de (next to)",
          "delante de (in front of)"
        ]
      },
      {
        "type": "example",
        "id": "location_example_1",
        "spanish_example": "La mesa está en el comedor. Las sillas están alrededor de la mesa.",
        "english_translation": "The table is in the dining room. The chairs are around the table.",
        "explanation": "'Está' (is) is used to describe location. Notice 'alrededor de' means 'around'."
      },
      {
        "type": "example",
        "id": "location_example_2",
        "spanish_example": "El sofá está al lado de la ventana. La lámpara está encima de la mesa.",
        "english_translation": "The sofa is next to the window. The lamp is on top of the table.",
        "explanation": "Use 'al lado de' for 'next to' and 'encima de' for 'on top of'. 'Está' agrees with the subject (el sofá, la lámpara)."
      },
      {
        "type": "exercise",
        "id": "location_exercise_1",
        "question": "How do you say 'The book is under the table'?",
        "options": [
          {"text": "El libro está debajo de la mesa", "is_correct": true},
          {"text": "El libro está encima de la mesa", "is_correct": false},
          {"text": "El libro está al lado de la mesa", "is_correct": false},
          {"text": "El libro está delante de la mesa", "is_correct": false}
        ],
        "explanation": "'Debajo de' means 'under' or 'below'. We use 'está' to describe location."
      },
      {
        "type": "text",
        "id": "asking_questions_intro",
        "title": "Asking About Home",
        "content": "Let's learn how to ask questions about where someone lives and about their home. These are very useful in conversations!",
        "examples": [
          "¿Dónde vives? (Where do you live?)",
          "¿En qué piso vives? (What floor do you live on?)",
          "¿Cuántas habitaciones tiene tu casa? (How many rooms does your house have?)"
        ]
      },
      {
        "type": "example",
        "id": "asking_questions_example_1",
        "spanish_example": "A: ¿Dónde vives? / B: Vivo en un apartamento en el centro.",
        "english_translation": "A: Where do you live? / B: I live in an apartment in the center.",
        "explanation": "'¿Dónde vives?' is a common question. Answer with 'Vivo en...' (I live in...)."
      },
      {
        "type": "exercise",
        "id": "asking_questions_exercise_1",
        "question": "How do you ask 'Where do you live?' in Spanish?",
        "options": [
          {"text": "¿Dónde vives?", "is_correct": true},
          {"text": "¿Dónde está tu casa?", "is_correct": false},
          {"text": "¿Vives dónde?", "is_correct": false},
          {"text": "¿Cuál es tu casa?", "is_correct": false}
        ],
        "explanation": "'¿Dónde vives?' is the correct way to ask where someone lives. 'Vives' comes from the verb 'vivir' (to live)."
      },
      {
        "type": "text",
        "id": "putting_it_together",
        "title": "Putting It All Together",
        "content": "Now you can describe your home and ask others about theirs! Practice using all the vocabulary you've learned about rooms, furniture, and descriptions.",
        "examples": [
          "Describing your home: 'Mi casa es grande y tiene cuatro habitaciones' (My house is big and has four bedrooms)",
          "Describing a room: 'La cocina es moderna y tiene una ventana grande' (The kitchen is modern and has a large window)",
          "Asking about location: '¿Dónde está el baño?' (Where is the bathroom?)"
        ]
      },
      {
        "type": "matching",
        "id": "comprehensive_matching_1",
        "instruction": "Match the Spanish words with their English translations",
        "pairs": [
          {"word": "casa", "translation": "house"},
          {"word": "habitación", "translation": "bedroom"},
          {"word": "mesa", "translation": "table"},
          {"word": "ventana", "translation": "window"},
          {"word": "grande", "translation": "big"},
          {"word": "limpio", "translation": "clean"},
          {"word": "encima de", "translation": "on top of"},
          {"word": "al lado de", "translation": "next to"}
        ],
        "distractors": ["door", "small"],
        "explanation": "Fantastic! You've mastered vocabulary for the home and describing places. Keep practicing to remember all these words!"
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "Complete: 'Mi ___ es pequeña pero muy ___' (My apartment is small but very comfortable)",
        "options": [
          {"text": "casa, cómoda", "is_correct": true},
          {"text": "habitación, grande", "is_correct": false},
          {"text": "casa, sucia", "is_correct": false},
          {"text": "habitación, fea", "is_correct": false}
        ],
        "explanation": "'Casa' (house/apartment) and 'cómoda' (comfortable) fit the context. Remember adjectives must agree with the noun's gender."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "How would you say 'The lamp is on the table'?",
        "options": [
          {"text": "La lámpara está encima de la mesa", "is_correct": true},
          {"text": "La lámpara está debajo de la mesa", "is_correct": false},
          {"text": "La lámpara está al lado de la mesa", "is_correct": false},
          {"text": "La lámpara es encima de la mesa", "is_correct": false}
        ],
        "explanation": "'Está encima de' means 'is on top of'. We use 'está' (from 'estar') to describe location, not 'es' (from 'ser')."
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'spanish_casa',
    'spanish_apartamento',
    'spanish_cuarto',
    'spanish_habitacion',
    'spanish_sala',
    'spanish_salon',
    'spanish_cocina',
    'spanish_banio',
    'spanish_comedor',
    'spanish_jardin',
    'spanish_mesa',
    'spanish_silla',
    'spanish_sofá',
    'spanish_cama',
    'spanish_armario',
    'spanish_escritorio',
    'spanish_estanteria',
    'spanish_lampara',
    'spanish_ventana',
    'spanish_puerta',
    'spanish_televisor',
    'spanish_refrigerador',
    'spanish_cocina_stove',
    'spanish_grande',
    'spanish_pequeno',
    'spanish_bonito',
    'spanish_feo',
    'spanish_moderno',
    'spanish_viejo',
    'spanish_nuevo',
    'spanish_limpio',
    'spanish_sucio',
    'spanish_comodo',
    'spanish_en',
    'spanish_debajo_de',
    'spanish_encima_de',
    'spanish_al_lado_de',
    'spanish_detras_de',
    'spanish_delante_de',
    'spanish_donde_vives',
    'spanish_en_que_piso',
    'spanish_cuantas_habitaciones'
  ]::TEXT[],
  ARRAY['home_vocabulary', 'furniture', 'describing_places', 'prepositions', 'estar_vs_ser']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  level = EXCLUDED.level,
  updated_at = NOW();

