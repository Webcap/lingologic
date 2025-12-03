-- A1 Spanish Lesson: Likes, Dislikes, and Preferences
-- This lesson teaches how to express likes, dislikes, and preferences in Spanish

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Likes and Dislikes
('spanish_gustar', 'spanish', 'me gusta', 'I like', 'preferences'),
('spanish_me_encanta', 'spanish', 'me encanta', 'I love', 'preferences'),
('spanish_no_me_gusta', 'spanish', 'no me gusta', 'I don''t like', 'preferences'),
('spanish_odio', 'spanish', 'odio', 'I hate', 'preferences'),
('spanish_prefiero', 'spanish', 'prefiero', 'I prefer', 'preferences'),
('spanish_me_gusta_mas', 'spanish', 'me gusta más', 'I like more', 'preferences'),
-- Activities
('spanish_escuchar_musica', 'spanish', 'escuchar música', 'to listen to music', 'activities'),
('spanish_leer', 'spanish', 'leer', 'to read', 'activities'),
('spanish_ver_peliculas', 'spanish', 'ver películas', 'to watch movies', 'activities'),
('spanish_cocinar', 'spanish', 'cocinar', 'to cook', 'activities'),
('spanish_bailar', 'spanish', 'bailar', 'to dance', 'activities'),
('spanish_cantar', 'spanish', 'cantar', 'to sing', 'activities'),
('spanish_nadar', 'spanish', 'nadar', 'to swim', 'activities'),
('spanish_correr', 'spanish', 'correr', 'to run', 'activities'),
('spanish_jugar', 'spanish', 'jugar', 'to play', 'activities'),
('spanish_viajar', 'spanish', 'viajar', 'to travel', 'activities'),
-- Food Preferences
('spanish_pizza', 'spanish', 'pizza', 'pizza', 'food'),
('spanish_helado', 'spanish', 'helado', 'ice cream', 'food'),
('spanish_chocolate', 'spanish', 'chocolate', 'chocolate', 'food'),
('spanish_frutas', 'spanish', 'frutas', 'fruits', 'food'),
('spanish_verduras', 'spanish', 'verduras', 'vegetables', 'food'),
-- Questions
('spanish_que_te_gusta', 'spanish', '¿qué te gusta?', 'what do you like?', 'questions'),
('spanish_te_gusta', 'spanish', '¿te gusta?', 'do you like?', 'questions'),
('spanish_cual_prefieres', 'spanish', '¿cuál prefieres?', 'which do you prefer?', 'questions'),
-- Responses
('spanish_si_me_gusta', 'spanish', 'sí, me gusta', 'yes, I like it', 'responses'),
('spanish_no_no_me_gusta', 'spanish', 'no, no me gusta', 'no, I don''t like it', 'responses'),
('spanish_tambien', 'spanish', 'también', 'also/too', 'responses'),
('spanish_tampoco', 'spanish', 'tampoco', 'neither/me either', 'responses'),
-- Modifiers
('spanish_mucho', 'spanish', 'mucho', 'a lot', 'modifiers'),
('spanish_poco', 'spanish', 'poco', 'a little', 'modifiers'),
('spanish_bastante', 'spanish', 'bastante', 'quite/enough', 'modifiers')
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
  'spanish_a1_likes_dislikes',
  'Likes, Dislikes, and Preferences',
  'Learn how to express what you like, dislike, and prefer in Spanish. Essential for everyday conversations!',
  'spanish',
  'vocabulary',
  'A1',
  4,
  30,
  $lesson_json${
    "sections": [
      {
        "type": "text",
        "id": "likes_intro",
        "title": "Expressing Likes",
        "content": "In Spanish, to say 'I like something', we use 'me gusta' (for singular things) or 'me gustan' (for plural things). This is different from English! In Spanish, the thing you like becomes the subject of the sentence.",
        "examples": [
          "'Me gusta el café' means 'I like coffee' (literally: 'Coffee is pleasing to me')",
          "'Me gustan las películas' means 'I like movies' (literally: 'Movies are pleasing to me')",
          "Use 'me encanta' for 'I love' (stronger than 'me gusta')"
        ]
      },
      {
        "type": "example",
        "id": "likes_example_1",
        "spanish_example": "A: ¿Qué te gusta hacer? / B: Me gusta leer y escuchar música.",
        "english_translation": "A: What do you like to do? / B: I like to read and listen to music.",
        "explanation": "Notice how we use 'me gusta' with verbs (like 'leer' and 'escuchar'). When talking about activities, we use the infinitive form of the verb after 'gusta'."
      },
      {
        "type": "example",
        "id": "likes_example_2",
        "spanish_example": "Me encanta la pizza. / Me gusta mucho el helado.",
        "english_translation": "I love pizza. / I like ice cream a lot.",
        "explanation": "'Me encanta' expresses strong liking (love), while 'me gusta mucho' means 'I like it a lot'. Both can be used to express strong preferences."
      },
      {
        "type": "exercise",
        "id": "likes_exercise_1",
        "question": "How do you say 'I like chocolate' in Spanish?",
        "options": [
          {"text": "Me gusta el chocolate", "is_correct": true},
          {"text": "Yo gusto chocolate", "is_correct": false},
          {"text": "Me gusto chocolate", "is_correct": false},
          {"text": "Gusto el chocolate", "is_correct": false}
        ],
        "explanation": "Use 'me gusta' followed by the article 'el' and the thing you like. Remember: in Spanish, the thing you like is the subject, not 'I'."
      },
      {
        "type": "text",
        "id": "dislikes_intro",
        "title": "Expressing Dislikes",
        "content": "To express that you don't like something, simply add 'no' before 'me gusta'. For strong dislikes, you can use 'no me gusta nada' (I don't like it at all) or 'odio' (I hate).",
        "examples": [
          "'No me gusta' means 'I don't like'",
          "'No me gusta nada' means 'I don't like it at all'",
          "'Odio' means 'I hate' (use carefully, it's very strong)"
        ]
      },
      {
        "type": "example",
        "id": "dislikes_example_1",
        "spanish_example": "A: ¿Te gusta el deporte? / B: No, no me gusta. Prefiero leer.",
        "english_translation": "A: Do you like sports? / B: No, I don't like it. I prefer to read.",
        "explanation": "To answer 'no' to a question, say 'no, no me gusta'. Notice the double 'no' - one answers the question, the other is part of 'no me gusta'."
      },
      {
        "type": "exercise",
        "id": "dislikes_exercise_1",
        "question": "How do you say 'I don't like vegetables' in Spanish?",
        "options": [
          {"text": "No me gustan las verduras", "is_correct": true},
          {"text": "No gusto las verduras", "is_correct": false},
          {"text": "Me no gusta verduras", "is_correct": false},
          {"text": "No me gusta las verduras", "is_correct": false}
        ],
        "explanation": "Use 'no me gustan' (plural) for plural things like 'las verduras'. Remember: plural things use 'gustan', not 'gusta'."
      },
      {
        "type": "text",
        "id": "preferences_intro",
        "title": "Expressing Preferences",
        "content": "To say what you prefer, use 'prefiero' (I prefer). You can also use 'me gusta más' (I like more) to compare two things. These are useful for making choices and expressing your preferences.",
        "examples": [
          "'Prefiero' means 'I prefer' and is followed by a noun or infinitive verb",
          "'Me gusta más' means 'I like more' and is used for comparisons",
          "Use '¿Cuál prefieres?' to ask 'Which do you prefer?'"
        ]
      },
      {
        "type": "example",
        "id": "preferences_example_1",
        "spanish_example": "A: ¿Prefieres el café o el té? / B: Prefiero el café. Me gusta más.",
        "english_translation": "A: Do you prefer coffee or tea? / B: I prefer coffee. I like it more.",
        "explanation": "When choosing between options, you can use 'prefiero' or 'me gusta más'. Both express preference for one thing over another."
      },
      {
        "type": "example",
        "id": "preferences_example_2",
        "spanish_example": "Prefiero cocinar que comer en restaurantes.",
        "english_translation": "I prefer to cook than to eat in restaurants.",
        "explanation": "When comparing actions, use 'prefiero [action 1] que [action 2]' to say 'I prefer [action 1] than [action 2]'."
      },
      {
        "type": "exercise",
        "id": "preferences_exercise_1",
        "question": "How do you say 'I prefer pizza' in Spanish?",
        "options": [
          {"text": "Prefiero la pizza", "is_correct": true},
          {"text": "Me prefiero pizza", "is_correct": false},
          {"text": "Prefero pizza", "is_correct": false},
          {"text": "Pizza prefiero", "is_correct": false}
        ],
        "explanation": "'Prefiero' means 'I prefer' and is followed directly by the thing you prefer. Use 'la pizza' (the pizza) for clarity."
      },
      {
        "type": "text",
        "id": "activities_intro",
        "title": "Talking About Activities",
        "content": "When talking about activities you like or dislike, use the infinitive form of the verb after 'me gusta' or 'no me gusta'. Common activities include reading, listening to music, watching movies, cooking, and sports.",
        "examples": [
          "'Me gusta leer' means 'I like to read'",
          "'Me gusta escuchar música' means 'I like to listen to music'",
          "'No me gusta cocinar' means 'I don't like to cook'"
        ]
      },
      {
        "type": "example",
        "id": "activities_example_1",
        "spanish_example": "Me gusta bailar y cantar. También me gusta nadar.",
        "english_translation": "I like to dance and sing. I also like to swim.",
        "explanation": "You can list multiple activities with 'y' (and). Use 'también' (also) to add more activities you like."
      },
      {
        "type": "exercise",
        "id": "activities_exercise_1",
        "question": "How do you say 'I like to travel' in Spanish?",
        "options": [
          {"text": "Me gusta viajar", "is_correct": true},
          {"text": "Me gusta viajo", "is_correct": false},
          {"text": "Me gusto viajar", "is_correct": false},
          {"text": "Yo gusto viajar", "is_correct": false}
        ],
        "explanation": "Use 'me gusta' followed by the infinitive form of the verb. 'Viajar' is the infinitive (to travel), not a conjugated form."
      },
      {
        "type": "text",
        "id": "agreement_intro",
        "title": "Agreeing and Disagreeing",
        "content": "When someone shares their likes or dislikes, you can agree with 'también' (also/me too) if you like the same thing, or 'tampoco' (neither/me either) if you also don't like it. This makes conversations flow naturally.",
        "examples": [
          "'También' means 'also' or 'me too' when agreeing with a positive statement",
          "'Tampoco' means 'neither' or 'me either' when agreeing with a negative statement",
          "Use these to show you share the same preference"
        ]
      },
      {
        "type": "example",
        "id": "agreement_example_1",
        "spanish_example": "A: Me gusta el chocolate. / B: ¡A mí también! / A: No me gusta cocinar. / B: A mí tampoco.",
        "english_translation": "A: I like chocolate. / B: Me too! / A: I don't like to cook. / B: Me either.",
        "explanation": "Use 'a mí también' (me too) to agree with likes, and 'a mí tampoco' (me either) to agree with dislikes. You can also just say 'también' or 'tampoco'."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "What's the correct way to agree when someone says 'No me gusta el deporte'?",
        "options": [
          {"text": "A mí tampoco", "is_correct": true},
          {"text": "A mí también", "is_correct": false},
          {"text": "Me gusta", "is_correct": false},
          {"text": "Sí, me gusta", "is_correct": false}
        ],
        "explanation": "When someone says they DON'T like something (negative), use 'a mí tampoco' or just 'tampoco' to agree that you also don't like it."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "Complete the sentence: 'Me gusta ___ y ___ música.'",
        "options": [
          {"text": "leer, escuchar", "is_correct": true},
          {"text": "leo, escucho", "is_correct": false},
          {"text": "leyendo, escuchando", "is_correct": false},
          {"text": "leído, escuchado", "is_correct": false}
        ],
        "explanation": "After 'me gusta', use the infinitive form of verbs: 'leer' (to read) and 'escuchar' (to listen to). These are not conjugated."
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'spanish_gustar',
    'spanish_me_encanta',
    'spanish_no_me_gusta',
    'spanish_odio',
    'spanish_prefiero',
    'spanish_me_gusta_mas',
    'spanish_escuchar_musica',
    'spanish_leer',
    'spanish_ver_peliculas',
    'spanish_cocinar',
    'spanish_bailar',
    'spanish_cantar',
    'spanish_nadar',
    'spanish_correr',
    'spanish_jugar',
    'spanish_viajar',
    'spanish_pizza',
    'spanish_helado',
    'spanish_chocolate',
    'spanish_frutas',
    'spanish_verduras',
    'spanish_que_te_gusta',
    'spanish_te_gusta',
    'spanish_cual_prefieres',
    'spanish_si_me_gusta',
    'spanish_no_no_me_gusta',
    'spanish_tambien',
    'spanish_tampoco',
    'spanish_mucho',
    'spanish_poco',
    'spanish_bastante'
  ]::TEXT[],
  ARRAY['likes_dislikes', 'preferences', 'me_gusta', 'gustar_verb', 'preferir']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  level = EXCLUDED.level,
  updated_at = NOW();

