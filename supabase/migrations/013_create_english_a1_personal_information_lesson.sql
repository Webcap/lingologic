-- A1 English Lesson: Personal Information
-- This lesson teaches how to share and ask for personal information like age, nationality, occupation, and contact details

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Personal Details
('english_age', 'english', 'age', 'age', 'personal_info'),
('english_old', 'english', 'old', 'old', 'personal_info'),
('english_years', 'english', 'years', 'years', 'personal_info'),
('english_birthday', 'english', 'birthday', 'birthday', 'personal_info'),
('english_nationality', 'english', 'nationality', 'nationality', 'personal_info'),
('english_job', 'english', 'job', 'job', 'personal_info'),
('english_work', 'english', 'work', 'work', 'personal_info'),
('english_student', 'english', 'student', 'student', 'personal_info'),
('english_teacher', 'english', 'teacher', 'teacher', 'personal_info'),
('english_doctor', 'english', 'doctor', 'doctor', 'personal_info'),
-- Contact Information
('english_email_address', 'english', 'email address', 'email address', 'contact'),
('english_phone_number', 'english', 'phone number', 'phone number', 'contact'),
('english_address', 'english', 'address', 'address', 'contact'),
('english_live', 'english', 'live', 'live', 'contact'),
-- Questions
('english_how_old', 'english', 'how old are you?', 'how old are you?', 'questions'),
('english_what_is', 'english', 'what is', 'what is', 'questions'),
('english_where_do_you_live', 'english', 'where do you live?', 'where do you live?', 'questions'),
('english_what_do_you_do', 'english', 'what do you do?', 'what do you do?', 'questions'),
('english_what_is_your', 'english', 'what is your', 'what is your', 'questions'),
-- Common Responses
('english_i_am', 'english', 'I am', 'I am', 'personal_info'),
('english_i_live', 'english', 'I live', 'I live', 'personal_info'),
('english_i_work', 'english', 'I work', 'I work', 'personal_info'),
('english_i_study', 'english', 'I study', 'I study', 'personal_info'),
('english_married', 'english', 'married', 'married', 'personal_info'),
('english_single', 'english', 'single', 'single', 'personal_info')
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
  'english_a1_personal_information',
  'Personal Information',
  'Learn how to share and ask for personal information including age, nationality, occupation, and contact details in English.',
  'english',
  'vocabulary',
  'A1',
  2,
  25,
  $lesson_json${
    "sections": [
      {
        "type": "text",
        "id": "personal_info_intro",
        "title": "Sharing Personal Information",
        "content": "Now that you know how to greet and introduce yourself, let's learn how to share more personal details! In English, you'll learn how to talk about your age, where you're from, what you do, and how people can contact you.",
        "examples": [
          "Age: 'I am 25 years old' or 'I'm 25'",
          "Nationality: 'I am from the United States' or 'I am American'",
          "Occupation: 'I am a student' or 'I work as a teacher'"
        ]
      },
      {
        "type": "example",
        "id": "age_example_1",
        "spanish_example": "How old are you? I'm twenty-five years old.",
        "english_translation": "How old are you? I'm twenty-five years old.",
        "explanation": "To ask someone's age, use 'How old are you?' You can respond with 'I am [number] years old' or the shorter form 'I'm [number]'."
      },
      {
        "type": "example",
        "id": "age_example_2",
        "spanish_example": "My birthday is March 15th. When is your birthday?",
        "english_translation": "My birthday is March 15th. When is your birthday?",
        "explanation": "When talking about birthdays, use 'My birthday is...' followed by the date. You can ask 'When is your birthday?' to find out someone else's birthday."
      },
      {
        "type": "exercise",
        "id": "age_exercise_1",
        "question": "How do you ask someone's age politely?",
        "options": [
          {"text": "How old are you?", "is_correct": true},
          {"text": "What age you are?", "is_correct": false},
          {"text": "How many years you have?", "is_correct": false},
          {"text": "What is your age number?", "is_correct": false}
        ],
        "explanation": "'How old are you?' is the standard and polite way to ask about someone's age in English."
      },
      {
        "type": "text",
        "id": "nationality_occupation_intro",
        "title": "Nationality and Occupation",
        "content": "Let's learn how to talk about where you're from and what you do for work or study. These are common topics in conversations!",
        "examples": [
          "To say your nationality: 'I am American' or 'I am from the United States'",
          "To say your job: 'I am a teacher' or 'I work as a teacher'",
          "To say you're a student: 'I am a student' or 'I study at the university'"
        ]
      },
      {
        "type": "example",
        "id": "nationality_example_1",
        "spanish_example": "What's your nationality? I'm Canadian.",
        "english_translation": "What's your nationality? I'm Canadian.",
        "explanation": "To ask about nationality, you can use 'What's your nationality?' or 'Where are you from?' You can respond with 'I'm [nationality]' or 'I'm from [country]'."
      },
      {
        "type": "example",
        "id": "occupation_example_1",
        "spanish_example": "What do you do? I'm a doctor. I work at a hospital.",
        "english_translation": "What do you do? I'm a doctor. I work at a hospital.",
        "explanation": "'What do you do?' is a common way to ask about someone's profession. You can respond with 'I'm a [profession]' or 'I work as a [profession]'."
      },
      {
        "type": "exercise",
        "id": "occupation_exercise_1",
        "question": "Complete the sentence: 'I ___ a student at the university.'",
        "options": [
          {"text": "am", "is_correct": true},
          {"text": "work", "is_correct": false},
          {"text": "have", "is_correct": false},
          {"text": "do", "is_correct": false}
        ],
        "explanation": "Use 'I am' (or 'I'm') to express identity, profession, or status. 'I am a student' is the correct form."
      },
      {
        "type": "text",
        "id": "contact_info_intro",
        "title": "Contact Information",
        "content": "In today's world, it's important to know how to exchange contact information. Let's learn how to ask for and share email addresses, phone numbers, and addresses in English.",
        "examples": [
          "Email: 'My email address is...' or 'You can email me at...'",
          "Phone: 'My phone number is...' or 'You can call me at...'",
          "Address: 'I live at...' or 'My address is...'"
        ]
      },
      {
        "type": "example",
        "id": "contact_example_1",
        "spanish_example": "What's your email address? It's john.smith@gmail.com",
        "english_translation": "What's your email address? It's john.smith@gmail.com",
        "explanation": "To ask for an email address, use 'What's your email address?' or 'What's your email?' You can respond with 'It's [email]' or 'My email is [email]'."
      },
      {
        "type": "example",
        "id": "contact_example_2",
        "spanish_example": "Where do you live? I live in London, England.",
        "english_translation": "Where do you live? I live in London, England.",
        "explanation": "To ask where someone lives, use 'Where do you live?' Respond with 'I live in [city/place]' or 'I live at [address]' for a specific address."
      },
      {
        "type": "exercise",
        "id": "contact_exercise_1",
        "question": "How do you ask for someone's phone number?",
        "options": [
          {"text": "What's your phone number?", "is_correct": true},
          {"text": "Where is your phone?", "is_correct": false},
          {"text": "How many phones do you have?", "is_correct": false},
          {"text": "Do you have a phone?", "is_correct": false}
        ],
        "explanation": "'What's your phone number?' is the standard way to ask for someone's phone number. You can also say 'Can I have your phone number?'"
      },
      {
        "type": "text",
        "id": "complete_intro",
        "title": "Putting It All Together",
        "content": "Now let's see how to have a complete conversation sharing personal information. These details help people get to know you better!",
        "examples": [
          "Combine all the information: name, age, nationality, occupation, and contact",
          "Practice asking and answering questions about personal information",
          "Use polite phrases when asking for someone's details"
        ]
      },
      {
        "type": "example",
        "id": "complete_example_1",
        "spanish_example": "A: Hi, I'm Sarah. Nice to meet you!\nB: Nice to meet you too, Sarah. I'm Michael. How old are you?\nA: I'm twenty-eight years old. I'm a student. What about you?\nB: I'm thirty years old and I'm a teacher. Where do you live?\nA: I live in New York. What's your email address?\nB: It's michael.brown@email.com. What's yours?",
        "english_translation": "A: Hi, I'm Sarah. Nice to meet you!\nB: Nice to meet you too, Sarah. I'm Michael. How old are you?\nA: I'm twenty-eight years old. I'm a student. What about you?\nB: I'm thirty years old and I'm a teacher. Where do you live?\nA: I live in New York. What's your email address?\nB: It's michael.brown@email.com. What's yours?",
        "explanation": "A complete conversation combining introductions, age, occupation, location, and contact information. Notice how the conversation flows naturally and how people take turns asking questions."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "Which sentence correctly combines personal information?",
        "options": [
          {"text": "I'm David, I'm 22 years old, I'm a student and I live in Toronto.", "is_correct": true},
          {"text": "I'm David, I have 22 years, I work student and I am in Toronto.", "is_correct": false},
          {"text": "I'm David, I'm 22, I'm student and I live Toronto.", "is_correct": false},
          {"text": "I'm David, I am years 22, I'm a student and I live at Toronto.", "is_correct": false}
        ],
        "explanation": "The correct structure: name (I'm), age (I'm [number] years old), occupation (I'm a [profession]), and location (I live in [place])."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "How would you politely ask for someone's phone number?",
        "options": [
          {"text": "What's your phone number?", "is_correct": true},
          {"text": "Where is your phone?", "is_correct": false},
          {"text": "How many phones do you have?", "is_correct": false},
          {"text": "Can you give me phone?", "is_correct": false}
        ],
        "explanation": "'What's your phone number?' is the polite and standard way to ask for someone's phone number in English."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_3",
        "question": "How do you say 'I work as a teacher' in a more casual way?",
        "options": [
          {"text": "I'm a teacher", "is_correct": true},
          {"text": "I do teacher", "is_correct": false},
          {"text": "I have teacher job", "is_correct": false},
          {"text": "I make teacher", "is_correct": false}
        ],
        "explanation": "'I'm a teacher' is a casual and common way to state your profession. You can also say 'I work as a teacher' which is slightly more formal."
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'english_age',
    'english_old',
    'english_years',
    'english_birthday',
    'english_nationality',
    'english_job',
    'english_work',
    'english_student',
    'english_teacher',
    'english_doctor',
    'english_email_address',
    'english_phone_number',
    'english_address',
    'english_live',
    'english_how_old',
    'english_what_is',
    'english_where_do_you_live',
    'english_what_do_you_do',
    'english_what_is_your',
    'english_i_am',
    'english_i_live',
    'english_i_work',
    'english_i_study',
    'english_married',
    'english_single'
  ]::TEXT[],
  ARRAY['personal_information', 'asking_questions', 'contact_details']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  level = EXCLUDED.level,
  updated_at = NOW();

