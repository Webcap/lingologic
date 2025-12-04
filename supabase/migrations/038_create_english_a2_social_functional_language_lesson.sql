-- A2 English Lesson: Social & Functional Language
-- This lesson teaches essential social phrases and functional language for everyday interactions in English

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Greetings and Farewells
('english_good_morning', 'english', 'good morning', 'good morning', 'greetings'),
('english_good_afternoon', 'english', 'good afternoon', 'good afternoon', 'greetings'),
('english_good_evening', 'english', 'good evening', 'good evening', 'greetings'),
('english_hello', 'english', 'hello', 'hello', 'greetings'),
('english_hi', 'english', 'hi', 'hi', 'greetings'),
('english_goodbye', 'english', 'goodbye', 'goodbye', 'greetings'),
('english_see_you_later', 'english', 'see you later', 'see you later', 'greetings'),
('english_see_you_tomorrow', 'english', 'see you tomorrow', 'see you tomorrow', 'greetings'),
('english_take_care', 'english', 'take care', 'take care', 'greetings'),
-- Making Requests
('english_please', 'english', 'please', 'please', 'requests'),
('english_can_you', 'english', 'can you', 'can you', 'requests'),
('english_could_you', 'english', 'could you', 'could you', 'requests'),
('english_would_you', 'english', 'would you', 'would you', 'requests'),
('english_i_need', 'english', 'I need', 'I need', 'requests'),
('english_i_want', 'english', 'I want', 'I want', 'requests'),
('english_i_would_like', 'english', 'I would like', 'I would like', 'requests'),
-- Asking for Help
('english_help', 'english', 'help', 'help', 'help'),
('english_i_need_help', 'english', 'I need help', 'I need help', 'help'),
('english_can_you_help_me', 'english', 'can you help me', 'can you help me', 'help'),
('english_i_dont_understand', 'english', 'I don''t understand', 'I don''t understand', 'help'),
('english_can_you_repeat', 'english', 'can you repeat', 'can you repeat', 'help'),
('english_slowly', 'english', 'slowly', 'slowly', 'help'),
('english_more_slowly', 'english', 'more slowly', 'more slowly', 'help'),
-- Apologizing
('english_sorry', 'english', 'sorry', 'sorry', 'apologies'),
('english_excuse_me', 'english', 'excuse me', 'excuse me', 'apologies'),
('english_i_am_sorry', 'english', 'I am sorry', 'I''m sorry', 'apologies'),
('english_pardon_me', 'english', 'pardon me', 'pardon me', 'apologies'),
('english_my_fault', 'english', 'my fault', 'my fault', 'apologies'),
-- Expressing Gratitude
('english_thank_you', 'english', 'thank you', 'thank you', 'gratitude'),
('english_thanks', 'english', 'thanks', 'thanks', 'gratitude'),
('english_thank_you_very_much', 'english', 'thank you very much', 'thank you very much', 'gratitude'),
('english_youre_welcome', 'english', 'you''re welcome', 'you''re welcome', 'gratitude'),
('english_no_problem', 'english', 'no problem', 'no problem', 'gratitude'),
('english_dont_mention_it', 'english', 'don''t mention it', 'don''t mention it', 'gratitude'),
('english_my_pleasure', 'english', 'my pleasure', 'my pleasure', 'gratitude'),
-- Making Offers
('english_i_can_help', 'english', 'I can help', 'I can help', 'offers'),
('english_let_me_help', 'english', 'let me help', 'let me help', 'offers'),
('english_do_you_want', 'english', 'do you want', 'do you want', 'offers'),
('english_would_you_like', 'english', 'would you like', 'would you like', 'offers'),
('english_can_i_help_you', 'english', 'can I help you', 'can I help you', 'offers'),
-- Making Suggestions
('english_how_about', 'english', 'how about', 'how about', 'suggestions'),
('english_why_dont_we', 'english', 'why don''t we', 'why don''t we', 'suggestions'),
('english_what_do_you_think', 'english', 'what do you think', 'what do you think', 'suggestions'),
('english_i_suggest', 'english', 'I suggest', 'I suggest', 'suggestions'),
('english_lets', 'english', 'let''s', 'let''s', 'suggestions'),
-- Polite Expressions
('english_excuse_me_passing', 'english', 'excuse me', 'excuse me (when passing)', 'polite'),
('english_pardon', 'english', 'pardon', 'pardon', 'polite'),
('english_of_course', 'english', 'of course', 'of course', 'polite'),
('english_sure', 'english', 'sure', 'sure', 'polite'),
('english_certainly', 'english', 'certainly', 'certainly', 'polite')
ON CONFLICT (id) DO NOTHING;

-- Create the A2 English lesson with comprehensive content
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
  'english_a2_social_functional_language',
  'Social & Functional Language',
  'Master essential social phrases and functional language for everyday interactions in English! Learn to greet, make requests, apologize, and express gratitude naturally.',
  'english',
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
        "content": "Welcome! This lesson teaches you essential phrases for everyday social interactions in English. You'll learn how to greet people, make requests, ask for help, apologize, and express gratitude in natural, polite ways.",
        "examples": [
          "Greeting someone: 'Good morning'",
          "Making a request: 'Can you help me?'",
          "Expressing gratitude: 'Thank you very much'"
        ]
      },
      {
        "type": "text",
        "id": "greetings_farewells",
        "title": "Greetings and Farewells",
        "content": "English has different greetings for different times of day and situations. Learn when to use each one!",
        "examples": [
          "Good morning - used until around 12 PM",
          "Good afternoon - used from 12 PM to around 5 PM",
          "Good evening - used in the evening",
          "Hello / Hi - can be used anytime, casual"
        ]
      },
      {
        "type": "example",
        "id": "greetings_example",
        "english_example": "Good morning, how are you? See you later, take care!",
        "explanation": "Notice the time-specific greeting 'Good morning' and the casual farewells 'See you later' and 'Take care'. These are very common in everyday English."
      },
      {
        "type": "matching",
        "id": "greetings_matching",
        "instruction": "Match the English greetings and farewells with their meanings",
        "pairs": [
          {"word": "good morning", "translation": "greeting used until around 12 PM"},
          {"word": "good afternoon", "translation": "greeting used from 12 PM to around 5 PM"},
          {"word": "good evening", "translation": "greeting used in the evening"},
          {"word": "see you later", "translation": "casual way to say goodbye"},
          {"word": "see you tomorrow", "translation": "goodbye when you'll meet tomorrow"},
          {"word": "take care", "translation": "friendly way to say goodbye"}
        ],
        "distractors": ["hello", "goodbye"],
        "explanation": "Great! Remember: 'Good morning' is used until around 12 PM, 'Good afternoon' from 12 PM to around 5 PM, and 'Good evening' in the evening. 'See you later' and 'Take care' are casual, friendly farewells."
      },
      {
        "type": "exercise",
        "id": "greetings_exercise",
        "question": "What greeting should you use at 2 PM in English?",
        "options": [
          {"text": "Good afternoon", "is_correct": true},
          {"text": "Good morning", "is_correct": false},
          {"text": "Good evening", "is_correct": false},
          {"text": "Hello", "is_correct": false}
        ],
        "explanation": "Correct! 'Good afternoon' is used in the afternoon (from around 12 PM to around 5 PM). 'Good morning' is for morning, 'Good evening' is for evening, and 'Hello' can be used anytime but is less specific."
      },
      {
        "type": "text",
        "id": "making_requests",
        "title": "Making Requests",
        "content": "Learn polite ways to ask for things or make requests in English. Using 'please' makes your requests more polite!",
        "examples": [
          "Can you help me? (casual)",
          "Could you repeat, please? (more polite)",
          "I need help",
          "I would like a coffee (polite)"
        ]
      },
      {
        "type": "example",
        "id": "requests_example",
        "english_example": "Please, can you help me? I need to find the station. Could you tell me where it is?",
        "explanation": "Notice how 'please' makes the request more polite. 'Can you?' is casual, while 'Could you?' is more polite. Both are very common."
      },
      {
        "type": "matching",
        "id": "requests_matching",
        "instruction": "Match the English request phrases with their meanings",
        "pairs": [
          {"word": "please", "translation": "a polite word used when asking"},
          {"word": "can you help me", "translation": "casual way to ask for help"},
          {"word": "I need", "translation": "to require something"},
          {"word": "I would like", "translation": "polite way to express a desire"},
          {"word": "could you repeat", "translation": "polite way to ask someone to say again"}
        ],
        "distractors": ["thank you", "goodbye"],
        "explanation": "Excellent! These are essential phrases for making requests. Remember: 'please' always makes your requests more polite. 'Can you?' is casual, 'Could you?' is more polite."
      },
      {
        "type": "exercise",
        "id": "requests_exercise",
        "question": "What is the difference between 'Can you?' and 'Could you?' in English?",
        "options": [
          {"text": "'Could you?' is more polite than 'Can you?'", "is_correct": true},
          {"text": "'Can you?' is more polite than 'Could you?'", "is_correct": false},
          {"text": "They mean the same thing", "is_correct": false},
          {"text": "'Can you?' is formal, 'Could you?' is casual", "is_correct": false}
        ],
        "explanation": "Perfect! 'Could you?' uses the conditional form, making it more polite than 'Can you?'. Use 'Could you?' when you want to be more respectful, especially with people you don't know well or in formal situations."
      },
      {
        "type": "text",
        "id": "asking_help",
        "title": "Asking for Help",
        "content": "When you need help or don't understand something, these phrases are essential!",
        "examples": [
          "I need help",
          "Can you help me?",
          "I don't understand",
          "Can you repeat?",
          "More slowly, please"
        ]
      },
      {
        "type": "example",
        "id": "help_example",
        "english_example": "Excuse me, I don't understand. Can you repeat more slowly, please?",
        "explanation": "This is a very useful phrase when learning English! 'I don't understand' means you need clarification. 'More slowly' asks the person to speak at a slower pace. Always add 'please' to be polite."
      },
      {
        "type": "exercise",
        "id": "help_exercise",
        "question": "How do you politely ask someone to speak more slowly in English?",
        "options": [
          {"text": "More slowly, please", "is_correct": true},
          {"text": "More quickly, please", "is_correct": false},
          {"text": "More loudly, please", "is_correct": false},
          {"text": "Repeat, please", "is_correct": false}
        ],
        "explanation": "Perfect! 'More slowly, please' means you want the person to speak at a slower pace. This is essential when learning English and you need someone to slow down. Remember to always add 'please' to be polite."
      },
      {
        "type": "text",
        "id": "apologizing",
        "title": "Apologizing",
        "content": "Learn different ways to apologize in English. The choice depends on the situation and formality.",
        "examples": [
          "Sorry - casual, for small mistakes",
          "Excuse me - when interrupting or getting attention",
          "I'm sorry - more serious apology",
          "Pardon me - formal, polite"
        ]
      },
      {
        "type": "example",
        "id": "apology_example",
        "english_example": "Sorry, I'm late. I'm very sorry.",
        "explanation": "'Sorry' is used for casual apologies. 'I'm sorry' is more serious and shows genuine regret. 'I'm very sorry' emphasizes the apology even more."
      },
      {
        "type": "matching",
        "id": "apologies_matching",
        "instruction": "Match the English apology phrases with their meanings",
        "pairs": [
          {"word": "sorry", "translation": "casual apology for small mistakes"},
          {"word": "excuse me", "translation": "when interrupting or getting attention"},
          {"word": "I'm sorry", "translation": "more serious apology"},
          {"word": "pardon me", "translation": "formal, polite apology"},
          {"word": "I'm very sorry", "translation": "emphatic, serious apology"}
        ],
        "distractors": ["thank you", "please"],
        "explanation": "Excellent! 'Sorry' is casual, while 'I'm sorry' is more serious. 'I'm very sorry' emphasizes the apology even more. Use the appropriate one based on the situation."
      },
      {
        "type": "exercise",
        "id": "apology_exercise",
        "question": "What is the most serious way to apologize in English?",
        "options": [
          {"text": "I'm very sorry", "is_correct": true},
          {"text": "Sorry", "is_correct": false},
          {"text": "Excuse me", "is_correct": false},
          {"text": "Pardon me", "is_correct": false}
        ],
        "explanation": "Correct! 'I'm very sorry' is the most serious and emphatic way to apologize. It shows genuine regret. Use it for more serious situations, while 'Sorry' and 'Excuse me' are for casual, minor mistakes."
      },
      {
        "type": "text",
        "id": "expressing_gratitude",
        "title": "Expressing Gratitude",
        "content": "There are many ways to say thank you in English, and different ways to respond!",
        "examples": [
          "Thank you / Thanks (casual)",
          "Thank you very much (more emphatic)",
          "You're welcome",
          "No problem (casual response)",
          "Don't mention it",
          "My pleasure (polite response)"
        ]
      },
      {
        "type": "example",
        "id": "gratitude_example",
        "english_example": "Thank you very much for your help. - You're welcome, my pleasure.",
        "explanation": "'Thank you very much' is more emphatic than just 'thank you'. Common responses are 'You're welcome' (standard), 'No problem' (casual), or 'My pleasure' (more formal/polite)."
      },
      {
        "type": "matching",
        "id": "gratitude_matching",
        "instruction": "Match the English gratitude phrases with their meanings",
        "pairs": [
          {"word": "thank you", "translation": "basic expression of gratitude"},
          {"word": "thank you very much", "translation": "emphatic expression of gratitude"},
          {"word": "you're welcome", "translation": "standard response to thank you"},
          {"word": "no problem", "translation": "casual response to thank you"},
          {"word": "my pleasure", "translation": "polite, formal response to thank you"}
        ],
        "distractors": ["please", "sorry"],
        "explanation": "Excellent! 'Thank you' is the basic expression, while 'Thank you very much' is more emphatic. Common responses are 'You're welcome' (standard), 'No problem' (casual), and 'My pleasure' (formal/polite)."
      },
      {
        "type": "exercise",
        "id": "gratitude_exercise",
        "question": "What is the most polite way to respond to 'Thank you very much' in English?",
        "options": [
          {"text": "You're welcome, my pleasure", "is_correct": true},
          {"text": "You're welcome", "is_correct": false},
          {"text": "Thank you", "is_correct": false},
          {"text": "Please", "is_correct": false}
        ],
        "explanation": "Perfect! 'You're welcome, my pleasure' is the most polite response. 'You're welcome' alone is standard and friendly, but adding 'my pleasure' makes it more formal and polite, showing that helping was a pleasure."
      },
      {
        "type": "exercise",
        "id": "gratitude_exercise",
        "question": "What is the most polite way to respond to 'thank you' in English?",
        "options": [
          {"text": "You're welcome, my pleasure", "is_correct": true},
          {"text": "no problem", "is_correct": false},
          {"text": "it's okay", "is_correct": false},
          {"text": "sure", "is_correct": false}
        ],
        "explanation": "Perfect! 'You're welcome, my pleasure' is the most polite response. 'No problem' is casual and friendly, but 'my pleasure' shows more formality and politeness."
      },
      {
        "type": "text",
        "id": "making_offers",
        "title": "Making Offers",
        "content": "Learn how to offer help or things to others in English!",
        "examples": [
          "Do you want a coffee? (casual)",
          "Would you like something? (more polite)",
          "I can help you",
          "Let me help you"
        ]
      },
      {
        "type": "example",
        "id": "offers_example",
        "english_example": "Would you like a coffee? I can help you with that.",
        "explanation": "'Would you like?' is a polite way to offer something. 'I can help you' is a friendly way to offer help. Both are very common in social situations."
      },
      {
        "type": "exercise",
        "id": "offers_exercise",
        "question": "What is the most polite way to offer something to someone in English?",
        "options": [
          {"text": "Would you like a coffee?", "is_correct": true},
          {"text": "Do you want a coffee?", "is_correct": false},
          {"text": "Take a coffee", "is_correct": false},
          {"text": "A coffee for you", "is_correct": false}
        ],
        "explanation": "Perfect! 'Would you like?' is the most polite way to offer something. 'Do you want?' is more casual. Always use the conditional form 'would like' for politeness when offering things to others."
      },
      {
        "type": "text",
        "id": "making_suggestions",
        "title": "Making Suggestions",
        "content": "Learn how to make suggestions and ask for opinions in English!",
        "examples": [
          "How about we go to the movies?",
          "Why don't we go to the park?",
          "What do you think?",
          "I suggest we go early",
          "Let's go together"
        ]
      },
      {
        "type": "example",
        "id": "suggestions_example",
        "english_example": "How about we go to the restaurant? What do you think?",
        "explanation": "'How about...?' is a casual way to make a suggestion. 'What do you think?' asks for the other person's opinion. Both are very natural in conversation."
      },
      {
        "type": "exercise",
        "id": "suggestions_exercise",
        "question": "How do you ask for someone's opinion about a suggestion in English?",
        "options": [
          {"text": "What do you think?", "is_correct": true},
          {"text": "Do you think?", "is_correct": false},
          {"text": "Are you agreeing?", "is_correct": false},
          {"text": "Let's go?", "is_correct": false}
        ],
        "explanation": "Correct! 'What do you think?' is a natural way to ask for someone's opinion about a suggestion. It means 'What is your opinion?' or 'Do you agree?'. It's very common in casual conversations."
      },
      {
        "type": "text",
        "id": "polite_expressions",
        "title": "Polite Expressions",
        "content": "These expressions make your English more polite and natural!",
        "examples": [
          "Excuse me (when passing by or getting attention)",
          "Pardon (when you didn't hear something)",
          "Of course (agreeing politely)",
          "Sure / Certainly (agreeing, casual to formal)"
        ]
      },
      {
        "type": "example",
        "id": "polite_example",
        "english_example": "Excuse me, can I pass? - Of course, certainly.",
        "explanation": "'Excuse me' is used when you need to pass by someone or get their attention. 'Of course' and 'certainly' both mean 'yes, definitely', but 'certainly' is more formal."
      },
      {
        "type": "exercise",
        "id": "social_phrases_exercise",
        "question": "What is the most polite way to ask for help in English?",
        "options": [
          {"text": "Could you help me, please?", "is_correct": true},
          {"text": "help me", "is_correct": false},
          {"text": "I want help", "is_correct": false},
          {"text": "I need help now", "is_correct": false}
        ],
        "explanation": "Perfect! 'Could you help me, please?' is the most polite way. It uses the conditional 'could' (more polite than 'can') and includes 'please'. This shows respect and politeness."
      },
      {
        "type": "text",
        "id": "putting_it_together",
        "title": "Putting It All Together",
        "content": "Now you can combine all these phrases for natural conversations! Remember:",
        "examples": [
          "Always greet people appropriately for the time of day",
          "Use 'please' when making requests",
          "Say 'thank you' and respond with 'you're welcome'",
          "Use 'sorry' or 'excuse me' appropriately",
          "Be polite with 'excuse me' when passing by"
        ]
      },
      {
        "type": "example",
        "id": "complete_conversation",
        "english_example": "Good morning. Excuse me, can you help me? I need to find Main Street. - Of course, certainly. I can help you. - Thank you very much. - You're welcome, my pleasure.",
        "explanation": "This is a complete, natural conversation! Notice how it combines: greeting (Good morning), polite request (Excuse me, can you help me?), offer of help (I can help you), gratitude (Thank you very much), and response (You're welcome, my pleasure)."
      },
      {
        "type": "pronunciation",
        "id": "pronunciation_social_phrases",
        "instruction": "Practice pronouncing these essential social phrases in English",
        "words": [
          {"word": "please", "translation": "polite word used when asking"},
          {"word": "thank you", "translation": "expression of gratitude"},
          {"word": "excuse me", "translation": "when interrupting or getting attention"},
          {"word": "good morning", "translation": "greeting used in the morning"},
          {"word": "you're welcome", "translation": "response to thank you"}
        ],
        "explanation": "Great practice! Pay attention to the stress and pronunciation: 'please' (PLEEZ), 'thank you' (THANK YOO), 'excuse me' (ex-KYOOS MEE). Practice these phrases until they sound natural!"
      },
      {
        "type": "text",
        "id": "practice_tips",
        "title": "Practice Tips",
        "content": "Here are tips to master social and functional language:",
        "examples": [
          "Practice greeting people at different times of day",
          "Use 'please' and 'thank you' in every request",
          "Practice apologizing for different situations",
          "Learn to respond to 'thank you' naturally",
          "Use these phrases in real conversations whenever possible"
        ]
      }
    ]
  }$lesson_json$,
  ARRAY[
    'english_good_morning', 'english_good_afternoon', 'english_good_evening', 'english_hello', 'english_hi',
    'english_goodbye', 'english_see_you_later', 'english_see_you_tomorrow', 'english_take_care',
    'english_please', 'english_can_you', 'english_could_you', 'english_would_you', 'english_i_need',
    'english_i_want', 'english_i_would_like',
    'english_help', 'english_i_need_help', 'english_can_you_help_me', 'english_i_dont_understand',
    'english_can_you_repeat', 'english_slowly', 'english_more_slowly',
    'english_sorry', 'english_excuse_me', 'english_i_am_sorry', 'english_pardon_me', 'english_my_fault',
    'english_thank_you', 'english_thanks', 'english_thank_you_very_much', 'english_youre_welcome',
    'english_no_problem', 'english_dont_mention_it', 'english_my_pleasure',
    'english_i_can_help', 'english_let_me_help', 'english_do_you_want', 'english_would_you_like', 'english_can_i_help_you',
    'english_how_about', 'english_why_dont_we', 'english_what_do_you_think', 'english_i_suggest', 'english_lets',
    'english_excuse_me_passing', 'english_pardon', 'english_of_course', 'english_sure', 'english_certainly'
  ],
  ARRAY['social_language', 'polite_expressions', 'functional_language', 'everyday_interactions', 'conversational_phrases']
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  updated_at = NOW();

COMMENT ON TABLE words IS 'Vocabulary words unlocked by this lesson include greetings, requests, apologies, gratitude expressions, and social phrases';

