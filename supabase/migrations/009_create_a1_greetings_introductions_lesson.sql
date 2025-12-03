-- A1 Lesson: Basic Greetings, Introductions, and Origins
-- This lesson teaches fundamental Spanish greetings, how to introduce yourself, and talking about where you're from

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Greetings
('spanish_hola', 'spanish', 'hola', 'hello', 'greetings'),
('spanish_buenos_dias', 'spanish', 'buenos días', 'good morning', 'greetings'),
('spanish_buenas_tardes', 'spanish', 'buenas tardes', 'good afternoon', 'greetings'),
('spanish_buenas_noches', 'spanish', 'buenas noches', 'good evening/night', 'greetings'),
('spanish_adios', 'spanish', 'adiós', 'goodbye', 'greetings'),
('spanish_hasta_luego', 'spanish', 'hasta luego', 'see you later', 'greetings'),
-- Introductions
('spanish_yo_soy', 'spanish', 'yo soy', 'I am', 'introductions'),
('spanish_me_llamo', 'spanish', 'me llamo', 'my name is', 'introductions'),
('spanish_mucho_gusto', 'spanish', 'mucho gusto', 'nice to meet you', 'introductions'),
('spanish_encantado', 'spanish', 'encantado', 'pleased to meet you', 'introductions'),
('spanish_como_estas', 'spanish', '¿cómo estás?', 'how are you?', 'greetings'),
('spanish_bien', 'spanish', 'bien', 'well', 'greetings'),
('spanish_gracias', 'spanish', 'gracias', 'thank you', 'greetings'),
-- Origins
('spanish_soy_de', 'spanish', 'soy de', 'I am from', 'origins'),
('spanish_vengo_de', 'spanish', 'vengo de', 'I come from', 'origins'),
('spanish_estados_unidos', 'spanish', 'Estados Unidos', 'United States', 'places'),
('spanish_espana', 'spanish', 'España', 'Spain', 'places'),
('spanish_mexico', 'spanish', 'México', 'Mexico', 'places'),
('spanish_colombia', 'spanish', 'Colombia', 'Colombia', 'places'),
('spanish_y_tu', 'spanish', '¿y tú?', 'and you?', 'conversation')
ON CONFLICT (id) DO NOTHING;

-- Create the A1 lesson with comprehensive content
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
  'spanish_a1_greetings_introductions',
  'Greetings, Introductions, and Origins',
  'Learn the basics of Spanish greetings, how to introduce yourself, and talk about where you''re from. Perfect for absolute beginners!',
  'spanish',
  'vocabulary',
  'A1',
  1,
  20,
  $lesson_json${
    "sections": [
      {
        "type": "text",
        "id": "greetings_intro",
        "title": "Basic Greetings",
        "content": "Let's start with the most essential Spanish greetings! Greetings are the first words you'll use when meeting someone. There are different greetings depending on the time of day.",
        "examples": [
          "Use 'buenos días' in the morning (until around 12 PM)",
          "Use 'buenas tardes' in the afternoon (from 12 PM to around 7 PM)",
          "Use 'buenas noches' in the evening and night (after 7 PM)",
          "'Hola' can be used at any time of day!"
        ]
      },
      {
        "type": "example",
        "id": "greeting_example_1",
        "spanish_example": "Buenos días. ¿Cómo estás?",
        "english_translation": "Good morning. How are you?",
        "explanation": "This is a friendly greeting you might use in the morning. Notice the question mark at the beginning of the question in Spanish."
      },
      {
        "type": "example",
        "id": "greeting_example_2",
        "spanish_example": "Hola, muy bien gracias. ¿Y tú?",
        "english_translation": "Hello, very well thank you. And you?",
        "explanation": "A common response when someone asks how you are. 'Muy bien' means 'very well' and '¿y tú?' is how you ask the same question back."
      },
      {
        "type": "exercise",
        "id": "greeting_exercise_1",
        "question": "What greeting should you use at 10:00 AM?",
        "options": [
          {"text": "Buenos días", "is_correct": true},
          {"text": "Buenas tardes", "is_correct": false},
          {"text": "Buenas noches", "is_correct": false},
          {"text": "Hola solamente", "is_correct": false}
        ],
        "explanation": "Before noon (12 PM), you use 'buenos días' which means 'good morning'."
      },
      {
        "type": "text",
        "id": "introductions_intro",
        "title": "Introducing Yourself",
        "content": "Now let's learn how to introduce yourself! In Spanish, there are a few different ways to tell someone your name. The most common ways are 'Me llamo...' (My name is...) or 'Yo soy...' (I am...).",
        "examples": [
          "'Me llamo María' means 'My name is María'",
          "'Yo soy Juan' means 'I am Juan'",
          "After introducing yourself, say 'Mucho gusto' (Nice to meet you)"
        ]
      },
      {
        "type": "example",
        "id": "introduction_example_1",
        "spanish_example": "Hola, me llamo Ana. ¿Cómo te llamas?",
        "english_translation": "Hello, my name is Ana. What is your name?",
        "explanation": "This is a friendly way to introduce yourself and ask for someone's name. '¿Cómo te llamas?' literally means 'How do you call yourself?'"
      },
      {
        "type": "example",
        "id": "introduction_example_2",
        "spanish_example": "Mucho gusto, Ana. Yo soy Carlos.",
        "english_translation": "Nice to meet you, Ana. I am Carlos.",
        "explanation": "A typical response after someone introduces themselves. 'Mucho gusto' shows politeness and friendliness."
      },
      {
        "type": "exercise",
        "id": "introduction_exercise_1",
        "question": "How do you say 'Nice to meet you' in Spanish?",
        "options": [
          {"text": "Mucho gusto", "is_correct": true},
          {"text": "Cómo estás", "is_correct": false},
          {"text": "Hasta luego", "is_correct": false},
          {"text": "Buenos días", "is_correct": false}
        ],
        "explanation": "'Mucho gusto' is the standard phrase used when meeting someone for the first time."
      },
      {
        "type": "text",
        "id": "origins_intro",
        "title": "Talking About Where You're From",
        "content": "An important part of introductions is telling people where you're from. In Spanish, you can say 'Soy de...' (I am from...) or 'Vengo de...' (I come from...). Both are correct, but 'Soy de' is more commonly used.",
        "examples": [
          "'Soy de Estados Unidos' means 'I am from the United States'",
          "'Soy de España' means 'I am from Spain'",
          "You can ask someone where they're from with '¿De dónde eres?'"
        ]
      },
      {
        "type": "example",
        "id": "origins_example_1",
        "spanish_example": "Hola, me llamo Sofía. Soy de México. ¿De dónde eres tú?",
        "english_translation": "Hello, my name is Sofía. I am from Mexico. Where are you from?",
        "explanation": "A complete introduction including your name and where you're from, followed by asking the same question to the other person."
      },
      {
        "type": "example",
        "id": "origins_example_2",
        "spanish_example": "Yo soy de Colombia. Encantado de conocerte.",
        "english_translation": "I am from Colombia. Pleased to meet you.",
        "explanation": "Another way to respond, using 'encantado' (pleased/delighted) which is especially common in Spain."
      },
      {
        "type": "exercise",
        "id": "origins_exercise_1",
        "question": "Complete the sentence: 'Yo ___ de España'",
        "options": [
          {"text": "soy", "is_correct": true},
          {"text": "estoy", "is_correct": false},
          {"text": "tengo", "is_correct": false},
          {"text": "voy", "is_correct": false}
        ],
        "explanation": "'Soy' comes from the verb 'ser' (to be) and is used to indicate origin or identity. 'Soy de' means 'I am from'."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "What is the correct way to introduce yourself and say where you're from?",
        "options": [
          {"text": "Me llamo David. Soy de Estados Unidos. Mucho gusto.", "is_correct": true},
          {"text": "Buenos días. Adiós.", "is_correct": false},
          {"text": "Cómo estás. Gracias.", "is_correct": false},
          {"text": "Hasta luego. Bien.", "is_correct": false}
        ],
        "explanation": "A complete introduction includes your name ('Me llamo...'), where you're from ('Soy de...'), and a polite closing like 'Mucho gusto'."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "How would you respond to '¿De dónde eres?' if you are from Colombia?",
        "options": [
          {"text": "Soy de Colombia", "is_correct": true},
          {"text": "Me llamo Colombia", "is_correct": false},
          {"text": "Bien, gracias", "is_correct": false},
          {"text": "Mucho gusto", "is_correct": false}
        ],
        "explanation": "When asked where you're from ('¿De dónde eres?'), you respond with 'Soy de...' followed by the country name."
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'spanish_hola',
    'spanish_buenos_dias',
    'spanish_buenas_tardes',
    'spanish_buenas_noches',
    'spanish_adios',
    'spanish_hasta_luego',
    'spanish_yo_soy',
    'spanish_me_llamo',
    'spanish_mucho_gusto',
    'spanish_encantado',
    'spanish_como_estas',
    'spanish_bien',
    'spanish_gracias',
    'spanish_soy_de',
    'spanish_vengo_de',
    'spanish_estados_unidos',
    'spanish_espana',
    'spanish_mexico',
    'spanish_colombia',
    'spanish_y_tu'
  ]::TEXT[],
  ARRAY['basic_greetings', 'introductions', 'talking_about_origin']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  level = EXCLUDED.level,
  updated_at = NOW();

-- Add comment for documentation
COMMENT ON TABLE lessons IS 'Stores lesson content with sections (text, example, exercise) and metadata';

