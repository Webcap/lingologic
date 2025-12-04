-- A1 English Lesson: The Family and Relationships
-- This lesson teaches family members and relationship vocabulary in English

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Immediate Family
('english_family', 'english', 'family', 'family', 'family'),
('english_father', 'english', 'father', 'father', 'family'),
('english_mother', 'english', 'mother', 'mother', 'family'),
('english_dad', 'english', 'dad', 'dad', 'family'),
('english_mom', 'english', 'mom', 'mom', 'family'),
('english_son', 'english', 'son', 'son', 'family'),
('english_daughter', 'english', 'daughter', 'daughter', 'family'),
('english_brother', 'english', 'brother', 'brother', 'family'),
('english_sister', 'english', 'sister', 'sister', 'family'),
-- Extended Family
('english_grandfather', 'english', 'grandfather', 'grandfather', 'family'),
('english_grandmother', 'english', 'grandmother', 'grandmother', 'family'),
('english_grandparents', 'english', 'grandparents', 'grandparents', 'family'),
('english_uncle', 'english', 'uncle', 'uncle', 'family'),
('english_aunt', 'english', 'aunt', 'aunt', 'family'),
('english_cousin', 'english', 'cousin', 'cousin', 'family'),
('english_nephew', 'english', 'nephew', 'nephew', 'family'),
('english_niece', 'english', 'niece', 'niece', 'family'),
-- Relationship Terms
('english_husband', 'english', 'husband', 'husband', 'relationships'),
('english_wife', 'english', 'wife', 'wife', 'relationships'),
('english_boyfriend', 'english', 'boyfriend', 'boyfriend', 'relationships'),
('english_girlfriend', 'english', 'girlfriend', 'girlfriend', 'relationships'),
('english_only_child', 'english', 'only child', 'only child', 'family'),
('english_twins', 'english', 'twins', 'twins', 'family'),
-- Describing Family
('english_older', 'english', 'older', 'older', 'descriptors'),
('english_younger', 'english', 'younger', 'younger', 'descriptors'),
('english_married', 'english', 'married', 'married', 'relationships'),
('english_single', 'english', 'single', 'single', 'relationships'),
-- Questions
('english_how_many_siblings', 'english', 'how many siblings do you have?', 'how many siblings do you have?', 'questions'),
('english_do_you_have_siblings', 'english', 'do you have siblings?', 'do you have siblings?', 'questions'),
('english_what_is_his_name', 'english', 'what is his name?', 'what is his name?', 'questions'),
('english_what_is_her_name', 'english', 'what is her name?', 'what is her name?', 'questions'),
('english_how_old_is_he', 'english', 'how old is he?', 'how old is he?', 'questions'),
('english_how_old_is_she', 'english', 'how old is she?', 'how old is she?', 'questions')
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
  'english_a1_family_relationships',
  'The Family and Relationships',
  'Learn to talk about your family members and relationships in English. Essential vocabulary for describing your loved ones!',
  'english',
  'vocabulary',
  'A1',
  5,
  35,
  $lesson_json${
    "translations": {
      "es": {
        "title": "La Familia y las Relaciones",
        "description": "Aprende a hablar sobre los miembros de tu familia y las relaciones en inglés. ¡Vocabulario esencial para describir a tus seres queridos!"
      }
    },
    "sections": [
      {
        "type": "text",
        "id": "family_intro",
        "title": "Family Members",
        "content": "Talking about family is a common topic in conversations. Let's learn the most important family vocabulary to describe your loved ones!",
        "examples": [
          "father/mother (dad/mom)",
          "brother/sister",
          "son/daughter",
          "grandfather/grandmother"
        ],
        "translations": {
          "es": {
            "title": "Miembros de la Familia",
            "content": "Hablar de la familia es un tema común en las conversaciones. ¡Aprendamos el vocabulario familiar más importante para describir a tus seres queridos!",
            "examples": [
              "father/mother (dad/mom)",
              "brother/sister",
              "son/daughter",
              "grandfather/grandmother"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "family_example_1",
        "english_example": "My family is small. I have one brother and one sister.",
        "explanation": "Notice how we use 'I have' to talk about family members. 'Brother' and 'sister' are the words for siblings.",
        "translations": {
          "es": {
            "explanation": "Nota cómo usamos 'I have' para hablar de miembros de la familia. 'Brother' y 'sister' son las palabras para hermanos."
          }
        }
      },
      {
        "type": "example",
        "id": "family_example_2",
        "english_example": "My grandparents live in London. My grandmother cooks very well.",
        "explanation": "'Grandparents' means both grandfather and grandmother together. 'Grandmother' is just the female grandparent.",
        "translations": {
          "es": {
            "explanation": "'Grandparents' significa tanto el abuelo como la abuela juntos. 'Grandmother' es solo la abuela (la abuela femenina)."
          }
        }
      },
      {
        "type": "matching",
        "id": "family_matching_1",
        "instruction": "Match the family words with their meanings",
        "pairs": [
          {"word": "father", "translation": "dad"},
          {"word": "mother", "translation": "mom"},
          {"word": "brother", "translation": "male sibling"},
          {"word": "sister", "translation": "female sibling"},
          {"word": "grandfather", "translation": "dad's or mom's father"},
          {"word": "grandmother", "translation": "dad's or mom's mother"}
        ],
        "distractors": ["son", "daughter"],
        "explanation": "Great job! These are the basic family member words. 'Father' and 'mother' are more formal, while 'dad' and 'mom' are more casual.",
        "translations": {
          "es": {
            "instruction": "Empareja las palabras de familia con sus significados",
            "explanation": "¡Buen trabajo! Estas son las palabras básicas de miembros de la familia. 'Father' y 'mother' son más formales, mientras que 'dad' y 'mom' son más casuales."
          }
        }
      },
      {
        "type": "exercise",
        "id": "family_exercise_1",
        "question": "What do you call your female sibling?",
        "options": [
          {"text": "sister", "is_correct": true},
          {"text": "brother", "is_correct": false},
          {"text": "daughter", "is_correct": false},
          {"text": "mother", "is_correct": false}
        ],
        "explanation": "'Sister' is your female sibling. 'Brother' is your male sibling.",
        "translations": {
          "es": {
            "question": "¿Cómo llamas a tu hermana?",
            "options": [
              {"text": "sister", "is_correct": true},
              {"text": "brother", "is_correct": false},
              {"text": "daughter", "is_correct": false},
              {"text": "mother", "is_correct": false}
            ],
            "explanation": "'Sister' es tu hermana. 'Brother' es tu hermano."
          }
        }
      },
      {
        "type": "text",
        "id": "extended_family_intro",
        "title": "Extended Family",
        "content": "Now let's learn about extended family members - uncles, aunts, cousins, and more!",
        "examples": [
          "uncle/aunt (your parents' brothers and sisters)",
          "cousin (your uncle's or aunt's children)",
          "nephew/niece (your sibling's children)"
        ],
        "translations": {
          "es": {
            "title": "Familia Extendida",
            "content": "¡Ahora aprendamos sobre los miembros de la familia extendida - tíos, tías, primos y más!",
            "examples": [
              "uncle/aunt (los hermanos y hermanas de tus padres)",
              "cousin (los hijos de tus tíos o tías)",
              "nephew/niece (los hijos de tus hermanos)"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "extended_family_example_1",
        "english_example": "I have two uncles and three aunts. My cousins live in Manchester.",
        "explanation": "Use 'I have' followed by the number and family member. 'Cousin' is used for both male and female cousins in English.",
        "translations": {
          "es": {
            "explanation": "Usa 'I have' seguido del número y el miembro de la familia. 'Cousin' se usa para primos y primas en inglés."
          }
        }
      },
      {
        "type": "matching",
        "id": "extended_family_matching_1",
        "instruction": "Match the extended family members with their descriptions",
        "pairs": [
          {"word": "uncle", "translation": "father's or mother's brother"},
          {"word": "aunt", "translation": "father's or mother's sister"},
          {"word": "cousin", "translation": "uncle's or aunt's child"},
          {"word": "nephew", "translation": "brother's or sister's son"},
          {"word": "niece", "translation": "brother's or sister's daughter"}
        ],
        "explanation": "Excellent! You're learning the extended family vocabulary. In English, 'cousin' is used for both male and female cousins.",
        "translations": {
          "es": {
            "instruction": "Empareja los miembros de la familia extendida con sus descripciones",
            "explanation": "¡Excelente! Estás aprendiendo el vocabulario de la familia extendida. En inglés, 'cousin' se usa para primos y primas."
          }
        }
      },
      {
        "type": "exercise",
        "id": "extended_family_exercise_1",
        "question": "Complete: 'My ___ is named Sarah' (talking about your father's sister)",
        "options": [
          {"text": "aunt", "is_correct": true},
          {"text": "uncle", "is_correct": false},
          {"text": "cousin", "is_correct": false},
          {"text": "grandmother", "is_correct": false}
        ],
        "explanation": "'Aunt' is your father's or mother's sister. Since we're talking about a female relative, we use 'aunt'.",
        "translations": {
          "es": {
            "question": "Completa: 'My ___ is named Sarah' (hablando de la hermana de tu padre)",
            "options": [
              {"text": "aunt", "is_correct": true},
              {"text": "uncle", "is_correct": false},
              {"text": "cousin", "is_correct": false},
              {"text": "grandmother", "is_correct": false}
            ],
            "explanation": "'Aunt' es la hermana de tu padre o madre. Como estamos hablando de un pariente femenino, usamos 'aunt'."
          }
        }
      },
      {
        "type": "text",
        "id": "relationships_intro",
        "title": "Describing Relationships",
        "content": "Let's learn how to talk about marital status and relationships in English. This is important for describing your family members!",
        "examples": [
          "married (having a husband or wife)",
          "single (not married)",
          "husband/wife (married partner)"
        ],
        "translations": {
          "es": {
            "title": "Describir Relaciones",
            "content": "¡Aprendamos a hablar sobre el estado civil y las relaciones en inglés. Esto es importante para describir a los miembros de tu familia!",
            "examples": [
              "married (tener un esposo o esposa)",
              "single (no casado)",
              "husband/wife (cónyuge)"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "relationships_example_1",
        "english_example": "My sister is married. Her husband is named James.",
        "explanation": "'Is married' means she has a husband. Notice we use 'her' to say 'her husband'.",
        "translations": {
          "es": {
            "explanation": "'Is married' significa que tiene un esposo. Nota cómo usamos 'her' para decir 'her husband'."
          }
        }
      },
      {
        "type": "example",
        "id": "relationships_example_2",
        "english_example": "I am single. I don't have a girlfriend.",
        "explanation": "'I am single' means you are not married and don't have a romantic partner. 'I don't have' means 'I do not have'.",
        "translations": {
          "es": {
            "explanation": "'I am single' significa que no estás casado y no tienes una pareja romántica. 'I don't have' significa 'no tengo'."
          }
        }
      },
      {
        "type": "matching",
        "id": "relationships_matching_1",
        "instruction": "Match the relationship terms with their meanings",
        "pairs": [
          {"word": "husband", "translation": "married man"},
          {"word": "wife", "translation": "married woman"},
          {"word": "boyfriend", "translation": "male romantic partner"},
          {"word": "girlfriend", "translation": "female romantic partner"},
          {"word": "married", "translation": "having a husband or wife"},
          {"word": "single", "translation": "not married"}
        ],
        "explanation": "Perfect! You're learning relationship vocabulary. In English, we use the same word 'married' for both men and women.",
        "translations": {
          "es": {
            "instruction": "Empareja los términos de relación con sus significados",
            "explanation": "¡Perfecto! Estás aprendiendo vocabulario de relaciones. En inglés, usamos la misma palabra 'married' para hombres y mujeres."
          }
        }
      },
      {
        "type": "exercise",
        "id": "relationships_exercise_1",
        "question": "How do you say 'I am married' in English?",
        "options": [
          {"text": "I am married", "is_correct": true},
          {"text": "I am single", "is_correct": false},
          {"text": "I have married", "is_correct": false},
          {"text": "I am marriage", "is_correct": false}
        ],
        "explanation": "'I am married' is the correct way to say you have a husband or wife. We use 'am' with 'married' as an adjective.",
        "translations": {
          "es": {
            "question": "¿Cómo se dice 'Estoy casado' en inglés?",
            "options": [
              {"text": "I am married", "is_correct": true},
              {"text": "I am single", "is_correct": false},
              {"text": "I have married", "is_correct": false},
              {"text": "I am marriage", "is_correct": false}
            ],
            "explanation": "'I am married' es la forma correcta de decir que tienes un esposo o esposa. Usamos 'am' con 'married' como adjetivo."
          }
        }
      },
      {
        "type": "text",
        "id": "asking_questions_intro",
        "title": "Asking About Family",
        "content": "Now let's learn how to ask questions about someone's family. These are very useful in conversations!",
        "examples": [
          "Do you have siblings? (Do you have brothers or sisters?)",
          "How many siblings do you have?",
          "What is your brother's name?",
          "How old is your sister?"
        ],
        "translations": {
          "es": {
            "title": "Preguntar sobre la Familia",
            "content": "¡Ahora aprendamos cómo hacer preguntas sobre la familia de alguien. Estas son muy útiles en las conversaciones!",
            "examples": [
              "Do you have siblings? (¿Tienes hermanos o hermanas?)",
              "How many siblings do you have?",
              "What is your brother's name?",
              "How old is your sister?"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "asking_questions_example_1",
        "english_example": "A: Do you have siblings? / B: Yes, I have two sisters and one brother.",
        "explanation": "'Do you have siblings?' is a common question. You can answer with 'Yes' or 'No', followed by details about your family.",
        "translations": {
          "es": {
            "explanation": "'Do you have siblings?' es una pregunta común. Puedes responder con 'Yes' o 'No', seguido de detalles sobre tu familia."
          }
        }
      },
      {
        "type": "example",
        "id": "asking_questions_example_2",
        "english_example": "How old is your grandmother? She is seventy years old.",
        "explanation": "'How old is...?' means you want to know someone's age. To answer, say 'He/She is [number] years old'.",
        "translations": {
          "es": {
            "explanation": "'How old is...?' significa que quieres saber la edad de alguien. Para responder, di 'He/She is [número] years old'."
          }
        }
      },
      {
        "type": "exercise",
        "id": "asking_questions_exercise_1",
        "question": "How do you ask 'Do you have siblings?' in English?",
        "options": [
          {"text": "Do you have siblings?", "is_correct": true},
          {"text": "Do you have family?", "is_correct": false},
          {"text": "How many siblings?", "is_correct": false},
          {"text": "Do you have brother?", "is_correct": false}
        ],
        "explanation": "'Do you have siblings?' is the correct way to ask if someone has brothers or sisters. 'Siblings' means brothers and sisters together.",
        "translations": {
          "es": {
            "question": "¿Cómo preguntas '¿Tienes hermanos?' en inglés?",
            "options": [
              {"text": "Do you have siblings?", "is_correct": true},
              {"text": "Do you have family?", "is_correct": false},
              {"text": "How many siblings?", "is_correct": false},
              {"text": "Do you have brother?", "is_correct": false}
            ],
            "explanation": "'Do you have siblings?' es la forma correcta de preguntar si alguien tiene hermanos o hermanas. 'Siblings' significa hermanos y hermanas juntos."
          }
        }
      },
      {
        "type": "text",
        "id": "putting_it_together",
        "title": "Putting It All Together",
        "content": "Now you can describe your family and ask others about theirs! Practice using all the vocabulary you've learned.",
        "examples": [
          "Talking about family size: 'I have a big family'",
          "Describing family members: 'My older sister is named Emma'",
          "Asking about family: 'How many cousins do you have?'"
        ],
        "translations": {
          "es": {
            "title": "Poniendo Todo Junto",
            "content": "¡Ahora puedes describir tu familia y preguntar a otros sobre la suya! Practica usando todo el vocabulario que has aprendido.",
            "examples": [
              "Hablar del tamaño de la familia: 'I have a big family'",
              "Describir miembros de la familia: 'My older sister is named Emma'",
              "Preguntar sobre la familia: 'How many cousins do you have?'"
            ]
          }
        }
      },
      {
        "type": "matching",
        "id": "comprehensive_matching_1",
        "instruction": "Match the English words with their meanings",
        "pairs": [
          {"word": "family", "translation": "all your relatives"},
          {"word": "son", "translation": "male child"},
          {"word": "daughter", "translation": "female child"},
          {"word": "grandparents", "translation": "grandfather and grandmother"},
          {"word": "cousin", "translation": "uncle's or aunt's child"},
          {"word": "wife", "translation": "married woman"},
          {"word": "boyfriend", "translation": "male romantic partner"},
          {"word": "niece", "translation": "brother's or sister's daughter"}
        ],
        "distractors": ["daughter", "wife"],
        "explanation": "Fantastic! You've mastered the family and relationship vocabulary. Keep practicing to remember all these words!",
        "translations": {
          "es": {
            "instruction": "Empareja las palabras en inglés con sus significados",
            "explanation": "¡Fantástico! Has dominado el vocabulario de familia y relaciones. ¡Sigue practicando para recordar todas estas palabras!"
          }
        }
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "Complete the sentence: 'My ___ is five years old' (talking about your male child)",
        "options": [
          {"text": "son", "is_correct": true},
          {"text": "daughter", "is_correct": false},
          {"text": "brother", "is_correct": false},
          {"text": "nephew", "is_correct": false}
        ],
        "explanation": "'Son' means your male child. Since we're talking about a boy who is five years old, we use 'son'.",
        "translations": {
          "es": {
            "question": "Completa la oración: 'My ___ is five years old' (hablando de tu hijo)",
            "options": [
              {"text": "son", "is_correct": true},
              {"text": "daughter", "is_correct": false},
              {"text": "brother", "is_correct": false},
              {"text": "nephew", "is_correct": false}
            ],
            "explanation": "'Son' significa tu hijo. Como estamos hablando de un niño de cinco años, usamos 'son'."
          }
        }
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "How would you say 'I have three brothers and one sister'?",
        "options": [
          {"text": "I have three brothers and one sister", "is_correct": true},
          {"text": "I have three sisters and one brother", "is_correct": false},
          {"text": "I have three sons and one daughter", "is_correct": false},
          {"text": "I have three cousins and one aunt", "is_correct": false}
        ],
        "explanation": "'I have three brothers and one sister' is correct. Notice 'brothers' (plural of brother) and 'sister' (singular).",
        "translations": {
          "es": {
            "question": "¿Cómo dirías 'Tengo tres hermanos y una hermana'?",
            "options": [
              {"text": "I have three brothers and one sister", "is_correct": true},
              {"text": "I have three sisters and one brother", "is_correct": false},
              {"text": "I have three sons and one daughter", "is_correct": false},
              {"text": "I have three cousins and one aunt", "is_correct": false}
            ],
            "explanation": "'I have three brothers and one sister' es correcto. Nota 'brothers' (plural de brother) y 'sister' (singular)."
          }
        }
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'english_family',
    'english_father',
    'english_mother',
    'english_dad',
    'english_mom',
    'english_son',
    'english_daughter',
    'english_brother',
    'english_sister',
    'english_grandfather',
    'english_grandmother',
    'english_grandparents',
    'english_uncle',
    'english_aunt',
    'english_cousin',
    'english_nephew',
    'english_niece',
    'english_husband',
    'english_wife',
    'english_boyfriend',
    'english_girlfriend',
    'english_only_child',
    'english_twins',
    'english_older',
    'english_younger',
    'english_married',
    'english_single',
    'english_how_many_siblings',
    'english_do_you_have_siblings',
    'english_what_is_his_name',
    'english_what_is_her_name',
    'english_how_old_is_he',
    'english_how_old_is_she'
  ]::TEXT[],
  ARRAY['family_vocabulary', 'possessive_adjectives', 'have_verb', 'be_verb']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  level = EXCLUDED.level,
  updated_at = NOW();

