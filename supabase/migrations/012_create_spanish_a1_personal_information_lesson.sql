-- A1 Spanish Lesson: Personal Information
-- This lesson teaches how to share and ask for personal information like age, nationality, occupation, and contact details

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Personal Details
('spanish_edad', 'spanish', 'edad', 'age', 'personal_info'),
('spanish_tengo', 'spanish', 'tengo', 'I am (age)', 'personal_info'),
('spanish_anos', 'spanish', 'años', 'years old', 'personal_info'),
('spanish_cumpleanos', 'spanish', 'cumpleaños', 'birthday', 'personal_info'),
('spanish_nacionalidad', 'spanish', 'nacionalidad', 'nationality', 'personal_info'),
('spanish_profesion', 'spanish', 'profesión', 'profession', 'personal_info'),
('spanish_trabajo', 'spanish', 'trabajo', 'work/job', 'personal_info'),
('spanish_estudiante', 'spanish', 'estudiante', 'student', 'personal_info'),
('spanish_profesor', 'spanish', 'profesor', 'teacher', 'personal_info'),
('spanish_medico', 'spanish', 'médico', 'doctor', 'personal_info'),
-- Contact Information
('spanish_email', 'spanish', 'correo electrónico', 'email', 'contact'),
('spanish_telefono', 'spanish', 'teléfono', 'phone', 'contact'),
('spanish_numero', 'spanish', 'número', 'number', 'contact'),
('spanish_direccion', 'spanish', 'dirección', 'address', 'contact'),
('spanish_casa', 'spanish', 'casa', 'house', 'contact'),
-- Questions
('spanish_cuantos_anos', 'spanish', '¿cuántos años tienes?', 'how old are you?', 'questions'),
('spanish_cual_es', 'spanish', '¿cuál es?', 'what is?', 'questions'),
('spanish_donde_vives', 'spanish', '¿dónde vives?', 'where do you live?', 'questions'),
('spanish_como_contactar', 'spanish', '¿cómo te puedo contactar?', 'how can I contact you?', 'questions'),
-- Common Responses
('spanish_vivo_en', 'spanish', 'vivo en', 'I live in', 'personal_info'),
('spanish_nacido_en', 'spanish', 'nacido en', 'born in', 'personal_info'),
('spanish_casado', 'spanish', 'casado', 'married', 'personal_info'),
('spanish_soltero', 'spanish', 'soltero', 'single', 'personal_info')
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
  'spanish_a1_personal_information',
  'Personal Information',
  'Learn how to share and ask for personal information including age, nationality, occupation, and contact details in Spanish.',
  'spanish',
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
        "content": "Now that you know how to greet and introduce yourself, let's learn how to share more personal details! In Spanish, you'll learn how to talk about your age, where you're from, what you do, and how people can contact you.",
        "examples": [
          "Age: 'Tengo 25 años' means 'I am 25 years old'",
          "Nationality: 'Soy de México' means 'I am from Mexico'",
          "Occupation: 'Soy estudiante' means 'I am a student'"
        ]
      },
      {
        "type": "example",
        "id": "age_example_1",
        "spanish_example": "¿Cuántos años tienes? Tengo veinticinco años.",
        "english_translation": "How old are you? I am twenty-five years old.",
        "explanation": "To ask someone's age, use '¿Cuántos años tienes?' (literally 'How many years do you have?'). To respond, use 'Tengo [number] años'."
      },
      {
        "type": "example",
        "id": "age_example_2",
        "spanish_example": "Mi cumpleaños es el 15 de marzo.",
        "english_translation": "My birthday is March 15th.",
        "explanation": "When talking about birthdays, use 'Mi cumpleaños es...' followed by the date. Notice the format: 'el [day] de [month]'."
      },
      {
        "type": "exercise",
        "id": "age_exercise_1",
        "question": "How do you say 'I am 30 years old' in Spanish?",
        "options": [
          {"text": "Tengo treinta años", "is_correct": true},
          {"text": "Soy treinta años", "is_correct": false},
          {"text": "Estoy treinta años", "is_correct": false},
          {"text": "Tengo treinta", "is_correct": false}
        ],
        "explanation": "Use 'Tengo [number] años' to express age. 'Tengo' comes from the verb 'tener' (to have)."
      },
      {
        "type": "text",
        "id": "nationality_occupation_intro",
        "title": "Nationality and Occupation",
        "content": "Let's learn how to talk about where you're from and what you do for work or study. These are common topics in conversations!",
        "examples": [
          "To say your nationality: 'Soy mexicano' (I am Mexican)",
          "To say your job: 'Soy profesor' (I am a teacher)",
          "To say you're a student: 'Soy estudiante' (I am a student)"
        ]
      },
      {
        "type": "example",
        "id": "nationality_example_1",
        "spanish_example": "¿Cuál es tu nacionalidad? Soy estadounidense.",
        "english_translation": "What is your nationality? I am American.",
        "explanation": "To ask about nationality, use '¿Cuál es tu nacionalidad?' You can respond with 'Soy [nationality]' or 'Soy de [country]'."
      },
      {
        "type": "example",
        "id": "occupation_example_1",
        "spanish_example": "¿A qué te dedicas? Soy médico.",
        "english_translation": "What do you do for work? I am a doctor.",
        "explanation": "'¿A qué te dedicas?' is a common way to ask about someone's profession. You can also ask '¿Cuál es tu profesión?'"
      },
      {
        "type": "exercise",
        "id": "occupation_exercise_1",
        "question": "Complete the sentence: 'Yo ___ estudiante.'",
        "options": [
          {"text": "soy", "is_correct": true},
          {"text": "tengo", "is_correct": false},
          {"text": "estoy", "is_correct": false},
          {"text": "vivo", "is_correct": false}
        ],
        "explanation": "Use 'soy' (from 'ser') to express identity, profession, or nationality. 'Soy estudiante' means 'I am a student'."
      },
      {
        "type": "text",
        "id": "contact_info_intro",
        "title": "Contact Information",
        "content": "In today's world, it's important to know how to exchange contact information. Let's learn how to ask for and share email addresses, phone numbers, and addresses in Spanish.",
        "examples": [
          "Email: 'Mi correo electrónico es...' (My email is...)",
          "Phone: 'Mi número de teléfono es...' (My phone number is...)",
          "Address: 'Vivo en...' (I live in...)"
        ]
      },
      {
        "type": "example",
        "id": "contact_example_1",
        "spanish_example": "¿Cuál es tu correo electrónico? Es maria@gmail.com",
        "english_translation": "What is your email address? It's maria@gmail.com",
        "explanation": "To ask for an email address, use '¿Cuál es tu correo electrónico?' You can also say '¿Cuál es tu email?'"
      },
      {
        "type": "example",
        "id": "contact_example_2",
        "spanish_example": "¿Dónde vives? Vivo en Madrid, España.",
        "english_translation": "Where do you live? I live in Madrid, Spain.",
        "explanation": "To ask where someone lives, use '¿Dónde vives?' (Where do you live?). Respond with 'Vivo en [city/place]'."
      },
      {
        "type": "exercise",
        "id": "contact_exercise_1",
        "question": "How do you ask 'Where do you live?' in Spanish?",
        "options": [
          {"text": "¿Dónde vives?", "is_correct": true},
          {"text": "¿Dónde eres?", "is_correct": false},
          {"text": "¿Dónde tienes?", "is_correct": false},
          {"text": "¿Dónde estás?", "is_correct": false}
        ],
        "explanation": "'¿Dónde vives?' uses the verb 'vivir' (to live). This is different from asking where you're from ('¿De dónde eres?')."
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
        "spanish_example": "A: Hola, me llamo Carlos. ¿Y tú?\nB: Mucho gusto, Carlos. Yo soy Ana. ¿Cuántos años tienes?\nA: Tengo veintiocho años. Soy estudiante. ¿Y tú?\nB: Yo tengo veintiséis años y soy profesora. ¿Dónde vives?\nA: Vivo en Barcelona. ¿Cuál es tu correo electrónico?",
        "english_translation": "A: Hello, my name is Carlos. And you?\nB: Nice to meet you, Carlos. I am Ana. How old are you?\nA: I am twenty-eight years old. I am a student. And you?\nB: I am twenty-six years old and I am a teacher. Where do you live?\nA: I live in Barcelona. What is your email address?",
        "explanation": "A complete conversation combining introductions, age, occupation, location, and contact information. Notice how the conversation flows naturally."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "Which sentence correctly combines personal information?",
        "options": [
          {"text": "Me llamo Luis, tengo 22 años, soy estudiante y vivo en México.", "is_correct": true},
          {"text": "Me llamo Luis, soy 22 años, tengo estudiante y estoy en México.", "is_correct": false},
          {"text": "Me llamo Luis, tengo 22, soy estudiante y vivo México.", "is_correct": false},
          {"text": "Me llamo Luis, tengo años 22, soy estudiante y vivo en México.", "is_correct": false}
        ],
        "explanation": "The correct structure: name (Me llamo), age (tengo [number] años), occupation (soy [profession]), and location (vivo en [place])."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "How would you ask someone's phone number politely?",
        "options": [
          {"text": "¿Cuál es tu número de teléfono?", "is_correct": true},
          {"text": "¿Dónde es tu teléfono?", "is_correct": false},
          {"text": "¿Cuántos teléfonos tienes?", "is_correct": false},
          {"text": "¿Tienes teléfono?", "is_correct": false}
        ],
        "explanation": "'¿Cuál es tu número de teléfono?' is the polite way to ask for someone's phone number. 'Número' means number."
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'spanish_edad',
    'spanish_tengo',
    'spanish_anos',
    'spanish_cumpleanos',
    'spanish_nacionalidad',
    'spanish_profesion',
    'spanish_trabajo',
    'spanish_estudiante',
    'spanish_profesor',
    'spanish_medico',
    'spanish_email',
    'spanish_telefono',
    'spanish_numero',
    'spanish_direccion',
    'spanish_casa',
    'spanish_cuantos_anos',
    'spanish_cual_es',
    'spanish_donde_vives',
    'spanish_como_contactar',
    'spanish_vivo_en',
    'spanish_nacido_en',
    'spanish_casado',
    'spanish_soltero'
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

