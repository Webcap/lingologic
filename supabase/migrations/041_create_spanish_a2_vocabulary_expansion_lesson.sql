-- A2 Spanish Lesson: Vocabulary Expansion (High-Frequency Areas)
-- This lesson expands vocabulary across multiple high-frequency topics with varied exercise types

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Weather
('spanish_tiempo', 'spanish', 'tiempo', 'weather', 'weather'),
('spanish_sol', 'spanish', 'sol', 'sun', 'weather'),
('spanish_lluvia', 'spanish', 'lluvia', 'rain', 'weather'),
('spanish_nieve', 'spanish', 'nieve', 'snow', 'weather'),
('spanish_viento', 'spanish', 'viento', 'wind', 'weather'),
('spanish_nublado', 'spanish', 'nublado', 'cloudy', 'weather'),
('spanish_soleado', 'spanish', 'soleado', 'sunny', 'weather'),
('spanish_calor', 'spanish', 'calor', 'heat/hot', 'weather'),
('spanish_frio', 'spanish', 'frío', 'cold', 'weather'),
('spanish_temperatura', 'spanish', 'temperatura', 'temperature', 'weather'),
-- Transportation
('spanish_autobus', 'spanish', 'autobús', 'bus', 'transportation'),
('spanish_tren', 'spanish', 'tren', 'train', 'transportation'),
('spanish_avion', 'spanish', 'avión', 'airplane', 'transportation'),
('spanish_metro', 'spanish', 'metro', 'subway', 'transportation'),
('spanish_taxi', 'spanish', 'taxi', 'taxi', 'transportation'),
('spanish_bicicleta', 'spanish', 'bicicleta', 'bicycle', 'transportation'),
('spanish_coche', 'spanish', 'coche', 'car', 'transportation'),
('spanish_estacion', 'spanish', 'estación', 'station', 'transportation'),
('spanish_aeropuerto', 'spanish', 'aeropuerto', 'airport', 'transportation'),
-- Technology
('spanish_computadora', 'spanish', 'computadora', 'computer', 'technology'),
('spanish_celular', 'spanish', 'celular', 'cell phone', 'technology'),
('spanish_internet', 'spanish', 'internet', 'internet', 'technology'),
('spanish_correo_electronico', 'spanish', 'correo electrónico', 'email', 'technology'),
('spanish_aplicacion', 'spanish', 'aplicación', 'app', 'technology'),
('spanish_red_social', 'spanish', 'red social', 'social network', 'technology'),
('spanish_navegador', 'spanish', 'navegador', 'browser', 'technology'),
-- Health
('spanish_salud', 'spanish', 'salud', 'health', 'health'),
('spanish_medico', 'spanish', 'médico', 'doctor', 'health'),
('spanish_hospital', 'spanish', 'hospital', 'hospital', 'health'),
('spanish_farmacia', 'spanish', 'farmacia', 'pharmacy', 'health'),
('spanish_medicina', 'spanish', 'medicina', 'medicine', 'health'),
('spanish_dolor', 'spanish', 'dolor', 'pain', 'health'),
('spanish_enfermedad', 'spanish', 'enfermedad', 'illness', 'health'),
('spanish_cita', 'spanish', 'cita', 'appointment', 'health'),
-- Emotions
('spanish_feliz', 'spanish', 'feliz', 'happy', 'emotions'),
('spanish_triste', 'spanish', 'triste', 'sad', 'emotions'),
('spanish_emocionado', 'spanish', 'emocionado', 'excited', 'emotions'),
('spanish_preocupado', 'spanish', 'preocupado', 'worried', 'emotions'),
('spanish_enojado', 'spanish', 'enojado', 'angry', 'emotions'),
('spanish_nervioso', 'spanish', 'nervioso', 'nervous', 'emotions'),
('spanish_relajado', 'spanish', 'relajado', 'relaxed', 'emotions'),
('spanish_sorprendido', 'spanish', 'sorprendido', 'surprised', 'emotions'),
-- Shopping & Services
('spanish_tienda', 'spanish', 'tienda', 'store/shop', 'shopping'),
('spanish_supermercado', 'spanish', 'supermercado', 'supermarket', 'shopping'),
('spanish_cajero', 'spanish', 'cajero', 'cashier', 'shopping'),
('spanish_precio', 'spanish', 'precio', 'price', 'shopping'),
('spanish_descuento', 'spanish', 'descuento', 'discount', 'shopping'),
('spanish_tarjeta', 'spanish', 'tarjeta', 'card', 'shopping'),
('spanish_efectivo', 'spanish', 'efectivo', 'cash', 'shopping'),
-- Entertainment
('spanish_cine', 'spanish', 'cine', 'cinema', 'entertainment'),
('spanish_teatro', 'spanish', 'teatro', 'theater', 'entertainment'),
('spanish_musica', 'spanish', 'música', 'music', 'entertainment'),
('spanish_serie', 'spanish', 'serie', 'TV series', 'entertainment'),
('spanish_pelicula', 'spanish', 'película', 'movie', 'entertainment'),
('spanish_concierto', 'spanish', 'concierto', 'concert', 'entertainment')
ON CONFLICT (id) DO NOTHING;

-- Create the A2 Spanish lesson with comprehensive content and varied exercises
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
  'spanish_a2_vocabulary_expansion',
  'Vocabulary Expansion (High-Frequency Areas)',
  'Expand your Spanish vocabulary across essential everyday topics! Master words for weather, transportation, technology, health, emotions, shopping, and entertainment through varied, engaging exercises.',
  'spanish',
  'vocabulary',
  'A2',
  3,
  45,
  $lesson_json${
    "translations": {
      "es": {
        "title": "Expansión de Vocabulario (Áreas de Alta Frecuencia)",
        "description": "¡Expande tu vocabulario en español a través de temas esenciales cotidianos! Domina palabras sobre el clima, transporte, tecnología, salud, emociones, compras y entretenimiento con ejercicios variados y atractivos."
      }
    },
    "sections": [
      {
        "type": "text",
        "id": "vocab_intro",
        "title": "Expanding Your Vocabulary",
        "content": "Welcome! This lesson covers high-frequency vocabulary across multiple essential topics. You'll learn practical words for everyday situations through a variety of engaging exercises. Let's dive in!",
        "examples": [
          "Weather: 'Hace sol' (It's sunny)",
          "Transportation: 'Tomo el autobús' (I take the bus)",
          "Technology: 'Envío un correo electrónico' (I send an email)"
        ],
        "translations": {
          "es": {
            "title": "Expandiendo Tu Vocabulario",
            "content": "¡Bienvenido! Esta lección cubre vocabulario de alta frecuencia en múltiples temas esenciales. Aprenderás palabras prácticas para situaciones cotidianas a través de una variedad de ejercicios atractivos. ¡Comencemos!",
            "examples": [
              "Clima: 'Hace sol' (It's sunny)",
              "Transporte: 'Tomo el autobús' (I take the bus)",
              "Tecnología: 'Envío un correo electrónico' (I send an email)"
            ]
          }
        }
      },
      {
        "type": "matching",
        "id": "weather_matching_1",
        "instruction": "Match the Spanish weather words with their English translations",
        "pairs": [
          {"word": "sol", "translation": "sun"},
          {"word": "lluvia", "translation": "rain"},
          {"word": "nieve", "translation": "snow"},
          {"word": "viento", "translation": "wind"},
          {"word": "nublado", "translation": "cloudy"},
          {"word": "soleado", "translation": "sunny"},
          {"word": "calor", "translation": "heat/hot"},
          {"word": "frío", "translation": "cold"}
        ],
        "distractors": ["tiempo", "temperatura"],
        "explanation": "Excellent! Weather vocabulary is essential for everyday conversations. Remember: 'Hace sol' (It's sunny), 'Está nublado' (It's cloudy), 'Hace calor' (It's hot).",
        "translations": {
          "es": {
            "instruction": "Empareja las palabras del clima en español con sus traducciones al inglés",
            "explanation": "¡Excelente! El vocabulario del clima es esencial para conversaciones cotidianas. Recuerda: 'Hace sol' (It's sunny), 'Está nublado' (It's cloudy), 'Hace calor' (It's hot)."
          }
        }
      },
      {
        "type": "pronunciation",
        "id": "weather_pronunciation",
        "instruction": "Practice pronouncing these weather-related words in Spanish",
        "words": [
          {"word": "lluvia", "translation": "rain", "phonetic": "YOO-vee-ah"},
          {"word": "nublado", "translation": "cloudy", "phonetic": "noo-BLAH-doh"},
          {"word": "temperatura", "translation": "temperature", "phonetic": "tem-pe-rah-TOO-rah"},
          {"word": "viento", "translation": "wind", "phonetic": "VYEN-toh"},
          {"word": "soleado", "translation": "sunny", "phonetic": "so-le-AH-doh"}
        ],
        "explanation": "Great practice! Pay attention to the double 'l' in 'lluvia' (pronounced like 'y'), and the stress patterns. Keep practicing!",
        "translations": {
          "es": {
            "instruction": "Practica pronunciando estas palabras relacionadas con el clima en español",
            "explanation": "¡Gran práctica! Presta atención a la doble 'l' en 'lluvia' (se pronuncia como 'y'), y los patrones de acento. ¡Sigue practicando!"
          }
        }
      },
      {
        "type": "text",
        "id": "transportation_intro",
        "title": "Transportation Vocabulary",
        "content": "Learn essential transportation vocabulary! Whether you're traveling or just getting around town, these words are crucial.",
        "examples": [
          "Voy en autobús (I go by bus)",
          "Tomo el tren (I take the train)",
          "Llego al aeropuerto (I arrive at the airport)"
        ],
        "translations": {
          "es": {
            "title": "Vocabulario de Transporte",
            "content": "¡Aprende vocabulario esencial de transporte! Ya sea que estés viajando o solo moviéndote por la ciudad, estas palabras son cruciales.",
            "examples": [
              "Voy en autobús (I go by bus)",
              "Tomo el tren (I take the train)",
              "Llego al aeropuerto (I arrive at the airport)"
            ]
          }
        }
      },
      {
        "type": "exercise",
        "id": "transportation_exercise",
        "question": "How do you say 'I take the subway' in Spanish?",
        "options": [
          {"text": "Tomo el metro", "is_correct": true},
          {"text": "Tomo el autobús", "is_correct": false},
          {"text": "Tomo el tren", "is_correct": false},
          {"text": "Tomo el taxi", "is_correct": false}
        ],
        "explanation": "Perfect! 'Tomo el metro' means 'I take the subway'. In Spanish, you use 'tomar' (to take) for transportation: 'tomo el autobús', 'tomo el tren', etc.",
        "translations": {
          "es": {
            "question": "¿Cómo dices 'I take the subway' en español?",
            "options": [
              {"text": "Tomo el metro", "is_correct": true},
              {"text": "Tomo el autobús", "is_correct": false},
              {"text": "Tomo el tren", "is_correct": false},
              {"text": "Tomo el taxi", "is_correct": false}
            ],
            "explanation": "¡Perfecto! 'Tomo el metro' significa 'I take the subway'. En español, usas 'tomar' (to take) para el transporte: 'tomo el autobús', 'tomo el tren', etc."
          }
        }
      },
      {
        "type": "translation",
        "id": "transportation_translation",
        "instruction": "Translate this sentence to Spanish",
        "sentence": "I need to go to the airport tomorrow",
        "correct_answer": "Necesito ir al aeropuerto mañana",
        "language_code": "es",
        "words": [
          {"word": "I need", "translation": "Necesito"},
          {"word": "to go", "translation": "ir"},
          {"word": "airport", "translation": "aeropuerto"},
          {"word": "tomorrow", "translation": "mañana"}
        ],
        "explanation": "Excellent! Notice: 'Necesito' (I need) + infinitive verb. 'Al aeropuerto' uses 'al' (a + el) because 'aeropuerto' is masculine.",
        "translations": {
          "es": {
            "instruction": "Traduce esta oración al español",
            "explanation": "¡Excelente! Nota: 'Necesito' (I need) + verbo en infinitivo. 'Al aeropuerto' usa 'al' (a + el) porque 'aeropuerto' es masculino."
          }
        }
      },
      {
        "type": "text",
        "id": "technology_intro",
        "title": "Technology Vocabulary",
        "content": "Modern life requires modern vocabulary! Learn essential technology terms for digital communication and devices.",
        "examples": [
          "Envío un correo electrónico (I send an email)",
          "Uso mi celular (I use my cell phone)",
          "Navego en internet (I browse the internet)"
        ],
        "translations": {
          "es": {
            "title": "Vocabulario de Tecnología",
            "content": "¡La vida moderna requiere vocabulario moderno! Aprende términos tecnológicos esenciales para la comunicación digital y los dispositivos.",
            "examples": [
              "Envío un correo electrónico (I send an email)",
              "Uso mi celular (I use my cell phone)",
              "Navego en internet (I browse the internet)"
            ]
          }
        }
      },
      {
        "type": "matching",
        "id": "technology_matching",
        "instruction": "Match the Spanish technology terms with their English translations",
        "pairs": [
          {"word": "computadora", "translation": "computer"},
          {"word": "celular", "translation": "cell phone"},
          {"word": "correo electrónico", "translation": "email"},
          {"word": "aplicación", "translation": "app"},
          {"word": "red social", "translation": "social network"},
          {"word": "navegador", "translation": "browser"},
          {"word": "internet", "translation": "internet"}
        ],
        "distractors": ["música", "película"],
        "explanation": "Perfect! Technology vocabulary is constantly evolving, but these are the essential terms. Note: 'correo electrónico' is the full form, but many people just say 'correo'.",
        "translations": {
          "es": {
            "instruction": "Empareja los términos tecnológicos en español con sus traducciones al inglés",
            "explanation": "¡Perfecto! El vocabulario tecnológico evoluciona constantemente, pero estos son los términos esenciales. Nota: 'correo electrónico' es la forma completa, pero muchas personas solo dicen 'correo'."
          }
        }
      },
      {
        "type": "text",
        "id": "health_intro",
        "title": "Health Vocabulary",
        "content": "Health-related vocabulary is essential for describing how you feel and getting medical help when needed.",
        "examples": [
          "Tengo una cita con el médico (I have an appointment with the doctor)",
          "Voy a la farmacia (I go to the pharmacy)",
          "Tomo medicina (I take medicine)"
        ],
        "translations": {
          "es": {
            "title": "Vocabulario de Salud",
            "content": "El vocabulario relacionado con la salud es esencial para describir cómo te sientes y obtener ayuda médica cuando la necesitas.",
            "examples": [
              "Tengo una cita con el médico (I have an appointment with the doctor)",
              "Voy a la farmacia (I go to the pharmacy)",
              "Tomo medicina (I take medicine)"
            ]
          }
        }
      },
      {
        "type": "pronunciation",
        "id": "health_pronunciation",
        "instruction": "Practice pronouncing these health-related words",
        "words": [
          {"word": "médico", "translation": "doctor", "phonetic": "MEH-dee-koh"},
          {"word": "farmacia", "translation": "pharmacy", "phonetic": "far-MAH-see-ah"},
          {"word": "hospital", "translation": "hospital", "phonetic": "os-pee-TAHL"},
          {"word": "enfermedad", "translation": "illness", "phonetic": "en-fer-meh-DAHD"},
          {"word": "medicina", "translation": "medicine", "phonetic": "meh-dee-SEE-nah"}
        ],
        "explanation": "Great job! Pay attention to stress: 'médico' (stress on 'me'), 'farmacia' (stress on 'ma'). Practice these until they feel natural!",
        "translations": {
          "es": {
            "instruction": "Practica pronunciando estas palabras relacionadas con la salud",
            "explanation": "¡Buen trabajo! Presta atención al acento: 'médico' (acento en 'me'), 'farmacia' (acento en 'ma'). ¡Practica estas hasta que se sientan naturales!"
          }
        }
      },
      {
        "type": "exercise",
        "id": "health_exercise",
        "question": "What does 'Tengo dolor de cabeza' mean?",
        "options": [
          {"text": "I have a headache", "is_correct": true},
          {"text": "I have a stomachache", "is_correct": false},
          {"text": "I have an appointment", "is_correct": false},
          {"text": "I take medicine", "is_correct": false}
        ],
        "explanation": "Correct! 'Tengo dolor de cabeza' means 'I have a headache'. The structure is 'Tengo dolor de + body part': 'dolor de estómago' (stomachache), 'dolor de espalda' (backache).",
        "translations": {
          "es": {
            "question": "¿Qué significa 'Tengo dolor de cabeza'?",
            "options": [
              {"text": "I have a headache", "is_correct": true},
              {"text": "I have a stomachache", "is_correct": false},
              {"text": "I have an appointment", "is_correct": false},
              {"text": "I take medicine", "is_correct": false}
            ],
            "explanation": "¡Correcto! 'Tengo dolor de cabeza' significa 'I have a headache'. La estructura es 'Tengo dolor de + parte del cuerpo': 'dolor de estómago' (stomachache), 'dolor de espalda' (backache)."
          }
        }
      },
      {
        "type": "text",
        "id": "emotions_intro",
        "title": "Expressing Emotions",
        "content": "Learn vocabulary to express your feelings! Being able to describe emotions is important for authentic conversations.",
        "examples": [
          "Estoy feliz (I am happy)",
          "Me siento emocionado (I feel excited)",
          "Está preocupado (He/she is worried)"
        ],
        "translations": {
          "es": {
            "title": "Expresar Emociones",
            "content": "¡Aprende vocabulario para expresar tus sentimientos! Ser capaz de describir emociones es importante para conversaciones auténticas.",
            "examples": [
              "Estoy feliz (I am happy)",
              "Me siento emocionado (I feel excited)",
              "Está preocupado (He/she is worried)"
            ]
          }
        }
      },
      {
        "type": "translation",
        "id": "emotions_translation",
        "instruction": "Translate this sentence to Spanish",
        "sentence": "I am very excited about the trip",
        "correct_answer": "Estoy muy emocionado por el viaje",
        "language_code": "es",
        "words": [
          {"word": "I am", "translation": "Estoy"},
          {"word": "very", "translation": "muy"},
          {"word": "excited", "translation": "emocionado"},
          {"word": "about", "translation": "por"},
          {"word": "trip", "translation": "viaje"}
        ],
        "explanation": "Excellent! 'Estoy emocionado' means 'I am excited'. Note: 'emocionado' changes to 'emocionada' for feminine. Use 'por' to say what you're excited about.",
        "translations": {
          "es": {
            "instruction": "Traduce esta oración al español",
            "explanation": "¡Excelente! 'Estoy emocionado' significa 'I am excited'. Nota: 'emocionado' cambia a 'emocionada' para femenino. Usa 'por' para decir de qué estás emocionado."
          }
        }
      },
      {
        "type": "matching",
        "id": "emotions_matching",
        "instruction": "Match the Spanish emotion words with their English translations",
        "pairs": [
          {"word": "feliz", "translation": "happy"},
          {"word": "triste", "translation": "sad"},
          {"word": "emocionado", "translation": "excited"},
          {"word": "preocupado", "translation": "worried"},
          {"word": "enojado", "translation": "angry"},
          {"word": "nervioso", "translation": "nervous"},
          {"word": "relajado", "translation": "relaxed"},
          {"word": "sorprendido", "translation": "surprised"}
        ],
        "distractors": ["salud", "dolor"],
        "explanation": "Perfect! These adjectives describe emotions. Remember: they agree with gender - 'feliz' (happy) becomes 'felices' for plural. Use 'Estoy' (I am) or 'Me siento' (I feel) with these words.",
        "translations": {
          "es": {
            "instruction": "Empareja las palabras de emociones en español con sus traducciones al inglés",
            "explanation": "¡Perfecto! Estos adjetivos describen emociones. Recuerda: concuerdan con el género - 'feliz' (happy) se convierte en 'felices' para plural. Usa 'Estoy' (I am) o 'Me siento' (I feel) con estas palabras."
          }
        }
      },
      {
        "type": "text",
        "id": "shopping_intro",
        "title": "Shopping Vocabulary",
        "content": "Essential vocabulary for shopping experiences! From stores to payment methods, learn the words you need.",
        "examples": [
          "Voy al supermercado (I go to the supermarket)",
          "¿Cuánto cuesta? (How much does it cost?)",
          "Pago con tarjeta (I pay with card)"
        ],
        "translations": {
          "es": {
            "title": "Vocabulario de Compras",
            "content": "¡Vocabulario esencial para experiencias de compras! Desde tiendas hasta métodos de pago, aprende las palabras que necesitas.",
            "examples": [
              "Voy al supermercado (I go to the supermarket)",
              "¿Cuánto cuesta? (How much does it cost?)",
              "Pago con tarjeta (I pay with card)"
            ]
          }
        }
      },
      {
        "type": "exercise",
        "id": "shopping_exercise",
        "question": "How do you ask 'How much does it cost?' in Spanish?",
        "options": [
          {"text": "¿Cuánto cuesta?", "is_correct": true},
          {"text": "¿Dónde está?", "is_correct": false},
          {"text": "¿Qué es esto?", "is_correct": false},
          {"text": "¿Tienes esto?", "is_correct": false}
        ],
        "explanation": "Perfect! '¿Cuánto cuesta?' means 'How much does it cost?'. You can also say '¿Cuánto vale?' or '¿Cuál es el precio?'. For plural items, say '¿Cuánto cuestan?'",
        "translations": {
          "es": {
            "question": "¿Cómo preguntas 'How much does it cost?' en español?",
            "options": [
              {"text": "¿Cuánto cuesta?", "is_correct": true},
              {"text": "¿Dónde está?", "is_correct": false},
              {"text": "¿Qué es esto?", "is_correct": false},
              {"text": "¿Tienes esto?", "is_correct": false}
            ],
            "explanation": "¡Perfecto! '¿Cuánto cuesta?' significa 'How much does it cost?'. También puedes decir '¿Cuánto vale?' o '¿Cuál es el precio?'. Para artículos plurales, di '¿Cuánto cuestan?'"
          }
        }
      },
      {
        "type": "text",
        "id": "entertainment_intro",
        "title": "Entertainment Vocabulary",
        "content": "Talk about your hobbies, entertainment, and leisure activities with this essential vocabulary!",
        "examples": [
          "Voy al cine (I go to the cinema)",
          "Veo una película (I watch a movie)",
          "Escucho música (I listen to music)"
        ],
        "translations": {
          "es": {
            "title": "Vocabulario de Entretenimiento",
            "content": "¡Habla sobre tus pasatiempos, entretenimiento y actividades de ocio con este vocabulario esencial!",
            "examples": [
              "Voy al cine (I go to the cinema)",
              "Veo una película (I watch a movie)",
              "Escucho música (I listen to music)"
            ]
          }
        }
      },
      {
        "type": "pronunciation",
        "id": "entertainment_pronunciation",
        "instruction": "Practice pronouncing these entertainment-related words",
        "words": [
          {"word": "película", "translation": "movie", "phonetic": "pe-LEE-koo-lah"},
          {"word": "música", "translation": "music", "phonetic": "MOO-see-kah"},
          {"word": "concierto", "translation": "concert", "phonetic": "kon-see-ER-toh"},
          {"word": "teatro", "translation": "theater", "phonetic": "teh-AH-troh"},
          {"word": "serie", "translation": "TV series", "phonetic": "SEH-ree-eh"}
        ],
        "explanation": "Excellent! Notice: 'película' has stress on 'lí', 'música' on 'sí'. Practice these until you can say them naturally in conversations!",
        "translations": {
          "es": {
            "instruction": "Practica pronunciando estas palabras relacionadas con el entretenimiento",
            "explanation": "¡Excelente! Nota: 'película' tiene acento en 'lí', 'música' en 'sí'. ¡Practica estas hasta que puedas decirlas naturalmente en conversaciones!"
          }
        }
      },
      {
        "type": "translation",
        "id": "entertainment_translation",
        "instruction": "Translate this sentence to Spanish",
        "sentence": "I want to watch a movie this weekend",
        "correct_answer": "Quiero ver una película este fin de semana",
        "language_code": "es",
        "words": [
          {"word": "I want", "translation": "Quiero"},
          {"word": "to watch", "translation": "ver"},
          {"word": "movie", "translation": "película"},
          {"word": "weekend", "translation": "fin de semana"}
        ],
        "explanation": "Perfect! 'Quiero ver' means 'I want to watch'. 'Este fin de semana' is 'this weekend'. Notice: 'película' is feminine, so it's 'una película'.",
        "translations": {
          "es": {
            "instruction": "Traduce esta oración al español",
            "explanation": "¡Perfecto! 'Quiero ver' significa 'I want to watch'. 'Este fin de semana' es 'this weekend'. Nota: 'película' es femenino, así que es 'una película'."
          }
        }
      },
      {
        "type": "exercise",
        "id": "mixed_vocabulary_exercise",
        "question": "Which sentence correctly combines vocabulary from different topics?",
        "options": [
          {"text": "Estoy emocionado por el viaje en avión mañana", "is_correct": true},
          {"text": "Tengo dolor de autobús", "is_correct": false},
          {"text": "Voy al médico en nublado", "is_correct": false},
          {"text": "Hace sol de computadora", "is_correct": false}
        ],
        "explanation": "Excellent! This sentence combines emotions ('emocionado'), transportation ('avión'), and time ('mañana') naturally. This is how vocabulary works in real conversations - words from different topics combine naturally!",
        "translations": {
          "es": {
            "question": "¿Qué oración combina correctamente vocabulario de diferentes temas?",
            "options": [
              {"text": "Estoy emocionado por el viaje en avión mañana", "is_correct": true},
              {"text": "Tengo dolor de autobús", "is_correct": false},
              {"text": "Voy al médico en nublado", "is_correct": false},
              {"text": "Hace sol de computadora", "is_correct": false}
            ],
            "explanation": "¡Excelente! Esta oración combina emociones ('emocionado'), transporte ('avión'), y tiempo ('mañana') naturalmente. ¡Así es como funciona el vocabulario en conversaciones reales - las palabras de diferentes temas se combinan naturalmente!"
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
    'spanish_tiempo', 'spanish_sol', 'spanish_lluvia', 'spanish_nieve', 'spanish_viento',
    'spanish_nublado', 'spanish_soleado', 'spanish_calor', 'spanish_frio', 'spanish_temperatura',
    'spanish_autobus', 'spanish_tren', 'spanish_avion', 'spanish_metro', 'spanish_taxi',
    'spanish_bicicleta', 'spanish_coche', 'spanish_estacion', 'spanish_aeropuerto',
    'spanish_computadora', 'spanish_celular', 'spanish_internet', 'spanish_correo_electronico',
    'spanish_aplicacion', 'spanish_red_social', 'spanish_navegador',
    'spanish_salud', 'spanish_medico', 'spanish_hospital', 'spanish_farmacia', 'spanish_medicina',
    'spanish_dolor', 'spanish_enfermedad', 'spanish_cita',
    'spanish_feliz', 'spanish_triste', 'spanish_emocionado', 'spanish_preocupado', 'spanish_enojado',
    'spanish_nervioso', 'spanish_relajado', 'spanish_sorprendido',
    'spanish_tienda', 'spanish_supermercado', 'spanish_cajero', 'spanish_precio', 'spanish_descuento',
    'spanish_tarjeta', 'spanish_efectivo',
    'spanish_cine', 'spanish_teatro', 'spanish_musica', 'spanish_serie', 'spanish_pelicula', 'spanish_concierto'
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

