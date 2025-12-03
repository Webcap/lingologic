-- A1 English Lesson: The Home and Describing Places
-- This lesson teaches vocabulary for rooms, furniture, and how to describe places in English

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Rooms in the House
('english_house', 'english', 'house', 'house', 'home'),
('english_home', 'english', 'home', 'home', 'home'),
('english_apartment', 'english', 'apartment', 'apartment', 'home'),
('english_room', 'english', 'room', 'room', 'home'),
('english_bedroom', 'english', 'bedroom', 'bedroom', 'home'),
('english_living_room', 'english', 'living room', 'living room', 'home'),
('english_kitchen', 'english', 'kitchen', 'kitchen', 'home'),
('english_bathroom', 'english', 'bathroom', 'bathroom', 'home'),
('english_dining_room', 'english', 'dining room', 'dining room', 'home'),
('english_garden', 'english', 'garden', 'garden', 'home'),
-- Furniture and Items
('english_table', 'english', 'table', 'table', 'furniture'),
('english_chair', 'english', 'chair', 'chair', 'furniture'),
('english_sofa', 'english', 'sofa', 'sofa', 'furniture'),
('english_bed', 'english', 'bed', 'bed', 'furniture'),
('english_wardrobe', 'english', 'wardrobe', 'wardrobe', 'furniture'),
('english_closet', 'english', 'closet', 'closet', 'furniture'),
('english_desk', 'english', 'desk', 'desk', 'furniture'),
('english_bookshelf', 'english', 'bookshelf', 'bookshelf', 'furniture'),
('english_lamp', 'english', 'lamp', 'lamp', 'furniture'),
('english_window', 'english', 'window', 'window', 'home'),
('english_door', 'english', 'door', 'door', 'home'),
('english_tv', 'english', 'TV', 'TV', 'furniture'),
('english_refrigerator', 'english', 'refrigerator', 'refrigerator', 'appliances'),
('english_stove', 'english', 'stove', 'stove', 'appliances'),
-- Describing Places
('english_big', 'english', 'big', 'big', 'descriptors'),
('english_large', 'english', 'large', 'large', 'descriptors'),
('english_small', 'english', 'small', 'small', 'descriptors'),
('english_pretty', 'english', 'pretty', 'pretty', 'descriptors'),
('english_nice', 'english', 'nice', 'nice', 'descriptors'),
('english_ugly', 'english', 'ugly', 'ugly', 'descriptors'),
('english_modern', 'english', 'modern', 'modern', 'descriptors'),
('english_old', 'english', 'old', 'old', 'descriptors'),
('english_new', 'english', 'new', 'new', 'descriptors'),
('english_clean', 'english', 'clean', 'clean', 'descriptors'),
('english_dirty', 'english', 'dirty', 'dirty', 'descriptors'),
('english_comfortable', 'english', 'comfortable', 'comfortable', 'descriptors'),
-- Location and Position
('english_in', 'english', 'in', 'in', 'prepositions'),
('english_on', 'english', 'on', 'on', 'prepositions'),
('english_under', 'english', 'under', 'under', 'prepositions'),
('english_below', 'english', 'below', 'below', 'prepositions'),
('english_on_top_of', 'english', 'on top of', 'on top of', 'prepositions'),
('english_next_to', 'english', 'next to', 'next to', 'prepositions'),
('english_beside', 'english', 'beside', 'beside', 'prepositions'),
('english_behind', 'english', 'behind', 'behind', 'prepositions'),
('english_in_front_of', 'english', 'in front of', 'in front of', 'prepositions'),
-- Questions
('english_where_do_you_live', 'english', 'where do you live?', 'where do you live?', 'questions'),
('english_what_floor', 'english', 'what floor do you live on?', 'what floor do you live on?', 'questions'),
('english_how_many_rooms', 'english', 'how many rooms does it have?', 'how many rooms does it have?', 'questions')
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
  'english_a1_home_describing_places',
  'The Home and Describing Places',
  'Learn vocabulary for rooms, furniture, and how to describe your home and other places in English. Essential for talking about where you live!',
  'english',
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
          "house/home (where you live)",
          "bedroom (where you sleep)",
          "kitchen (where you cook)",
          "bathroom (where you wash)",
          "living room (where you relax)"
        ]
      },
      {
        "type": "example",
        "id": "home_example_1",
        "english_example": "I live in a small apartment. It has two bedrooms and a kitchen.",
        "explanation": "Notice how we use 'I live in' to say where you live. We use 'It has' to describe what the apartment contains."
      },
      {
        "type": "example",
        "id": "home_example_2",
        "english_example": "In my house there are three bedrooms, a living room, a kitchen, and two bathrooms.",
        "explanation": "'There are' means something exists. We use it to say what exists in a place. 'There is' is for singular, 'there are' is for plural."
      },
      {
        "type": "matching",
        "id": "rooms_matching_1",
        "instruction": "Match the room names with their descriptions",
        "pairs": [
          {"word": "house", "translation": "a building where people live"},
          {"word": "bedroom", "translation": "room where you sleep"},
          {"word": "kitchen", "translation": "room where you cook"},
          {"word": "bathroom", "translation": "room where you wash"},
          {"word": "living room", "translation": "room where you relax"},
          {"word": "dining room", "translation": "room where you eat"}
        ],
        "distractors": ["garden", "window"],
        "explanation": "Great job! These are the basic room names. 'House' and 'home' can both mean where you live, but 'home' is more personal."
      },
      {
        "type": "exercise",
        "id": "rooms_exercise_1",
        "question": "What do you call the room where you cook?",
        "options": [
          {"text": "kitchen", "is_correct": true},
          {"text": "bedroom", "is_correct": false},
          {"text": "bathroom", "is_correct": false},
          {"text": "living room", "is_correct": false}
        ],
        "explanation": "'Kitchen' is the room where you prepare and cook food. It usually has a stove, refrigerator, and sink."
      },
      {
        "type": "text",
        "id": "furniture_intro",
        "title": "Furniture and Items",
        "content": "Now let's learn the names of common furniture and items you find in a home. These words will help you describe your living space!",
        "examples": [
          "table (for eating or working)",
          "chair (to sit on)",
          "bed (to sleep on)",
          "sofa (comfortable seat)",
          "wardrobe/closet (to store clothes)"
        ]
      },
      {
        "type": "example",
        "id": "furniture_example_1",
        "english_example": "In my bedroom there is a bed, a desk, and a wardrobe.",
        "explanation": "Notice how we use 'there is' for singular items and 'there are' for plural. We say 'a bed' (one bed) or 'two beds' (multiple beds)."
      },
      {
        "type": "matching",
        "id": "furniture_matching_1",
        "instruction": "Match the furniture items with their descriptions",
        "pairs": [
          {"word": "table", "translation": "flat surface for eating or working"},
          {"word": "chair", "translation": "seat with a back"},
          {"word": "bed", "translation": "furniture for sleeping"},
          {"word": "sofa", "translation": "comfortable seat for multiple people"},
          {"word": "wardrobe", "translation": "cabinet for storing clothes"},
          {"word": "desk", "translation": "table for writing or working"}
        ],
        "distractors": ["door", "window"],
        "explanation": "Excellent! You're learning furniture vocabulary. 'Wardrobe' and 'closet' both mean storage for clothes, but 'wardrobe' is a piece of furniture while 'closet' is built into the wall."
      },
      {
        "type": "exercise",
        "id": "furniture_exercise_1",
        "question": "Complete: 'In the living room there is a ___'",
        "options": [
          {"text": "sofa", "is_correct": true},
          {"text": "bed", "is_correct": false},
          {"text": "desk", "is_correct": false},
          {"text": "wardrobe", "is_correct": false}
        ],
        "explanation": "'Sofa' is common in living rooms. It's a comfortable seat where people relax and watch TV."
      },
      {
        "type": "text",
        "id": "describing_intro",
        "title": "Describing Places",
        "content": "Let's learn adjectives to describe rooms and places. These will help you talk about how your home looks and feels!",
        "examples": [
          "big/large vs small (size)",
          "pretty/nice vs ugly (appearance)",
          "modern vs old (age/style)",
          "clean vs dirty (condition)"
        ]
      },
      {
        "type": "example",
        "id": "describing_example_1",
        "english_example": "My apartment is small but very comfortable. The kitchen is modern and clean.",
        "explanation": "Notice how we use 'but' to connect contrasting ideas. Adjectives come before the noun in English: 'small apartment', 'modern kitchen'."
      },
      {
        "type": "matching",
        "id": "describing_matching_1",
        "instruction": "Match the descriptive adjectives with their meanings",
        "pairs": [
          {"word": "big", "translation": "large in size"},
          {"word": "small", "translation": "little in size"},
          {"word": "pretty", "translation": "nice to look at"},
          {"word": "modern", "translation": "new style, up-to-date"},
          {"word": "clean", "translation": "not dirty"},
          {"word": "comfortable", "translation": "pleasant to be in"}
        ],
        "explanation": "Perfect! You're learning descriptive vocabulary. Adjectives in English come before the noun: 'big house', 'clean room', 'comfortable sofa'."
      },
      {
        "type": "exercise",
        "id": "describing_exercise_1",
        "question": "How do you say 'My house is big' in English?",
        "options": [
          {"text": "My house is big", "is_correct": true},
          {"text": "My house big", "is_correct": false},
          {"text": "My big house", "is_correct": false},
          {"text": "My house are big", "is_correct": false}
        ],
        "explanation": "'My house is big' is correct. We use 'is' (not 'are') because 'house' is singular. The verb 'to be' agrees with the subject."
      },
      {
        "type": "text",
        "id": "location_intro",
        "title": "Location and Position",
        "content": "Now let's learn prepositions to describe where things are located. These will help you describe the layout of your home!",
        "examples": [
          "in (inside something)",
          "on (on top of something)",
          "under (below something)",
          "next to/beside (near something)",
          "in front of (ahead of something)"
        ]
      },
      {
        "type": "example",
        "id": "location_example_1",
        "english_example": "The table is in the dining room. The chairs are around the table.",
        "explanation": "'Is in' means located inside. 'Are around' means positioned in a circle or surrounding something."
      },
      {
        "type": "example",
        "id": "location_example_2",
        "english_example": "The sofa is next to the window. The lamp is on the table.",
        "explanation": "Use 'next to' or 'beside' for 'near'. Use 'on' for something sitting on top of another thing."
      },
      {
        "type": "exercise",
        "id": "location_exercise_1",
        "question": "How do you say 'The book is under the table'?",
        "options": [
          {"text": "The book is under the table", "is_correct": true},
          {"text": "The book is on the table", "is_correct": false},
          {"text": "The book is next to the table", "is_correct": false},
          {"text": "The book is in front of the table", "is_correct": false}
        ],
        "explanation": "'Under' means below or beneath something. 'On' would mean on top of the table."
      },
      {
        "type": "text",
        "id": "asking_questions_intro",
        "title": "Asking About Home",
        "content": "Let's learn how to ask questions about where someone lives and about their home. These are very useful in conversations!",
        "examples": [
          "Where do you live?",
          "What floor do you live on?",
          "How many rooms does your house have?"
        ]
      },
      {
        "type": "example",
        "id": "asking_questions_example_1",
        "english_example": "A: Where do you live? / B: I live in an apartment in the city center.",
        "explanation": "'Where do you live?' is a common question. Answer with 'I live in...' followed by the place."
      },
      {
        "type": "exercise",
        "id": "asking_questions_exercise_1",
        "question": "How do you ask 'Where do you live?' in English?",
        "options": [
          {"text": "Where do you live?", "is_correct": true},
          {"text": "Where you live?", "is_correct": false},
          {"text": "Where are you live?", "is_correct": false},
          {"text": "Where is your house?", "is_correct": false}
        ],
        "explanation": "'Where do you live?' is the correct question. We use 'do' as a helping verb with 'live' (not 'are' or 'is')."
      },
      {
        "type": "text",
        "id": "putting_it_together",
        "title": "Putting It All Together",
        "content": "Now you can describe your home and ask others about theirs! Practice using all the vocabulary you've learned about rooms, furniture, and descriptions.",
        "examples": [
          "Describing your home: 'My house is big and has four bedrooms'",
          "Describing a room: 'The kitchen is modern and has a large window'",
          "Asking about location: 'Where is the bathroom?'"
        ]
      },
      {
        "type": "matching",
        "id": "comprehensive_matching_1",
        "instruction": "Match the English words with their meanings",
        "pairs": [
          {"word": "house", "translation": "building where people live"},
          {"word": "bedroom", "translation": "room for sleeping"},
          {"word": "table", "translation": "flat surface for eating"},
          {"word": "window", "translation": "opening with glass in a wall"},
          {"word": "big", "translation": "large in size"},
          {"word": "clean", "translation": "not dirty"},
          {"word": "on top of", "translation": "positioned above"},
          {"word": "next to", "translation": "beside, near"}
        ],
        "distractors": ["door", "small"],
        "explanation": "Fantastic! You've mastered vocabulary for the home and describing places. Keep practicing to remember all these words!"
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "Complete: 'My ___ is small but very ___'",
        "options": [
          {"text": "apartment, comfortable", "is_correct": true},
          {"text": "bedroom, big", "is_correct": false},
          {"text": "house, dirty", "is_correct": false},
          {"text": "kitchen, ugly", "is_correct": false}
        ],
        "explanation": "'Apartment' and 'comfortable' make sense together. An apartment can be small but still comfortable to live in."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "How would you say 'The lamp is on the table'?",
        "options": [
          {"text": "The lamp is on the table", "is_correct": true},
          {"text": "The lamp is under the table", "is_correct": false},
          {"text": "The lamp is next to the table", "is_correct": false},
          {"text": "The lamp are on the table", "is_correct": false}
        ],
        "explanation": "'Is on' means positioned on top of. We use 'is' (not 'are') because 'lamp' is singular."
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'english_house',
    'english_home',
    'english_apartment',
    'english_room',
    'english_bedroom',
    'english_living_room',
    'english_kitchen',
    'english_bathroom',
    'english_dining_room',
    'english_garden',
    'english_table',
    'english_chair',
    'english_sofa',
    'english_bed',
    'english_wardrobe',
    'english_closet',
    'english_desk',
    'english_bookshelf',
    'english_lamp',
    'english_window',
    'english_door',
    'english_tv',
    'english_refrigerator',
    'english_stove',
    'english_big',
    'english_large',
    'english_small',
    'english_pretty',
    'english_nice',
    'english_ugly',
    'english_modern',
    'english_old',
    'english_new',
    'english_clean',
    'english_dirty',
    'english_comfortable',
    'english_in',
    'english_on',
    'english_under',
    'english_below',
    'english_on_top_of',
    'english_next_to',
    'english_beside',
    'english_behind',
    'english_in_front_of',
    'english_where_do_you_live',
    'english_what_floor',
    'english_how_many_rooms'
  ]::TEXT[],
  ARRAY['home_vocabulary', 'furniture', 'describing_places', 'prepositions', 'there_is_there_are']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  level = EXCLUDED.level,
  updated_at = NOW();

