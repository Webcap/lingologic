-- A1 English Lesson: Basic Greetings and Introductions
-- This lesson teaches fundamental English greetings and how to introduce yourself

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Greetings
('english_hello', 'english', 'hello', 'hello', 'greetings'),
('english_hi', 'english', 'hi', 'hi', 'greetings'),
('english_good_morning', 'english', 'good morning', 'good morning', 'greetings'),
('english_good_afternoon', 'english', 'good afternoon', 'good afternoon', 'greetings'),
('english_good_evening', 'english', 'good evening', 'good evening', 'greetings'),
('english_good_night', 'english', 'good night', 'good night', 'greetings'),
('english_goodbye', 'english', 'goodbye', 'goodbye', 'greetings'),
('english_bye', 'english', 'bye', 'bye', 'greetings'),
('english_see_you_later', 'english', 'see you later', 'see you later', 'greetings'),
-- Introductions
('english_i_am', 'english', 'I am', 'I am', 'introductions'),
('english_my_name_is', 'english', 'my name is', 'my name is', 'introductions'),
('english_nice_to_meet_you', 'english', 'nice to meet you', 'nice to meet you', 'introductions'),
('english_pleased_to_meet_you', 'english', 'pleased to meet you', 'pleased to meet you', 'introductions'),
('english_how_are_you', 'english', 'how are you?', 'how are you?', 'greetings'),
('english_fine', 'english', 'fine', 'fine', 'greetings'),
('english_well', 'english', 'well', 'well', 'greetings'),
('english_thank_you', 'english', 'thank you', 'thank you', 'greetings'),
('english_thanks', 'english', 'thanks', 'thanks', 'greetings'),
('english_you', 'english', 'you', 'you', 'conversation'),
('english_and_you', 'english', 'and you?', 'and you?', 'conversation'),
('english_what_is_your_name', 'english', 'what is your name?', 'what is your name?', 'introductions')
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
  'english_a1_greetings_introductions',
  'Greetings and Introductions',
  'Learn the basics of English greetings and how to introduce yourself. Perfect for absolute beginners!',
  'english',
  'vocabulary',
  'A1',
  1,
  18,
  $lesson_json${
    "translations": {
      "es": {
        "title": "Saludos y Presentaciones",
        "description": "Aprende los conceptos básicos de los saludos en inglés y cómo presentarte. ¡Perfecto para principiantes absolutos!"
      }
    },
    "sections": [
      {
        "type": "text",
        "id": "greetings_intro",
        "title": "Basic Greetings",
        "content": "Let's start with the most essential English greetings! Greetings are the first words you'll use when meeting someone. In English, there are different greetings depending on the time of day and how formal you want to be.",
        "examples": [
          "Use 'good morning' before 12 PM (noon)",
          "Use 'good afternoon' from 12 PM to around 5 PM",
          "Use 'good evening' from around 5 PM to 9 PM",
          "'Hello' and 'Hi' can be used at any time of day!"
        ],
        "translations": {
          "es": {
            "title": "Saludos Básicos",
            "content": "¡Comencemos con los saludos en inglés más esenciales! Los saludos son las primeras palabras que usarás al conocer a alguien. En inglés, hay diferentes saludos dependiendo de la hora del día y qué tan formal quieras ser.",
            "examples": [
              "Usa 'good morning' antes de las 12 PM (mediodía)",
              "Usa 'good afternoon' desde las 12 PM hasta alrededor de las 5 PM",
              "Usa 'good evening' desde alrededor de las 5 PM hasta las 9 PM",
              "¡'Hello' y 'Hi' pueden usarse a cualquier hora del día!"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "greeting_example_1",
        "spanish_example": "Buenos días. ¿Cómo estás?",
        "english_translation": "Good morning. How are you?",
        "explanation": "This is a friendly and polite greeting you might use in the morning. 'Good morning' is more formal than 'hello' or 'hi'.",
        "translations": {
          "es": {
            "explanation": "Este es un saludo amable y cortés que puedes usar por la mañana. 'Good morning' es más formal que 'hello' o 'hi'."
          }
        }
      },
      {
        "type": "example",
        "id": "greeting_example_2",
        "spanish_example": "¡Hola! Estoy bien, gracias. ¿Y tú?",
        "english_translation": "Hi! I'm fine, thank you. And you?",
        "explanation": "A common casual response when someone asks how you are. 'Hi' is informal and friendly. 'I'm' is short for 'I am'.",
        "translations": {
          "es": {
            "explanation": "Una respuesta común y casual cuando alguien te pregunta cómo estás. 'Hi' es informal y amigable. 'I'm' es la abreviación de 'I am'."
          }
        }
      },
      {
        "type": "example",
        "id": "greeting_example_3",
        "spanish_example": "Hola, ¿cómo estás hoy?",
        "english_translation": "Hello, how are you doing today?",
        "explanation": "A friendly greeting using 'how are you doing?' which is similar to 'how are you?' but slightly more casual.",
        "translations": {
          "es": {
            "explanation": "Un saludo amable usando 'how are you doing?' que es similar a 'how are you?' pero ligeramente más casual."
          }
        }
      },
      {
        "type": "exercise",
        "id": "greeting_exercise_1",
        "question": "What greeting should you use at 3:00 PM?",
        "options": [
          {"text": "Good afternoon", "is_correct": true},
          {"text": "Good morning", "is_correct": false},
          {"text": "Good evening", "is_correct": false},
          {"text": "Good night", "is_correct": false}
        ],
        "explanation": "After noon (12 PM) and before evening, you use 'good afternoon'.",
        "translations": {
          "es": {
            "question": "¿Qué saludo deberías usar a las 3:00 PM?",
            "options": [
              {"text": "Good afternoon", "is_correct": true},
              {"text": "Good morning", "is_correct": false},
              {"text": "Good evening", "is_correct": false},
              {"text": "Good night", "is_correct": false}
            ],
            "explanation": "Después del mediodía (12 PM) y antes del anochecer, usas 'good afternoon'."
          }
        }
      },
      {
        "type": "exercise",
        "id": "greeting_exercise_2",
        "question": "Which greeting can be used at any time of day?",
        "options": [
          {"text": "Hello", "is_correct": true},
          {"text": "Good morning", "is_correct": false},
          {"text": "Good night", "is_correct": false},
          {"text": "Good afternoon", "is_correct": false}
        ],
        "explanation": "'Hello' and 'Hi' are versatile greetings that work at any time of day.",
        "translations": {
          "es": {
            "question": "¿Qué saludo se puede usar a cualquier hora del día?",
            "options": [
              {"text": "Hello", "is_correct": true},
              {"text": "Good morning", "is_correct": false},
              {"text": "Good night", "is_correct": false},
              {"text": "Good afternoon", "is_correct": false}
            ],
            "explanation": "'Hello' y 'Hi' son saludos versátiles que funcionan a cualquier hora del día."
          }
        }
      },
      {
        "type": "text",
        "id": "introductions_intro",
        "title": "Introducing Yourself",
        "content": "Now let's learn how to introduce yourself! In English, there are a few different ways to tell someone your name. The most common ways are 'My name is...' or 'I am...' (which can be shortened to 'I'm...').",
        "examples": [
          "'My name is Sarah' means 'My name is Sarah'",
          "'I'm John' means 'I am John' (I'm is short for I am)",
          "After introducing yourself, say 'Nice to meet you' or 'Pleased to meet you'"
        ],
        "translations": {
          "es": {
            "title": "Presentarte",
            "content": "¡Ahora aprendamos cómo presentarte! En inglés, hay algunas formas diferentes de decirle a alguien tu nombre. Las formas más comunes son 'My name is...' o 'I am...' (que se puede abreviar como 'I'm...').",
            "examples": [
              "'My name is Sarah' significa 'Mi nombre es Sarah'",
              "'I'm John' significa 'Yo soy John' (I'm es la abreviación de I am)",
              "Después de presentarte, di 'Nice to meet you' o 'Pleased to meet you'"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "introduction_example_1",
        "spanish_example": "Hola, mi nombre es Emma. ¿Cuál es tu nombre?",
        "english_translation": "Hello, my name is Emma. What's your name?",
        "explanation": "This is a friendly and clear way to introduce yourself and ask for someone's name. 'What's' is short for 'What is'.",
        "translations": {
          "es": {
            "explanation": "Esta es una forma amable y clara de presentarte y preguntar el nombre de alguien. 'What's' es la abreviación de 'What is'."
          }
        }
      },
      {
        "type": "example",
        "id": "introduction_example_2",
        "spanish_example": "Hola, soy Michael. ¡Encantado de conocerte!",
        "english_translation": "Hi, I'm Michael. Nice to meet you!",
        "explanation": "A casual introduction using the contraction 'I'm' (I am). 'Nice to meet you' is a friendly response after someone introduces themselves.",
        "translations": {
          "es": {
            "explanation": "Una presentación casual usando la contracción 'I'm' (I am). 'Nice to meet you' es una respuesta amigable después de que alguien se presenta."
          }
        }
      },
      {
        "type": "example",
        "id": "introduction_example_3",
        "spanish_example": "Buenos días. Mi nombre es David. Encantado de conocerte.",
        "english_translation": "Good morning. My name is David. Pleased to meet you.",
        "explanation": "A more formal introduction. 'Pleased to meet you' is slightly more formal than 'Nice to meet you'.",
        "translations": {
          "es": {
            "explanation": "Una presentación más formal. 'Pleased to meet you' es ligeramente más formal que 'Nice to meet you'."
          }
        }
      },
      {
        "type": "exercise",
        "id": "introduction_exercise_1",
        "question": "How do you say 'Nice to meet you' in English?",
        "options": [
          {"text": "Nice to meet you", "is_correct": true},
          {"text": "How are you", "is_correct": false},
          {"text": "See you later", "is_correct": false},
          {"text": "Good morning", "is_correct": false}
        ],
        "explanation": "'Nice to meet you' is the standard phrase used when meeting someone for the first time.",
        "translations": {
          "es": {
            "question": "¿Cómo se dice 'Encantado de conocerte' en inglés?",
            "options": [
              {"text": "Nice to meet you", "is_correct": true},
              {"text": "How are you", "is_correct": false},
              {"text": "See you later", "is_correct": false},
              {"text": "Good morning", "is_correct": false}
            ],
            "explanation": "'Nice to meet you' es la frase estándar que se usa cuando conoces a alguien por primera vez."
          }
        }
      },
      {
        "type": "exercise",
        "id": "introduction_exercise_2",
        "question": "Complete the sentence: 'Hello, ___ name is Lisa.'",
        "options": [
          {"text": "my", "is_correct": true},
          {"text": "I", "is_correct": false},
          {"text": "you", "is_correct": false},
          {"text": "me", "is_correct": false}
        ],
        "explanation": "The correct phrase is 'My name is...' when introducing yourself.",
        "translations": {
          "es": {
            "question": "Completa la oración: 'Hello, ___ name is Lisa.'",
            "options": [
              {"text": "my", "is_correct": true},
              {"text": "I", "is_correct": false},
              {"text": "you", "is_correct": false},
              {"text": "me", "is_correct": false}
            ],
            "explanation": "La frase correcta es 'My name is...' cuando te presentas."
          }
        }
      },
      {
        "type": "text",
        "id": "conversation_intro",
        "title": "Starting a Conversation",
        "content": "A typical conversation in English often starts with a greeting, then introductions, and asking how someone is. Here's how to put it all together!",
        "examples": [
          "Start with a greeting: 'Hello' or 'Hi'",
          "Introduce yourself: 'My name is...' or 'I'm...'",
          "Ask how they are: 'How are you?'",
          "Respond politely: 'Fine, thank you. And you?'"
        ],
        "translations": {
          "es": {
            "title": "Iniciar una Conversación",
            "content": "Una conversación típica en inglés a menudo comienza con un saludo, luego presentaciones, y preguntando cómo está alguien. ¡Aquí está cómo juntarlo todo!",
            "examples": [
              "Comienza con un saludo: 'Hello' o 'Hi'",
              "Preséntate: 'My name is...' o 'I'm...'",
              "Pregunta cómo están: 'How are you?'",
              "Responde cortésmente: 'Fine, thank you. And you?'"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "conversation_example_1",
        "spanish_example": "A: Hola, mi nombre es Sophia. ¿Cuál es tu nombre?\nB: Hola, soy James. ¡Encantado de conocerte!\nA: Encantada de conocerte también. ¿Cómo estás?\nB: Estoy bien, gracias. ¿Y tú?\nA: Estoy bien, ¡gracias!",
        "english_translation": "A: Hello, my name is Sophia. What's your name?\nB: Hi, I'm James. Nice to meet you!\nA: Nice to meet you too. How are you?\nB: I'm fine, thanks. And you?\nA: I'm well, thank you!",
        "explanation": "A complete conversation showing greetings, introductions, and checking on each other. Notice how 'Nice to meet you too' is used to respond when someone says 'Nice to meet you' first.",
        "translations": {
          "es": {
            "explanation": "Una conversación completa que muestra saludos, presentaciones y preguntándose cómo están. Nota cómo 'Nice to meet you too' se usa para responder cuando alguien dice 'Nice to meet you' primero."
          }
        }
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "What is a complete way to introduce yourself?",
        "options": [
          {"text": "Hello, my name is Tom. Nice to meet you.", "is_correct": true},
          {"text": "Goodbye. See you later.", "is_correct": false},
          {"text": "How are you? Fine.", "is_correct": false},
          {"text": "Hello. Thank you.", "is_correct": false}
        ],
        "explanation": "A complete introduction includes a greeting ('Hello'), your name ('my name is...'), and a polite closing ('Nice to meet you').",
        "translations": {
          "es": {
            "question": "¿Cuál es una forma completa de presentarte?",
            "options": [
              {"text": "Hello, my name is Tom. Nice to meet you.", "is_correct": true},
              {"text": "Goodbye. See you later.", "is_correct": false},
              {"text": "How are you? Fine.", "is_correct": false},
              {"text": "Hello. Thank you.", "is_correct": false}
            ],
            "explanation": "Una presentación completa incluye un saludo ('Hello'), tu nombre ('my name is...'), y un cierre cortés ('Nice to meet you')."
          }
        }
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "How would you respond to 'How are you?' in a positive way?",
        "options": [
          {"text": "I'm fine, thank you. And you?", "is_correct": true},
          {"text": "My name is John", "is_correct": false},
          {"text": "Good morning", "is_correct": false},
          {"text": "See you later", "is_correct": false}
        ],
        "explanation": "When asked 'How are you?', you typically respond with your state (like 'I'm fine' or 'I'm well'), say 'thank you', and then ask them back with 'And you?'",
        "translations": {
          "es": {
            "question": "¿Cómo responderías a 'How are you?' de manera positiva?",
            "options": [
              {"text": "I'm fine, thank you. And you?", "is_correct": true},
              {"text": "My name is John", "is_correct": false},
              {"text": "Good morning", "is_correct": false},
              {"text": "See you later", "is_correct": false}
            ],
            "explanation": "Cuando te preguntan 'How are you?', típicamente respondes con tu estado (como 'I'm fine' o 'I'm well'), dices 'thank you', y luego les preguntas de vuelta con 'And you?'"
          }
        }
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_3",
        "question": "Which is the most casual way to say goodbye?",
        "options": [
          {"text": "Bye", "is_correct": true},
          {"text": "Good night", "is_correct": false},
          {"text": "Good evening", "is_correct": false},
          {"text": "Good morning", "is_correct": false}
        ],
        "explanation": "'Bye' is the most casual and commonly used way to say goodbye. 'Goodbye' is slightly more formal, and 'Good night' is used specifically in the evening or before sleeping.",
        "translations": {
          "es": {
            "question": "¿Cuál es la forma más casual de decir adiós?",
            "options": [
              {"text": "Bye", "is_correct": true},
              {"text": "Good night", "is_correct": false},
              {"text": "Good evening", "is_correct": false},
              {"text": "Good morning", "is_correct": false}
            ],
            "explanation": "'Bye' es la forma más casual y comúnmente usada de decir adiós. 'Goodbye' es ligeramente más formal, y 'Good night' se usa específicamente en la noche o antes de dormir."
          }
        }
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'english_hello',
    'english_hi',
    'english_good_morning',
    'english_good_afternoon',
    'english_good_evening',
    'english_good_night',
    'english_goodbye',
    'english_bye',
    'english_see_you_later',
    'english_i_am',
    'english_my_name_is',
    'english_nice_to_meet_you',
    'english_pleased_to_meet_you',
    'english_how_are_you',
    'english_fine',
    'english_well',
    'english_thank_you',
    'english_thanks',
    'english_you',
    'english_and_you',
    'english_what_is_your_name'
  ]::TEXT[],
  ARRAY['basic_greetings', 'introductions', 'starting_conversations']::TEXT[]
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

