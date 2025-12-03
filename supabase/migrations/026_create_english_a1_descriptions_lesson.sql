-- A1 English Lesson: Descriptions
-- This lesson teaches vocabulary for describing people, objects, and things in English

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Physical Appearance
('english_tall', 'english', 'tall', 'tall', 'descriptions'),
('english_short', 'english', 'short', 'short', 'descriptions'),
('english_thin', 'english', 'thin', 'thin', 'descriptions'),
('english_fat', 'english', 'fat', 'fat', 'descriptions'),
('english_young', 'english', 'young', 'young', 'descriptions'),
('english_old', 'english', 'old', 'old', 'descriptions'),
('english_big', 'english', 'big', 'big', 'descriptions'),
('english_large', 'english', 'large', 'large', 'descriptions'),
('english_small', 'english', 'small', 'small', 'descriptions'),
-- Hair
('english_long_hair', 'english', 'long hair', 'long hair', 'descriptions'),
('english_short_hair', 'english', 'short hair', 'short hair', 'descriptions'),
('english_black_hair', 'english', 'black hair', 'black hair', 'descriptions'),
('english_blonde_hair', 'english', 'blonde hair', 'blonde hair', 'descriptions'),
('english_brown_hair', 'english', 'brown hair', 'brown hair', 'descriptions'),
('english_red_hair', 'english', 'red hair', 'red hair', 'descriptions'),
-- Colors
('english_blue', 'english', 'blue', 'blue', 'descriptions'),
('english_red', 'english', 'red', 'red', 'descriptions'),
('english_green', 'english', 'green', 'green', 'descriptions'),
('english_yellow', 'english', 'yellow', 'yellow', 'descriptions'),
('english_white', 'english', 'white', 'white', 'descriptions'),
('english_black', 'english', 'black', 'black', 'descriptions'),
('english_gray', 'english', 'gray', 'gray', 'descriptions'),
('english_grey', 'english', 'grey', 'grey', 'descriptions'),
('english_orange', 'english', 'orange', 'orange', 'descriptions'),
('english_pink', 'english', 'pink', 'pink', 'descriptions'),
('english_brown', 'english', 'brown', 'brown', 'descriptions'),
('english_purple', 'english', 'purple', 'purple', 'descriptions'),
-- Characteristics
('english_pretty', 'english', 'pretty', 'pretty', 'descriptions'),
('english_ugly', 'english', 'ugly', 'ugly', 'descriptions'),
('english_handsome', 'english', 'handsome', 'handsome', 'descriptions'),
('english_beautiful', 'english', 'beautiful', 'beautiful', 'descriptions'),
('english_intelligent', 'english', 'intelligent', 'intelligent', 'descriptions'),
('english_smart', 'english', 'smart', 'smart', 'descriptions'),
('english_kind', 'english', 'kind', 'kind', 'descriptions'),
('english_friendly', 'english', 'friendly', 'friendly', 'descriptions'),
('english_funny', 'english', 'funny', 'funny', 'descriptions'),
('english_serious', 'english', 'serious', 'serious', 'descriptions'),
('english_quiet', 'english', 'quiet', 'quiet', 'descriptions'),
('english_calm', 'english', 'calm', 'calm', 'descriptions'),
-- Material/Texture
('english_hard', 'english', 'hard', 'hard', 'descriptions'),
('english_soft', 'english', 'soft', 'soft', 'descriptions'),
('english_smooth', 'english', 'smooth', 'smooth', 'descriptions'),
('english_rough', 'english', 'rough', 'rough', 'descriptions'),
-- Temperature
('english_hot', 'english', 'hot', 'hot', 'descriptions'),
('english_cold', 'english', 'cold', 'cold', 'descriptions'),
('english_warm', 'english', 'warm', 'warm', 'descriptions'),
('english_cool', 'english', 'cool', 'cool', 'descriptions'),
-- Common Adjectives
('english_new', 'english', 'new', 'new', 'descriptions'),
('english_easy', 'english', 'easy', 'easy', 'descriptions'),
('english_difficult', 'english', 'difficult', 'difficult', 'descriptions'),
('english_hard_difficult', 'english', 'hard', 'difficult', 'descriptions'),
('english_clean', 'english', 'clean', 'clean', 'descriptions'),
('english_dirty', 'english', 'dirty', 'dirty', 'descriptions'),
('english_nice', 'english', 'nice', 'nice', 'descriptions'),
('english_good', 'english', 'good', 'good', 'descriptions'),
('english_bad', 'english', 'bad', 'bad', 'descriptions'),
-- Questions
('english_what_is_like', 'english', 'what is... like?', 'what is... like?', 'questions'),
('english_what_color', 'english', 'what color...?', 'what color...?', 'questions'),
('english_how_does_look', 'english', 'how does... look?', 'how does... look?', 'questions')
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
  'english_a1_descriptions',
  'Descriptions',
  'Learn to describe people, objects, and things in English. Master adjectives, colors, and physical appearance vocabulary!',
  'english',
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
        "content": "Learning to describe is essential for communication! Let's learn how to describe people, objects, and things in English using adjectives.",
        "examples": [
          "tall (having great height)",
          "short (having little height)",
          "big (large in size)",
          "small (little in size)",
          "pretty (attractive)",
          "intelligent (smart, clever)"
        ]
      },
      {
        "type": "example",
        "id": "physical_appearance_example_1",
        "english_example": "My sister is tall and has long hair. My brother is short and has short hair.",
        "explanation": "Use 'is' for physical characteristics: 'is tall', 'is short'. Use 'has' for hair: 'has long hair', 'has short hair'."
      },
      {
        "type": "matching",
        "id": "physical_appearance_matching_1",
        "instruction": "Match the English adjectives with their meanings",
        "pairs": [
          {"word": "tall", "translation": "having great height"},
          {"word": "short", "translation": "having little height"},
          {"word": "thin", "translation": "not fat, slender"},
          {"word": "fat", "translation": "having a lot of body fat"},
          {"word": "young", "translation": "not old"},
          {"word": "old", "translation": "having lived for many years"}
        ],
        "distractors": ["big", "small"],
        "explanation": "Great! These adjectives describe physical appearance. Use them with 'is' or 'are': 'He is tall', 'They are young'."
      },
      {
        "type": "exercise",
        "id": "physical_appearance_exercise_1",
        "question": "How do you say someone has great height in English?",
        "options": [
          {"text": "tall", "is_correct": true},
          {"text": "short", "is_correct": false},
          {"text": "big", "is_correct": false},
          {"text": "small", "is_correct": false}
        ],
        "explanation": "'Tall' means having great height. Use it with 'is': 'She is tall' or 'He is tall'. 'Big' refers to size, not height."
      },
      {
        "type": "text",
        "id": "colors_intro",
        "title": "Colors",
        "content": "Let's learn colors in English! Colors help us describe what things look like.",
        "examples": [
          "blue (the color of the sky)",
          "red (the color of blood)",
          "green (the color of grass)",
          "yellow (the color of the sun)",
          "white (the color of snow)",
          "black (the color of night)"
        ]
      },
      {
        "type": "example",
        "id": "colors_example_1",
        "english_example": "I have a blue car. My friend has a red purse.",
        "explanation": "Colors come before the noun in English: 'blue car', 'red purse'. Use 'a' or 'an' with singular nouns."
      },
      {
        "type": "pronunciation",
        "id": "colors_pronunciation_1",
        "instruction": "Practice pronouncing these color words",
        "language_code": "en-US",
        "words": [
          {
            "word": "blue",
            "phonetic": "BLOO",
            "translation": "blue"
          },
          {
            "word": "red",
            "phonetic": "RED",
            "translation": "red"
          },
          {
            "word": "green",
            "phonetic": "GREEN",
            "translation": "green"
          },
          {
            "word": "yellow",
            "phonetic": "YEL-oh",
            "translation": "yellow"
          },
          {
            "word": "white",
            "phonetic": "WHITE",
            "translation": "white"
          },
          {
            "word": "black",
            "phonetic": "BLAK",
            "translation": "black"
          }
        ],
        "explanation": "Excellent pronunciation practice! Notice the sounds in each color word. Keep practicing to sound natural!"
      },
      {
        "type": "matching",
        "id": "colors_matching_1",
        "instruction": "Match the English colors with their descriptions",
        "pairs": [
          {"word": "blue", "translation": "the color of the sky"},
          {"word": "red", "translation": "the color of blood"},
          {"word": "green", "translation": "the color of grass"},
          {"word": "yellow", "translation": "the color of the sun"},
          {"word": "white", "translation": "the color of snow"},
          {"word": "black", "translation": "the color of night"},
          {"word": "gray", "translation": "the color between black and white"},
          {"word": "orange", "translation": "the color of an orange fruit"}
        ],
        "distractors": ["brown", "pink"],
        "explanation": "Perfect! You've learned the main colors in English. Remember: colors come before the noun: 'blue car', not 'car blue'."
      },
      {
        "type": "text",
        "id": "hair_descriptions_intro",
        "title": "Describing Hair",
        "content": "Let's learn how to describe hair in English. Use 'has' or 'have' with hair descriptions.",
        "examples": [
          "long hair (hair that is long)",
          "short hair (hair that is short)",
          "black hair (dark hair)",
          "blonde hair (light yellow hair)",
          "brown hair (medium brown hair)"
        ]
      },
      {
        "type": "example",
        "id": "hair_descriptions_example_1",
        "english_example": "Maria has long, blonde hair. John has short, black hair.",
        "explanation": "Use 'has' (he/she/it) or 'have' (I/you/we/they) with hair descriptions. Put color and length together: 'long, blonde hair'."
      },
      {
        "type": "exercise",
        "id": "hair_descriptions_exercise_1",
        "question": "Complete: 'She ___ long hair'",
        "options": [
          {"text": "has", "is_correct": true},
          {"text": "is", "is_correct": false},
          {"text": "have", "is_correct": false},
          {"text": "are", "is_correct": false}
        ],
        "explanation": "'Has' is used with 'she', 'he', and 'it'. 'Have' is used with 'I', 'you', 'we', and 'they'. Use 'has hair' or 'have hair' to describe hair."
      },
      {
        "type": "text",
        "id": "characteristics_intro",
        "title": "Personality and Characteristics",
        "content": "Now let's learn adjectives to describe personality and characteristics!",
        "examples": [
          "intelligent (smart, clever)",
          "kind (nice, caring)",
          "friendly (pleasant, sociable)",
          "funny (humorous)",
          "serious (not joking, solemn)",
          "quiet (making little noise)"
        ]
      },
      {
        "type": "example",
        "id": "characteristics_example_1",
        "english_example": "My teacher is very intelligent and kind. My friend is funny but sometimes he is serious.",
        "explanation": "Use 'is' or 'are' with personality traits. 'Very' means 'a lot'. You can combine adjectives with 'and' or 'but'."
      },
      {
        "type": "pronunciation",
        "id": "characteristics_pronunciation_1",
        "instruction": "Practice pronouncing these personality adjectives",
        "language_code": "en-US",
        "words": [
          {
            "word": "intelligent",
            "phonetic": "in-TEL-i-jent",
            "translation": "intelligent"
          },
          {
            "word": "friendly",
            "phonetic": "FREND-lee",
            "translation": "friendly"
          },
          {
            "word": "funny",
            "phonetic": "FUN-ee",
            "translation": "funny"
          },
          {
            "word": "serious",
            "phonetic": "SEER-ee-us",
            "translation": "serious"
          }
        ],
        "explanation": "Good job! Notice the pronunciation and stress patterns. Practice these to sound more natural in English!"
      },
      {
        "type": "matching",
        "id": "characteristics_matching_1",
        "instruction": "Match the personality adjectives with their meanings",
        "pairs": [
          {"word": "intelligent", "translation": "smart, clever"},
          {"word": "kind", "translation": "nice, caring"},
          {"word": "friendly", "translation": "pleasant, sociable"},
          {"word": "funny", "translation": "humorous"},
          {"word": "serious", "translation": "not joking, solemn"},
          {"word": "quiet", "translation": "making little noise"}
        ],
        "distractors": ["ugly", "tall"],
        "explanation": "Excellent! These adjectives describe personality. Use them with 'is' or 'are': 'She is friendly', 'They are kind'."
      },
      {
        "type": "text",
        "id": "material_texture_intro",
        "title": "Describing Objects: Material and Texture",
        "content": "Let's learn how to describe objects! These adjectives describe what things feel like or are made of.",
        "examples": [
          "hard (not soft, firm)",
          "soft (not hard, gentle to touch)",
          "smooth (not rough, even surface)",
          "rough (not smooth, uneven surface)",
          "hot (high temperature)",
          "cold (low temperature)"
        ]
      },
      {
        "type": "example",
        "id": "material_texture_example_1",
        "english_example": "The bed is soft and smooth. The table is hard.",
        "explanation": "Use 'is' or 'are' to describe characteristics of objects. You can combine adjectives: 'soft and smooth'."
      },
      {
        "type": "exercise",
        "id": "material_texture_exercise_1",
        "question": "How do you say 'not hard, gentle to touch' in English?",
        "options": [
          {"text": "soft", "is_correct": true},
          {"text": "hard", "is_correct": false},
          {"text": "smooth", "is_correct": false},
          {"text": "hot", "is_correct": false}
        ],
        "explanation": "'Soft' means not hard, gentle to touch. 'Smooth' means even surface. Both can describe textures, but 'soft' refers to how something feels when you press it."
      },
      {
        "type": "text",
        "id": "common_adjectives_intro",
        "title": "Common Descriptive Adjectives",
        "content": "Here are some very common adjectives you'll use often to describe things!",
        "examples": [
          "new (not old, recently made)",
          "old (not new, having existed for a long time)",
          "easy (not difficult, simple)",
          "difficult (not easy, hard)",
          "clean (not dirty, free from dirt)",
          "dirty (not clean, covered with dirt)"
        ]
      },
      {
        "type": "example",
        "id": "common_adjectives_example_1",
        "english_example": "I have a new car. The homework is easy. The house is clean.",
        "explanation": "Adjectives come before nouns: 'new car', 'easy homework'. Or use 'is/are' + adjective: 'is easy', 'is clean'."
      },
      {
        "type": "pronunciation",
        "id": "common_adjectives_pronunciation_1",
        "instruction": "Practice pronouncing these common adjectives",
        "language_code": "en-US",
        "words": [
          {
            "word": "new",
            "phonetic": "NOO",
            "translation": "new"
          },
          {
            "word": "easy",
            "phonetic": "EE-zee",
            "translation": "easy"
          },
          {
            "word": "difficult",
            "phonetic": "DIF-i-kult",
            "translation": "difficult"
          },
          {
            "word": "clean",
            "phonetic": "KLEEN",
            "translation": "clean"
          }
        ],
        "explanation": "Great pronunciation! Notice the vowel sounds in these words. Keep practicing to improve your English pronunciation!"
      },
      {
        "type": "text",
        "id": "asking_questions_intro",
        "title": "Asking About Descriptions",
        "content": "Let's learn how to ask about descriptions! These questions help you find out what things are like.",
        "examples": [
          "What is... like? (asking for a description)",
          "What color...? (asking about color)",
          "How does... look? (asking about appearance)"
        ]
      },
      {
        "type": "example",
        "id": "asking_questions_example_1",
        "english_example": "A: What is your sister like? / B: She is tall and has blonde hair.",
        "explanation": "'What is... like?' asks for a description of someone or something. Answer with 'is/are' + adjectives and characteristics."
      },
      {
        "type": "exercise",
        "id": "asking_questions_exercise_1",
        "question": "How do you ask 'What color is it?' in English?",
        "options": [
          {"text": "What color is it?", "is_correct": true},
          {"text": "What is the color?", "is_correct": false},
          {"text": "How is the color?", "is_correct": false},
          {"text": "Which color is it?", "is_correct": false}
        ],
        "explanation": "'What color is it?' is the most common way to ask about color. You can also say 'What color is the car?' or 'What color are the shoes?'"
      },
      {
        "type": "text",
        "id": "putting_it_together",
        "title": "Putting It All Together",
        "content": "Now you can describe people, objects, and things in English! Practice combining different types of descriptions.",
        "examples": [
          "Complete description: 'My friend is tall, young, and has short, black hair. He is very intelligent and kind.'",
          "Describing objects: 'I have a new table. It's big and brown. The surface is smooth.'",
          "Asking questions: 'What is your teacher like?' (asking for a description)"
        ]
      },
      {
        "type": "matching",
        "id": "comprehensive_matching_1",
        "instruction": "Match the English description words with their meanings",
        "pairs": [
          {"word": "tall", "translation": "having great height"},
          {"word": "blue", "translation": "the color of the sky"},
          {"word": "intelligent", "translation": "smart, clever"},
          {"word": "new", "translation": "not old, recently made"},
          {"word": "long hair", "translation": "hair that is long"},
          {"word": "pretty", "translation": "attractive"},
          {"word": "easy", "translation": "not difficult, simple"},
          {"word": "kind", "translation": "nice, caring"}
        ],
        "distractors": ["difficult", "ugly"],
        "explanation": "Fantastic! You've learned a comprehensive set of descriptive vocabulary. Keep practicing to remember all these adjectives!"
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "Complete: 'She ___ tall and ___ long hair'",
        "options": [
          {"text": "is, has", "is_correct": true},
          {"text": "has, is", "is_correct": false},
          {"text": "is, is", "is_correct": false},
          {"text": "has, has", "is_correct": false}
        ],
        "explanation": "Use 'is' for characteristics: 'is tall'. Use 'has' for hair: 'has long hair'. Don't mix them up!"
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "How do you ask 'What is he/she/it like?' in English?",
        "options": [
          {"text": "What is... like?", "is_correct": true},
          {"text": "What is...?", "is_correct": false},
          {"text": "How is...?", "is_correct": false},
          {"text": "What does... have?", "is_correct": false}
        ],
        "explanation": "'What is... like?' asks for a description of what someone or something is like. 'How is...?' asks about health or feelings."
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'english_tall',
    'english_short',
    'english_thin',
    'english_fat',
    'english_young',
    'english_old',
    'english_big',
    'english_large',
    'english_small',
    'english_long_hair',
    'english_short_hair',
    'english_black_hair',
    'english_blonde_hair',
    'english_brown_hair',
    'english_red_hair',
    'english_blue',
    'english_red',
    'english_green',
    'english_yellow',
    'english_white',
    'english_black',
    'english_gray',
    'english_grey',
    'english_orange',
    'english_pink',
    'english_brown',
    'english_purple',
    'english_pretty',
    'english_ugly',
    'english_handsome',
    'english_beautiful',
    'english_intelligent',
    'english_smart',
    'english_kind',
    'english_friendly',
    'english_funny',
    'english_serious',
    'english_quiet',
    'english_calm',
    'english_hard',
    'english_soft',
    'english_smooth',
    'english_rough',
    'english_hot',
    'english_cold',
    'english_warm',
    'english_cool',
    'english_new',
    'english_easy',
    'english_difficult',
    'english_hard_difficult',
    'english_clean',
    'english_dirty',
    'english_nice',
    'english_good',
    'english_bad',
    'english_what_is_like',
    'english_what_color',
    'english_how_does_look'
  ]::TEXT[],
  ARRAY['descriptions', 'adjectives', 'colors', 'physical_appearance', 'personality']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  level = EXCLUDED.level,
  updated_at = NOW();

