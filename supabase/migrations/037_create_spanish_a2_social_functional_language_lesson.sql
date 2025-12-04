-- A2 Spanish Lesson: Social & Functional Language
-- This lesson teaches essential social phrases and functional language for everyday interactions in Spanish

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Greetings and Farewells
('spanish_buenos_dias', 'spanish', 'buenos días', 'good morning', 'greetings'),
('spanish_buenas_tardes', 'spanish', 'buenas tardes', 'good afternoon', 'greetings'),
('spanish_buenas_noches', 'spanish', 'buenas noches', 'good evening/night', 'greetings'),
('spanish_hola', 'spanish', 'hola', 'hello', 'greetings'),
('spanish_adios', 'spanish', 'adiós', 'goodbye', 'greetings'),
('spanish_hasta_luego', 'spanish', 'hasta luego', 'see you later', 'greetings'),
('spanish_hasta_mañana', 'spanish', 'hasta mañana', 'see you tomorrow', 'greetings'),
('spanish_nos_vemos', 'spanish', 'nos vemos', 'see you', 'greetings'),
-- Making Requests
('spanish_por_favor', 'spanish', 'por favor', 'please', 'requests'),
('spanish_puedes', 'spanish', 'puedes', 'can you', 'requests'),
('spanish_podrias', 'spanish', 'podrías', 'could you', 'requests'),
('spanish_me_puedes', 'spanish', 'me puedes', 'can you (for me)', 'requests'),
('spanish_necesito', 'spanish', 'necesito', 'I need', 'requests'),
('spanish_quiero', 'spanish', 'quiero', 'I want', 'requests'),
('spanish_me_gustaria', 'spanish', 'me gustaría', 'I would like', 'requests'),
-- Asking for Help
('spanish_ayuda', 'spanish', 'ayuda', 'help', 'help'),
('spanish_necesito_ayuda', 'spanish', 'necesito ayuda', 'I need help', 'help'),
('spanish_puedes_ayudarme', 'spanish', 'puedes ayudarme', 'can you help me', 'help'),
('spanish_no_entiendo', 'spanish', 'no entiendo', 'I don''t understand', 'help'),
('spanish_puedes_repetir', 'spanish', 'puedes repetir', 'can you repeat', 'help'),
('spanish_mas_despacio', 'spanish', 'más despacio', 'more slowly', 'help'),
-- Apologizing
('spanish_perdon', 'spanish', 'perdón', 'sorry', 'apologies'),
('spanish_disculpa', 'spanish', 'disculpa', 'excuse me/sorry', 'apologies'),
('spanish_lo_siento', 'spanish', 'lo siento', 'I''m sorry', 'apologies'),
('spanish_perdona', 'spanish', 'perdona', 'forgive me', 'apologies'),
-- Expressing Gratitude
('spanish_gracias', 'spanish', 'gracias', 'thank you', 'gratitude'),
('spanish_muchas_gracias', 'spanish', 'muchas gracias', 'thank you very much', 'gratitude'),
('spanish_de_nada', 'spanish', 'de nada', 'you''re welcome', 'gratitude'),
('spanish_no_hay_de_que', 'spanish', 'no hay de qué', 'don''t mention it', 'gratitude'),
('spanish_es_un_placer', 'spanish', 'es un placer', 'it''s a pleasure', 'gratitude'),
-- Making Offers
('spanish_te_ayudo', 'spanish', 'te ayudo', 'I''ll help you', 'offers'),
('spanish_quieres', 'spanish', 'quieres', 'do you want', 'offers'),
('spanish_te_gustaria', 'spanish', 'te gustaría', 'would you like', 'offers'),
('spanish_puedo_ayudarte', 'spanish', 'puedo ayudarte', 'I can help you', 'offers'),
-- Making Suggestions
('spanish_que_tal', 'spanish', 'qué tal', 'how about', 'suggestions'),
('spanish_por_que_no', 'spanish', 'por qué no', 'why don''t we', 'suggestions'),
('spanish_te_parece', 'spanish', 'te parece', 'what do you think', 'suggestions'),
('spanish_sugiero', 'spanish', 'sugiero', 'I suggest', 'suggestions'),
-- Polite Expressions
('spanish_con_permiso', 'spanish', 'con permiso', 'excuse me (permission)', 'polite'),
('spanish_perdone', 'spanish', 'perdone', 'excuse me (formal)', 'polite'),
('spanish_por_supuesto', 'spanish', 'por supuesto', 'of course', 'polite'),
('spanish_claro', 'spanish', 'claro', 'of course/sure', 'polite')
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
  'spanish_a2_social_functional_language',
  'Social & Functional Language',
  'Master essential social phrases and functional language for everyday interactions in Spanish! Learn to greet, make requests, apologize, and express gratitude naturally.',
  'spanish',
  'social',
  'A2',
  2,
  40,
  $lesson_json${
    "sections": [
      {
        "type": "text",
        "id": "social_intro",
        "title": "Social & Functional Language",
        "content": "Welcome! This lesson teaches you essential phrases for everyday social interactions in Spanish. You'll learn how to greet people, make requests, ask for help, apologize, and express gratitude in natural, polite ways.",
        "examples": [
          "Greeting someone: 'Buenos días'",
          "Making a request: '¿Puedes ayudarme?'",
          "Expressing gratitude: 'Muchas gracias'"
        ]
      },
      {
        "type": "text",
        "id": "greetings_farewells",
        "title": "Greetings and Farewells",
        "content": "Spanish has different greetings for different times of day. Learn when to use each one!",
        "examples": [
          "Buenos días (good morning) - used until around 12 PM",
          "Buenas tardes (good afternoon) - used from 12 PM to evening",
          "Buenas noches (good evening/night) - used in the evening and night",
          "Hola (hello) - can be used anytime"
        ]
      },
      {
        "type": "example",
        "id": "greetings_example",
        "spanish_example": "Buenos días, ¿cómo estás? Hasta luego, nos vemos mañana.",
        "english_translation": "Good morning, how are you? See you later, see you tomorrow.",
        "explanation": "Notice the time-specific greeting 'Buenos días' and the casual farewells 'Hasta luego' and 'Nos vemos'. These are very common in everyday Spanish."
      },
      {
        "type": "matching",
        "id": "greetings_matching",
        "instruction": "Match the Spanish greetings and farewells with their English translations",
        "pairs": [
          {"word": "buenos días", "translation": "good morning"},
          {"word": "buenas tardes", "translation": "good afternoon"},
          {"word": "buenas noches", "translation": "good evening/night"},
          {"word": "hasta luego", "translation": "see you later"},
          {"word": "hasta mañana", "translation": "see you tomorrow"},
          {"word": "nos vemos", "translation": "see you"}
        ],
        "distractors": ["hola", "adiós"],
        "explanation": "Great! Remember: 'Buenos días' is used until around 12 PM, 'Buenas tardes' from 12 PM to evening, and 'Buenas noches' in the evening and night. 'Hasta luego' and 'Nos vemos' are casual ways to say goodbye."
      },
      {
        "type": "exercise",
        "id": "greetings_exercise",
        "question": "What greeting should you use at 2 PM in Spanish?",
        "options": [
          {"text": "Buenas tardes", "is_correct": true},
          {"text": "Buenos días", "is_correct": false},
          {"text": "Buenas noches", "is_correct": false},
          {"text": "Hola", "is_correct": false}
        ],
        "explanation": "Correct! 'Buenas tardes' is used in the afternoon (from around 12 PM to evening). 'Buenos días' is for morning, 'Buenas noches' is for evening/night, and 'Hola' can be used anytime but is less specific."
      },
      {
        "type": "text",
        "id": "making_requests",
        "title": "Making Requests",
        "content": "Learn polite ways to ask for things or make requests in Spanish. Using 'por favor' (please) makes your requests more polite!",
        "examples": [
          "¿Puedes ayudarme? (Can you help me?)",
          "¿Podrías repetir, por favor? (Could you repeat, please?)",
          "Necesito ayuda (I need help)",
          "Me gustaría un café (I would like a coffee)"
        ]
      },
      {
        "type": "example",
        "id": "requests_example",
        "spanish_example": "Por favor, ¿puedes ayudarme? Necesito encontrar la estación. ¿Podrías decirme dónde está?",
        "english_translation": "Please, can you help me? I need to find the station. Could you tell me where it is?",
        "explanation": "Notice how 'por favor' (please) makes the request more polite. '¿Puedes?' is casual, while '¿Podrías?' is more polite. Both are very common."
      },
      {
        "type": "matching",
        "id": "requests_matching",
        "instruction": "Match the Spanish request phrases with their English translations",
        "pairs": [
          {"word": "por favor", "translation": "please"},
          {"word": "¿puedes ayudarme?", "translation": "can you help me?"},
          {"word": "necesito", "translation": "I need"},
          {"word": "me gustaría", "translation": "I would like"},
          {"word": "¿podrías repetir?", "translation": "could you repeat?"}
        ],
        "distractors": ["gracias", "adiós"],
        "explanation": "Excellent! These are essential phrases for making requests. Remember: 'por favor' always makes your requests more polite. '¿Puedes?' is casual, '¿Podrías?' is more polite."
      },
      {
        "type": "exercise",
        "id": "requests_exercise",
        "question": "What is the difference between '¿Puedes?' and '¿Podrías?' in Spanish?",
        "options": [
          {"text": "'¿Podrías?' is more polite than '¿Puedes?'", "is_correct": true},
          {"text": "'¿Puedes?' is more polite than '¿Podrías?'", "is_correct": false},
          {"text": "They mean the same thing", "is_correct": false},
          {"text": "'¿Puedes?' is formal, '¿Podrías?' is casual", "is_correct": false}
        ],
        "explanation": "Perfect! '¿Podrías?' uses the conditional form, making it more polite than '¿Puedes?'. Use '¿Podrías?' when you want to be more respectful, especially with people you don't know well or in formal situations."
      },
      {
        "type": "text",
        "id": "asking_help",
        "title": "Asking for Help",
        "content": "When you need help or don't understand something, these phrases are essential!",
        "examples": [
          "Necesito ayuda (I need help)",
          "¿Puedes ayudarme? (Can you help me?)",
          "No entiendo (I don't understand)",
          "¿Puedes repetir? (Can you repeat?)",
          "Más despacio, por favor (More slowly, please)"
        ]
      },
      {
        "type": "example",
        "id": "help_example",
        "spanish_example": "Disculpa, no entiendo. ¿Puedes repetir más despacio, por favor?",
        "english_translation": "Excuse me, I don't understand. Can you repeat more slowly, please?",
        "explanation": "This is a very useful phrase when learning Spanish! 'No entiendo' means 'I don't understand'. 'Más despacio' means 'more slowly'. Always add 'por favor' to be polite."
      },
      {
        "type": "exercise",
        "id": "help_exercise",
        "question": "How do you politely ask someone to speak more slowly in Spanish?",
        "options": [
          {"text": "Más despacio, por favor", "is_correct": true},
          {"text": "Más rápido, por favor", "is_correct": false},
          {"text": "Más alto, por favor", "is_correct": false},
          {"text": "Repite, por favor", "is_correct": false}
        ],
        "explanation": "Perfect! 'Más despacio, por favor' means 'more slowly, please'. This is essential when learning Spanish and you need someone to slow down. Remember to always add 'por favor' to be polite."
      },
      {
        "type": "text",
        "id": "apologizing",
        "title": "Apologizing",
        "content": "Learn different ways to apologize in Spanish. The choice depends on the situation and formality.",
        "examples": [
          "Perdón (sorry) - casual, for small mistakes",
          "Disculpa (excuse me/sorry) - casual, polite",
          "Lo siento (I'm sorry) - more serious apology",
          "Perdona (forgive me) - casual, asking for forgiveness"
        ]
      },
      {
        "type": "example",
        "id": "apology_example",
        "spanish_example": "Perdón, llegué tarde. Lo siento mucho.",
        "english_translation": "Sorry, I arrived late. I'm very sorry.",
        "explanation": "'Perdón' is used for casual apologies. 'Lo siento' is more serious and shows genuine regret. 'Lo siento mucho' means 'I'm very sorry'."
      },
      {
        "type": "matching",
        "id": "apologies_matching",
        "instruction": "Match the Spanish apology phrases with their English translations",
        "pairs": [
          {"word": "perdón", "translation": "sorry"},
          {"word": "disculpa", "translation": "excuse me/sorry"},
          {"word": "lo siento", "translation": "I'm sorry"},
          {"word": "perdona", "translation": "forgive me"},
          {"word": "lo siento mucho", "translation": "I'm very sorry"}
        ],
        "distractors": ["gracias", "por favor"],
        "explanation": "Excellent! 'Perdón' and 'Disculpa' are casual, while 'Lo siento' is more serious. 'Lo siento mucho' emphasizes the apology even more. Use the appropriate one based on the situation."
      },
      {
        "type": "exercise",
        "id": "apology_exercise",
        "question": "What is the most serious way to apologize in Spanish?",
        "options": [
          {"text": "Lo siento mucho", "is_correct": true},
          {"text": "Perdón", "is_correct": false},
          {"text": "Disculpa", "is_correct": false},
          {"text": "Perdona", "is_correct": false}
        ],
        "explanation": "Correct! 'Lo siento mucho' is the most serious and emphatic way to apologize. It shows genuine regret. Use it for more serious situations, while 'Perdón' and 'Disculpa' are for casual, minor mistakes."
      },
      {
        "type": "text",
        "id": "expressing_gratitude",
        "title": "Expressing Gratitude",
        "content": "There are many ways to say thank you in Spanish, and different ways to respond!",
        "examples": [
          "Gracias (thank you)",
          "Muchas gracias (thank you very much)",
          "De nada (you're welcome)",
          "No hay de qué (don't mention it)",
          "Es un placer (it's a pleasure)"
        ]
      },
      {
        "type": "example",
        "id": "gratitude_example",
        "spanish_example": "Muchas gracias por tu ayuda. - De nada, es un placer.",
        "english_translation": "Thank you very much for your help. - You're welcome, it's a pleasure.",
        "explanation": "'Muchas gracias' is more emphatic than just 'gracias'. Common responses are 'De nada' (casual) or 'Es un placer' (more formal/polite)."
      },
      {
        "type": "exercise",
        "id": "gratitude_exercise",
        "question": "How do you say 'thank you very much' in Spanish?",
        "options": [
          {"text": "muchas gracias", "is_correct": true},
          {"text": "gracias mucho", "is_correct": false},
          {"text": "muy gracias", "is_correct": false},
          {"text": "gracias muy", "is_correct": false}
        ],
        "explanation": "Perfect! 'Muchas gracias' is the correct way to say 'thank you very much'. Remember: 'muchas' (many) comes before 'gracias', not 'muy' (very)."
      },
      {
        "type": "matching",
        "id": "gratitude_matching",
        "instruction": "Match the Spanish gratitude phrases with their English translations",
        "pairs": [
          {"word": "gracias", "translation": "thank you"},
          {"word": "muchas gracias", "translation": "thank you very much"},
          {"word": "de nada", "translation": "you're welcome"},
          {"word": "no hay de qué", "translation": "don't mention it"},
          {"word": "es un placer", "translation": "it's a pleasure"}
        ],
        "distractors": ["por favor", "perdón"],
        "explanation": "Excellent! 'Gracias' is the basic thank you, while 'Muchas gracias' is more emphatic. Common responses are 'De nada' (casual), 'No hay de qué' (polite), and 'Es un placer' (formal/polite)."
      },
      {
        "type": "exercise",
        "id": "gratitude_response_exercise",
        "question": "What is the most polite way to respond to 'Muchas gracias' in Spanish?",
        "options": [
          {"text": "De nada, es un placer", "is_correct": true},
          {"text": "De nada", "is_correct": false},
          {"text": "Gracias", "is_correct": false},
          {"text": "Por favor", "is_correct": false}
        ],
        "explanation": "Perfect! 'De nada, es un placer' is the most polite response. 'De nada' alone is casual and friendly, but adding 'es un placer' makes it more formal and polite, showing that helping was a pleasure."
      },
      {
        "type": "text",
        "id": "making_offers",
        "title": "Making Offers",
        "content": "Learn how to offer help or things to others in Spanish!",
        "examples": [
          "¿Quieres un café? (Do you want a coffee?)",
          "¿Te gustaría algo? (Would you like something?)",
          "Puedo ayudarte (I can help you)",
          "Te ayudo (I'll help you)"
        ]
      },
      {
        "type": "example",
        "id": "offers_example",
        "spanish_example": "¿Te gustaría un café? Puedo ayudarte con eso.",
        "english_translation": "Would you like a coffee? I can help you with that.",
        "explanation": "'¿Te gustaría?' is a polite way to offer something. 'Puedo ayudarte' is a friendly way to offer help. Both are very common in social situations."
      },
      {
        "type": "exercise",
        "id": "offers_exercise",
        "question": "What is the most polite way to offer something to someone in Spanish?",
        "options": [
          {"text": "¿Te gustaría un café?", "is_correct": true},
          {"text": "¿Quieres un café?", "is_correct": false},
          {"text": "Toma un café", "is_correct": false},
          {"text": "Un café para ti", "is_correct": false}
        ],
        "explanation": "Perfect! '¿Te gustaría?' is the most polite way to offer something. '¿Quieres?' is more casual. Always use the conditional form 'gustaría' for politeness when offering things to others."
      },
      {
        "type": "text",
        "id": "making_suggestions",
        "title": "Making Suggestions",
        "content": "Learn how to make suggestions and ask for opinions in Spanish!",
        "examples": [
          "¿Qué tal si vamos al cine? (How about we go to the movies?)",
          "¿Por qué no vamos al parque? (Why don't we go to the park?)",
          "¿Te parece bien? (What do you think?)",
          "Sugiero que vayamos temprano (I suggest we go early)"
        ]
      },
      {
        "type": "example",
        "id": "suggestions_example",
        "spanish_example": "¿Qué tal si vamos al restaurante? ¿Te parece bien?",
        "english_translation": "How about we go to the restaurant? What do you think?",
        "explanation": "'¿Qué tal si...?' is a casual way to make a suggestion. '¿Te parece bien?' asks for the other person's opinion. Both are very natural in conversation."
      },
      {
        "type": "exercise",
        "id": "suggestions_exercise",
        "question": "How do you ask for someone's opinion about a suggestion in Spanish?",
        "options": [
          {"text": "¿Te parece bien?", "is_correct": true},
          {"text": "¿Qué piensas?", "is_correct": false},
          {"text": "¿Estás de acuerdo?", "is_correct": false},
          {"text": "¿Vamos?", "is_correct": false}
        ],
        "explanation": "Correct! '¿Te parece bien?' is a natural way to ask for someone's opinion about a suggestion. It means 'What do you think?' or 'Does that seem good to you?'. It's very common in casual conversations."
      },
      {
        "type": "text",
        "id": "polite_expressions",
        "title": "Polite Expressions",
        "content": "These expressions make your Spanish more polite and natural!",
        "examples": [
          "Con permiso (excuse me - when passing by)",
          "Perdone (excuse me - formal)",
          "Por supuesto (of course)",
          "Claro (of course/sure - casual)"
        ]
      },
      {
        "type": "example",
        "id": "polite_example",
        "spanish_example": "Con permiso, ¿puedo pasar? - Por supuesto, claro.",
        "english_translation": "Excuse me, can I pass? - Of course, sure.",
        "explanation": "'Con permiso' is used when you need to pass by someone or get their attention. 'Por supuesto' and 'claro' both mean 'of course', but 'claro' is more casual."
      },
      {
        "type": "exercise",
        "id": "social_phrases_exercise",
        "question": "What is the most polite way to ask for help in Spanish?",
        "options": [
          {"text": "¿Podrías ayudarme, por favor?", "is_correct": true},
          {"text": "ayúdame", "is_correct": false},
          {"text": "quiero ayuda", "is_correct": false},
          {"text": "necesito ayuda ahora", "is_correct": false}
        ],
        "explanation": "Perfect! '¿Podrías ayudarme, por favor?' is the most polite way. It uses the conditional 'podrías' (could you) and includes 'por favor' (please). This shows respect and politeness."
      },
      {
        "type": "text",
        "id": "putting_it_together",
        "title": "Putting It All Together",
        "content": "Now you can combine all these phrases for natural conversations! Remember:",
        "examples": [
          "Always greet people appropriately for the time of day",
          "Use 'por favor' when making requests",
          "Say 'gracias' and respond with 'de nada'",
          "Use 'perdón' or 'disculpa' for small mistakes",
          "Be polite with 'con permiso' when passing by"
        ]
      },
      {
        "type": "example",
        "id": "complete_conversation",
        "spanish_example": "Buenos días. Disculpa, ¿puedes ayudarme? Necesito encontrar la calle principal. - Claro, por supuesto. Te ayudo. - Muchas gracias. - De nada, es un placer.",
        "english_translation": "Good morning. Excuse me, can you help me? I need to find the main street. - Of course, sure. I'll help you. - Thank you very much. - You're welcome, it's a pleasure.",
        "explanation": "This is a complete, natural conversation! Notice how it combines: greeting (Buenos días), polite request (Disculpa, ¿puedes ayudarme?), offer of help (Te ayudo), gratitude (Muchas gracias), and response (De nada, es un placer)."
      },
      {
        "type": "pronunciation",
        "id": "pronunciation_social_phrases",
        "instruction": "Practice pronouncing these essential social phrases in Spanish",
        "words": [
          {"word": "por favor", "translation": "please", "phonetic": "por fa-VOR"},
          {"word": "gracias", "translation": "thank you", "phonetic": "GRA-see-as"},
          {"word": "disculpa", "translation": "excuse me", "phonetic": "dis-KUL-pa"},
          {"word": "buenos días", "translation": "good morning", "phonetic": "BWE-nos DEE-as"},
          {"word": "muchas gracias", "translation": "thank you very much", "phonetic": "MU-chas GRA-see-as"}
        ],
        "explanation": "Great practice! Pay attention to the stress: 'por fa-VOR' (stress on 'vor'), 'GRA-see-as' (stress on 'gra'), 'dis-KUL-pa' (stress on 'kul'). Practice these phrases until they sound natural!"
      },
      {
        "type": "text",
        "id": "practice_tips",
        "title": "Practice Tips",
        "content": "Here are tips to master social and functional language:",
        "examples": [
          "Practice greeting people at different times of day",
          "Use 'por favor' and 'gracias' in every request",
          "Practice apologizing for different situations",
          "Learn to respond to 'gracias' naturally",
          "Use these phrases in real conversations whenever possible"
        ]
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'spanish_buenos_dias', 'spanish_buenas_tardes', 'spanish_buenas_noches', 'spanish_hola', 'spanish_adios',
    'spanish_hasta_luego', 'spanish_hasta_mañana', 'spanish_nos_vemos',
    'spanish_por_favor', 'spanish_puedes', 'spanish_podrias', 'spanish_me_puedes', 'spanish_necesito',
    'spanish_quiero', 'spanish_me_gustaria',
    'spanish_ayuda', 'spanish_necesito_ayuda', 'spanish_puedes_ayudarme', 'spanish_no_entiendo',
    'spanish_puedes_repetir', 'spanish_mas_despacio',
    'spanish_perdon', 'spanish_disculpa', 'spanish_lo_siento', 'spanish_perdona',
    'spanish_gracias', 'spanish_muchas_gracias', 'spanish_de_nada', 'spanish_no_hay_de_que', 'spanish_es_un_placer',
    'spanish_te_ayudo', 'spanish_quieres', 'spanish_te_gustaria', 'spanish_puedo_ayudarte',
    'spanish_que_tal', 'spanish_por_que_no', 'spanish_te_parece', 'spanish_sugiero',
    'spanish_con_permiso', 'spanish_perdone', 'spanish_por_supuesto', 'spanish_claro'
  ]::TEXT[],
  ARRAY['social_language', 'polite_expressions', 'functional_language', 'everyday_interactions', 'conversational_phrases']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  updated_at = NOW();

COMMENT ON TABLE words IS 'Vocabulary words unlocked by this lesson include greetings, requests, apologies, gratitude expressions, and social phrases';

