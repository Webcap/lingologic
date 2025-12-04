-- A2 English Lesson: Vocabulary Expansion (High-Frequency Areas)
-- This lesson expands vocabulary across multiple high-frequency topics with varied exercise types

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Weather
('english_weather', 'english', 'weather', 'weather', 'weather'),
('english_sun', 'english', 'sun', 'sun', 'weather'),
('english_rain', 'english', 'rain', 'rain', 'weather'),
('english_snow', 'english', 'snow', 'snow', 'weather'),
('english_wind', 'english', 'wind', 'wind', 'weather'),
('english_cloudy', 'english', 'cloudy', 'cloudy', 'weather'),
('english_sunny', 'english', 'sunny', 'sunny', 'weather'),
('english_hot', 'english', 'hot', 'hot', 'weather'),
('english_cold', 'english', 'cold', 'cold', 'weather'),
('english_temperature', 'english', 'temperature', 'temperature', 'weather'),
-- Transportation
('english_bus', 'english', 'bus', 'bus', 'transportation'),
('english_train', 'english', 'train', 'train', 'transportation'),
('english_airplane', 'english', 'airplane', 'airplane', 'transportation'),
('english_subway', 'english', 'subway', 'subway', 'transportation'),
('english_taxi', 'english', 'taxi', 'taxi', 'transportation'),
('english_bicycle', 'english', 'bicycle', 'bicycle', 'transportation'),
('english_car', 'english', 'car', 'car', 'transportation'),
('english_station', 'english', 'station', 'station', 'transportation'),
('english_airport', 'english', 'airport', 'airport', 'transportation'),
-- Technology
('english_computer', 'english', 'computer', 'computer', 'technology'),
('english_cell_phone', 'english', 'cell phone', 'cell phone', 'technology'),
('english_internet', 'english', 'internet', 'internet', 'technology'),
('english_email', 'english', 'email', 'email', 'technology'),
('english_app', 'english', 'app', 'app', 'technology'),
('english_social_network', 'english', 'social network', 'social network', 'technology'),
('english_browser', 'english', 'browser', 'browser', 'technology'),
-- Health
('english_health', 'english', 'health', 'health', 'health'),
('english_doctor', 'english', 'doctor', 'doctor', 'health'),
('english_hospital', 'english', 'hospital', 'hospital', 'health'),
('english_pharmacy', 'english', 'pharmacy', 'pharmacy', 'health'),
('english_medicine', 'english', 'medicine', 'medicine', 'health'),
('english_pain', 'english', 'pain', 'pain', 'health'),
('english_illness', 'english', 'illness', 'illness', 'health'),
('english_appointment', 'english', 'appointment', 'appointment', 'health'),
-- Emotions
('english_happy', 'english', 'happy', 'happy', 'emotions'),
('english_sad', 'english', 'sad', 'sad', 'emotions'),
('english_excited', 'english', 'excited', 'excited', 'emotions'),
('english_worried', 'english', 'worried', 'worried', 'emotions'),
('english_angry', 'english', 'angry', 'angry', 'emotions'),
('english_nervous', 'english', 'nervous', 'nervous', 'emotions'),
('english_relaxed', 'english', 'relaxed', 'relaxed', 'emotions'),
('english_surprised', 'english', 'surprised', 'surprised', 'emotions'),
-- Shopping & Services
('english_store', 'english', 'store', 'store/shop', 'shopping'),
('english_supermarket', 'english', 'supermarket', 'supermarket', 'shopping'),
('english_cashier', 'english', 'cashier', 'cashier', 'shopping'),
('english_price', 'english', 'price', 'price', 'shopping'),
('english_discount', 'english', 'discount', 'discount', 'shopping'),
('english_card', 'english', 'card', 'card', 'shopping'),
('english_cash', 'english', 'cash', 'cash', 'shopping'),
-- Entertainment
('english_cinema', 'english', 'cinema', 'cinema', 'entertainment'),
('english_theater', 'english', 'theater', 'theater', 'entertainment'),
('english_music', 'english', 'music', 'music', 'entertainment'),
('english_tv_series', 'english', 'TV series', 'TV series', 'entertainment'),
('english_movie', 'english', 'movie', 'movie', 'entertainment'),
('english_concert', 'english', 'concert', 'concert', 'entertainment')
ON CONFLICT (id) DO NOTHING;

-- Create the A2 English lesson with comprehensive content and varied exercises
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
  'english_a2_vocabulary_expansion',
  'Vocabulary Expansion (High-Frequency Areas)',
  'Expand your English vocabulary across essential everyday topics! Master words for weather, transportation, technology, health, emotions, shopping, and entertainment through varied, engaging exercises.',
  'english',
  'vocabulary',
  'A2',
  3,
  45,
  $lesson_json${
    "translations": {
      "es": {
        "title": "Expansión de Vocabulario (Áreas de Alta Frecuencia)",
        "description": "¡Expande tu vocabulario en inglés a través de temas esenciales cotidianos! Domina palabras sobre el clima, transporte, tecnología, salud, emociones, compras y entretenimiento con ejercicios variados y atractivos."
      }
    },
    "sections": [
      {
        "type": "text",
        "id": "vocab_intro",
        "title": "Expanding Your Vocabulary",
        "content": "Welcome! This lesson covers high-frequency vocabulary across multiple essential topics. You'll learn practical words for everyday situations through a variety of engaging exercises. Let's dive in!",
        "examples": [
          "Weather: 'It's sunny'",
          "Transportation: 'I take the bus'",
          "Technology: 'I send an email'"
        ],
        "translations": {
          "es": {
            "title": "Expandiendo Tu Vocabulario",
            "content": "¡Bienvenido! Esta lección cubre vocabulario de alta frecuencia en múltiples temas esenciales. Aprenderás palabras prácticas para situaciones cotidianas a través de una variedad de ejercicios atractivos. ¡Comencemos!",
            "examples": [
              "Clima: 'It's sunny'",
              "Transporte: 'I take the bus'",
              "Tecnología: 'I send an email'"
            ]
          }
        }
      },
      {
        "type": "matching",
        "id": "weather_matching_1",
        "instruction": "Match the English weather words with their meanings",
        "pairs": [
          {"word": "sun", "translation": "the bright star in the sky"},
          {"word": "rain", "translation": "water falling from clouds"},
          {"word": "snow", "translation": "frozen water falling from sky"},
          {"word": "wind", "translation": "moving air"},
          {"word": "cloudy", "translation": "covered with clouds"},
          {"word": "sunny", "translation": "bright with sunshine"},
          {"word": "hot", "translation": "high temperature"},
          {"word": "cold", "translation": "low temperature"}
        ],
        "distractors": ["weather", "temperature"],
        "explanation": "Excellent! Weather vocabulary is essential for everyday conversations. Remember: 'It's sunny', 'It's cloudy', 'It's hot'. Use 'It's' to describe weather conditions.",
        "translations": {
          "es": {
            "instruction": "Empareja las palabras del clima en inglés con sus significados",
            "explanation": "¡Excelente! El vocabulario del clima es esencial para conversaciones cotidianas. Recuerda: 'It's sunny', 'It's cloudy', 'It's hot'. Usa 'It's' para describir condiciones climáticas."
          }
        }
      },
      {
        "type": "pronunciation",
        "id": "weather_pronunciation",
        "instruction": "Practice pronouncing these weather-related words in English",
        "words": [
          {"word": "weather", "translation": "el clima", "phonetic": "WETH-er"},
          {"word": "temperature", "translation": "temperatura", "phonetic": "TEM-per-a-chur"},
          {"word": "cloudy", "translation": "nublado", "phonetic": "KLOW-dee"},
          {"word": "wind", "translation": "viento", "phonetic": "WIND"},
          {"word": "sunny", "translation": "soleado", "phonetic": "SUN-ee"}
        ],
        "explanation": "Great practice! Pay attention to the 'th' sound in 'weather' and the stress patterns. Keep practicing!",
        "translations": {
          "es": {
            "instruction": "Practica pronunciando estas palabras relacionadas con el clima en inglés",
            "explanation": "¡Gran práctica! Presta atención al sonido 'th' en 'weather' y los patrones de acento. ¡Sigue practicando!"
          }
        }
      },
      {
        "type": "text",
        "id": "transportation_intro",
        "title": "Transportation Vocabulary",
        "content": "Learn essential transportation vocabulary! Whether you're traveling or just getting around town, these words are crucial.",
        "examples": [
          "I take the bus (I use the bus)",
          "I ride the train (I use the train)",
          "I arrive at the airport (I get to the airport)"
        ],
        "translations": {
          "es": {
            "title": "Vocabulario de Transporte",
            "content": "¡Aprende vocabulario esencial de transporte! Ya sea que estés viajando o solo moviéndote por la ciudad, estas palabras son cruciales.",
            "examples": [
              "I take the bus (Yo uso el autobús)",
              "I ride the train (Yo uso el tren)",
              "I arrive at the airport (Llego al aeropuerto)"
            ]
          }
        }
      },
      {
        "type": "exercise",
        "id": "transportation_exercise",
        "question": "How do you say 'I take the subway' in English?",
        "options": [
          {"text": "I take the subway", "is_correct": true},
          {"text": "I take the bus", "is_correct": false},
          {"text": "I take the train", "is_correct": false},
          {"text": "I take the taxi", "is_correct": false}
        ],
        "explanation": "Perfect! 'I take the subway' means you use the subway for transportation. In English, we use 'take' for most forms of transportation: 'take the bus', 'take the train', 'take a taxi'.",
        "translations": {
          "es": {
            "question": "¿Cómo dices 'I take the subway' en inglés?",
            "options": [
              {"text": "I take the subway", "is_correct": true},
              {"text": "I take the bus", "is_correct": false},
              {"text": "I take the train", "is_correct": false},
              {"text": "I take the taxi", "is_correct": false}
            ],
            "explanation": "¡Perfecto! 'I take the subway' significa que usas el metro para transporte. En inglés, usamos 'take' para la mayoría de formas de transporte: 'take the bus', 'take the train', 'take a taxi'."
          }
        }
      },
      {
        "type": "translation",
        "id": "transportation_translation",
        "instruction": "Translate this sentence to English",
        "sentence": "Necesito ir al aeropuerto mañana",
        "correct_answer": "I need to go to the airport tomorrow",
        "language_code": "en",
        "words": [
          {"word": "Necesito", "translation": "I need"},
          {"word": "ir", "translation": "to go"},
          {"word": "aeropuerto", "translation": "airport"},
          {"word": "mañana", "translation": "tomorrow"}
        ],
        "explanation": "Excellent! Notice: 'I need' + 'to' + infinitive verb (to go). In English, we say 'to the airport' - use 'to' for destinations.",
        "translations": {
          "es": {
            "instruction": "Traduce esta oración al inglés",
            "explanation": "¡Excelente! Nota: 'I need' + 'to' + verbo en infinitivo (to go). En inglés, decimos 'to the airport' - usa 'to' para destinos."
          }
        }
      },
      {
        "type": "text",
        "id": "technology_intro",
        "title": "Technology Vocabulary",
        "content": "Modern life requires modern vocabulary! Learn essential technology terms for digital communication and devices.",
        "examples": [
          "I send an email (I send electronic mail)",
          "I use my cell phone (I use my mobile phone)",
          "I browse the internet (I surf the internet)"
        ],
        "translations": {
          "es": {
            "title": "Vocabulario de Tecnología",
            "content": "¡La vida moderna requiere vocabulario moderno! Aprende términos tecnológicos esenciales para la comunicación digital y los dispositivos.",
            "examples": [
              "I send an email (Envío un correo electrónico)",
              "I use my cell phone (Uso mi celular)",
              "I browse the internet (Navego en internet)"
            ]
          }
        }
      },
      {
        "type": "matching",
        "id": "technology_matching",
        "instruction": "Match the English technology terms with their meanings",
        "pairs": [
          {"word": "computer", "translation": "electronic device for work and games"},
          {"word": "cell phone", "translation": "mobile phone device"},
          {"word": "email", "translation": "electronic mail message"},
          {"word": "app", "translation": "application on a phone or computer"},
          {"word": "social network", "translation": "platform for connecting with people"},
          {"word": "browser", "translation": "program for viewing websites"},
          {"word": "internet", "translation": "global network of computers"}
        ],
        "distractors": ["music", "movie"],
        "explanation": "Perfect! Technology vocabulary is constantly evolving, but these are the essential terms. Note: 'email' is short for 'electronic mail', and 'app' is short for 'application'.",
        "translations": {
          "es": {
            "instruction": "Empareja los términos tecnológicos en inglés con sus significados",
            "explanation": "¡Perfecto! El vocabulario tecnológico evoluciona constantemente, pero estos son los términos esenciales. Nota: 'email' es la abreviación de 'electronic mail', y 'app' es la abreviación de 'application'."
          }
        }
      },
      {
        "type": "text",
        "id": "health_intro",
        "title": "Health Vocabulary",
        "content": "Health-related vocabulary is essential for describing how you feel and getting medical help when needed.",
        "examples": [
          "I have an appointment with the doctor (I have a scheduled meeting)",
          "I go to the pharmacy (I visit the pharmacy)",
          "I take medicine (I consume medicine)"
        ],
        "translations": {
          "es": {
            "title": "Vocabulario de Salud",
            "content": "El vocabulario relacionado con la salud es esencial para describir cómo te sientes y obtener ayuda médica cuando la necesitas.",
            "examples": [
              "I have an appointment with the doctor (Tengo una cita con el médico)",
              "I go to the pharmacy (Voy a la farmacia)",
              "I take medicine (Tomo medicina)"
            ]
          }
        }
      },
      {
        "type": "pronunciation",
        "id": "health_pronunciation",
        "instruction": "Practice pronouncing these health-related words",
        "words": [
          {"word": "doctor", "translation": "médico", "phonetic": "DOK-tor"},
          {"word": "pharmacy", "translation": "farmacia", "phonetic": "FAR-ma-see"},
          {"word": "hospital", "translation": "hospital", "phonetic": "HOS-pi-tal"},
          {"word": "illness", "translation": "enfermedad", "phonetic": "IL-ness"},
          {"word": "medicine", "translation": "medicina", "phonetic": "MED-i-sin"}
        ],
        "explanation": "Great job! Pay attention to stress: 'doctor' (stress on 'doc'), 'pharmacy' (stress on 'phar'). Practice these until they feel natural!",
        "translations": {
          "es": {
            "instruction": "Practica pronunciando estas palabras relacionadas con la salud",
            "explanation": "¡Buen trabajo! Presta atención al acento: 'doctor' (acento en 'doc'), 'pharmacy' (acento en 'phar'). ¡Practica estas hasta que se sientan naturales!"
          }
        }
      },
      {
        "type": "exercise",
        "id": "health_exercise",
        "question": "What does 'I have a headache' mean?",
        "options": [
          {"text": "Tengo dolor de cabeza", "is_correct": true},
          {"text": "Tengo dolor de estómago", "is_correct": false},
          {"text": "Tengo una cita", "is_correct": false},
          {"text": "Tomo medicina", "is_correct": false}
        ],
        "explanation": "Correct! 'I have a headache' means your head hurts. The structure is 'I have a + body part ache': 'stomachache' (stomach pain), 'backache' (back pain).",
        "translations": {
          "es": {
            "question": "¿Qué significa 'I have a headache'?",
            "options": [
              {"text": "Tengo dolor de cabeza", "is_correct": true},
              {"text": "Tengo dolor de estómago", "is_correct": false},
              {"text": "Tengo una cita", "is_correct": false},
              {"text": "Tomo medicina", "is_correct": false}
            ],
            "explanation": "¡Correcto! 'I have a headache' significa que te duele la cabeza. La estructura es 'I have a + parte del cuerpo + ache': 'stomachache' (dolor de estómago), 'backache' (dolor de espalda)."
          }
        }
      },
      {
        "type": "text",
        "id": "emotions_intro",
        "title": "Expressing Emotions",
        "content": "Learn vocabulary to express your feelings! Being able to describe emotions is important for authentic conversations.",
        "examples": [
          "I am happy (I feel good)",
          "I feel excited (I feel enthusiastic)",
          "He is worried (He feels concern)"
        ],
        "translations": {
          "es": {
            "title": "Expresar Emociones",
            "content": "¡Aprende vocabulario para expresar tus sentimientos! Ser capaz de describir emociones es importante para conversaciones auténticas.",
            "examples": [
              "I am happy (Estoy feliz)",
              "I feel excited (Me siento emocionado)",
              "He is worried (Él está preocupado)"
            ]
          }
        }
      },
      {
        "type": "translation",
        "id": "emotions_translation",
        "instruction": "Translate this sentence to English",
        "sentence": "Estoy muy emocionado por el viaje",
        "correct_answer": "I am very excited about the trip",
        "language_code": "en",
        "words": [
          {"word": "Estoy", "translation": "I am"},
          {"word": "muy", "translation": "very"},
          {"word": "emocionado", "translation": "excited"},
          {"word": "por", "translation": "about"},
          {"word": "viaje", "translation": "trip"}
        ],
        "explanation": "Excellent! 'I am excited' means you feel enthusiastic. Use 'about' to say what you're excited about. Notice: 'very' comes before the adjective to emphasize.",
        "translations": {
          "es": {
            "instruction": "Traduce esta oración al inglés",
            "explanation": "¡Excelente! 'I am excited' significa que te sientes entusiasta. Usa 'about' para decir de qué estás emocionado. Nota: 'very' viene antes del adjetivo para enfatizar."
          }
        }
      },
      {
        "type": "matching",
        "id": "emotions_matching",
        "instruction": "Match the English emotion words with their meanings",
        "pairs": [
          {"word": "happy", "translation": "feeling good or joyful"},
          {"word": "sad", "translation": "feeling unhappy"},
          {"word": "excited", "translation": "feeling enthusiastic"},
          {"word": "worried", "translation": "feeling concern or anxiety"},
          {"word": "angry", "translation": "feeling mad or upset"},
          {"word": "nervous", "translation": "feeling anxious or uneasy"},
          {"word": "relaxed", "translation": "feeling calm or at ease"},
          {"word": "surprised", "translation": "feeling unexpected shock"}
        ],
        "distractors": ["health", "pain"],
        "explanation": "Perfect! These adjectives describe emotions. Remember: use 'I am' or 'I feel' with these words. For example: 'I am happy', 'I feel excited'.",
        "translations": {
          "es": {
            "instruction": "Empareja las palabras de emociones en inglés con sus significados",
            "explanation": "¡Perfecto! Estos adjetivos describen emociones. Recuerda: usa 'I am' o 'I feel' con estas palabras. Por ejemplo: 'I am happy', 'I feel excited'."
          }
        }
      },
      {
        "type": "text",
        "id": "shopping_intro",
        "title": "Shopping Vocabulary",
        "content": "Essential vocabulary for shopping experiences! From stores to payment methods, learn the words you need.",
        "examples": [
          "I go to the supermarket (I visit the supermarket)",
          "How much does it cost? (What is the price?)",
          "I pay with card (I use a card to pay)"
        ],
        "translations": {
          "es": {
            "title": "Vocabulario de Compras",
            "content": "¡Vocabulario esencial para experiencias de compras! Desde tiendas hasta métodos de pago, aprende las palabras que necesitas.",
            "examples": [
              "I go to the supermarket (Voy al supermercado)",
              "How much does it cost? (¿Cuánto cuesta?)",
              "I pay with card (Pago con tarjeta)"
            ]
          }
        }
      },
      {
        "type": "exercise",
        "id": "shopping_exercise",
        "question": "How do you ask 'How much does it cost?' in English?",
        "options": [
          {"text": "How much does it cost?", "is_correct": true},
          {"text": "Where is it?", "is_correct": false},
          {"text": "What is this?", "is_correct": false},
          {"text": "Do you have this?", "is_correct": false}
        ],
        "explanation": "Perfect! 'How much does it cost?' is the standard way to ask about price. You can also say 'How much is it?' or 'What's the price?'. For plural items, say 'How much do they cost?'",
        "translations": {
          "es": {
            "question": "¿Cómo preguntas 'How much does it cost?' en inglés?",
            "options": [
              {"text": "How much does it cost?", "is_correct": true},
              {"text": "Where is it?", "is_correct": false},
              {"text": "What is this?", "is_correct": false},
              {"text": "Do you have this?", "is_correct": false}
            ],
            "explanation": "¡Perfecto! 'How much does it cost?' es la forma estándar de preguntar sobre el precio. También puedes decir 'How much is it?' o 'What's the price?'. Para artículos plurales, di 'How much do they cost?'"
          }
        }
      },
      {
        "type": "text",
        "id": "entertainment_intro",
        "title": "Entertainment Vocabulary",
        "content": "Talk about your hobbies, entertainment, and leisure activities with this essential vocabulary!",
        "examples": [
          "I go to the cinema (I visit the movie theater)",
          "I watch a movie (I view a film)",
          "I listen to music (I hear music)"
        ],
        "translations": {
          "es": {
            "title": "Vocabulario de Entretenimiento",
            "content": "¡Habla sobre tus pasatiempos, entretenimiento y actividades de ocio con este vocabulario esencial!",
            "examples": [
              "I go to the cinema (Voy al cine)",
              "I watch a movie (Veo una película)",
              "I listen to music (Escucho música)"
            ]
          }
        }
      },
      {
        "type": "pronunciation",
        "id": "entertainment_pronunciation",
        "instruction": "Practice pronouncing these entertainment-related words",
        "words": [
          {"word": "movie", "translation": "película", "phonetic": "MOO-vee"},
          {"word": "music", "translation": "música", "phonetic": "MYOO-zik"},
          {"word": "concert", "translation": "concierto", "phonetic": "KON-sert"},
          {"word": "theater", "translation": "teatro", "phonetic": "THEE-a-ter"},
          {"word": "cinema", "translation": "cine", "phonetic": "SIN-e-ma"}
        ],
        "explanation": "Excellent! Notice: 'movie' rhymes with 'groovy', 'music' has a 'y' sound. Practice these until you can say them naturally in conversations!",
        "translations": {
          "es": {
            "instruction": "Practica pronunciando estas palabras relacionadas con el entretenimiento",
            "explanation": "¡Excelente! Nota: 'movie' rima con 'groovy', 'music' tiene un sonido 'y'. ¡Practica estas hasta que puedas decirlas naturalmente en conversaciones!"
          }
        }
      },
      {
        "type": "translation",
        "id": "entertainment_translation",
        "instruction": "Translate this sentence to English",
        "sentence": "Quiero ver una película este fin de semana",
        "correct_answer": "I want to watch a movie this weekend",
        "language_code": "en",
        "words": [
          {"word": "Quiero", "translation": "I want"},
          {"word": "ver", "translation": "to watch"},
          {"word": "película", "translation": "movie"},
          {"word": "fin de semana", "translation": "weekend"}
        ],
        "explanation": "Perfect! 'I want to watch' means you desire to see something. 'This weekend' refers to the upcoming Saturday and Sunday. Notice: 'watch' is used for movies/TV, 'see' can also be used.",
        "translations": {
          "es": {
            "instruction": "Traduce esta oración al inglés",
            "explanation": "¡Perfecto! 'I want to watch' significa que deseas ver algo. 'This weekend' se refiere al sábado y domingo próximos. Nota: 'watch' se usa para películas/TV, 'see' también se puede usar."
          }
        }
      },
      {
        "type": "exercise",
        "id": "mixed_vocabulary_exercise",
        "question": "Which sentence correctly combines vocabulary from different topics?",
        "options": [
          {"text": "I am excited about the airplane trip tomorrow", "is_correct": true},
          {"text": "I have pain of bus", "is_correct": false},
          {"text": "I go to doctor in cloudy", "is_correct": false},
          {"text": "It's sun of computer", "is_correct": false}
        ],
        "explanation": "Excellent! This sentence combines emotions ('excited'), transportation ('airplane'), and time ('tomorrow') naturally. This is how vocabulary works in real conversations - words from different topics combine naturally!",
        "translations": {
          "es": {
            "question": "¿Qué oración combina correctamente vocabulario de diferentes temas?",
            "options": [
              {"text": "I am excited about the airplane trip tomorrow", "is_correct": true},
              {"text": "I have pain of bus", "is_correct": false},
              {"text": "I go to doctor in cloudy", "is_correct": false},
              {"text": "It's sun of computer", "is_correct": false}
            ],
            "explanation": "¡Excelente! Esta oración combina emociones ('excited'), transporte ('airplane'), y tiempo ('tomorrow') naturalmente. ¡Así es como funciona el vocabulario en conversaciones reales - las palabras de diferentes temas se combinan naturalmente!"
          }
        }
      },
      {
        "type": "text",
        "id": "practice_tips",
        "title": "Practice Tips",
        "content": "Here are tips to master this expanded vocabulary:",
        "examples": [
          "Use vocabulary from different topics together in sentences",
          "Practice pronunciation regularly - it helps memory",
          "Connect words to personal experiences",
          "Use translation exercises to see words in context",
          "Review matching exercises to strengthen word associations"
        ],
        "translations": {
          "es": {
            "title": "Consejos de Práctica",
            "content": "Aquí hay consejos para dominar este vocabulario expandido:",
            "examples": [
              "Usa vocabulario de diferentes temas juntos en oraciones",
              "Practica la pronunciación regularmente - ayuda a la memoria",
              "Conecta palabras con experiencias personales",
              "Usa ejercicios de traducción para ver palabras en contexto",
              "Revisa ejercicios de emparejamiento para fortalecer asociaciones de palabras"
            ]
          }
        }
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'english_weather', 'english_sun', 'english_rain', 'english_snow', 'english_wind',
    'english_cloudy', 'english_sunny', 'english_hot', 'english_cold', 'english_temperature',
    'english_bus', 'english_train', 'english_airplane', 'english_subway', 'english_taxi',
    'english_bicycle', 'english_car', 'english_station', 'english_airport',
    'english_computer', 'english_cell_phone', 'english_internet', 'english_email',
    'english_app', 'english_social_network', 'english_browser',
    'english_health', 'english_doctor', 'english_hospital', 'english_pharmacy', 'english_medicine',
    'english_pain', 'english_illness', 'english_appointment',
    'english_happy', 'english_sad', 'english_excited', 'english_worried', 'english_angry',
    'english_nervous', 'english_relaxed', 'english_surprised',
    'english_store', 'english_supermarket', 'english_cashier', 'english_price', 'english_discount',
    'english_card', 'english_cash',
    'english_cinema', 'english_theater', 'english_music', 'english_tv_series', 'english_movie', 'english_concert'
  ]::TEXT[],
  ARRAY['vocabulary_expansion', 'high_frequency_words', 'everyday_topics', 'practical_vocabulary', 'word_associations']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  updated_at = NOW();

COMMENT ON TABLE words IS 'Vocabulary words unlocked by this lesson include high-frequency terms across weather, transportation, technology, health, emotions, shopping, and entertainment';

