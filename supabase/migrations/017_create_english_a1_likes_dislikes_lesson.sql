-- A1 English Lesson: Likes, Dislikes, and Preferences
-- This lesson teaches how to express likes, dislikes, and preferences in English

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Likes and Dislikes
('english_like', 'english', 'like', 'like', 'preferences'),
('english_love', 'english', 'love', 'love', 'preferences'),
('english_dont_like', 'english', 'don''t like', 'don''t like', 'preferences'),
('english_hate', 'english', 'hate', 'hate', 'preferences'),
('english_prefer', 'english', 'prefer', 'prefer', 'preferences'),
('english_enjoy', 'english', 'enjoy', 'enjoy', 'preferences'),
-- Activities
('english_listen_music', 'english', 'listen to music', 'listen to music', 'activities'),
('english_read', 'english', 'read', 'read', 'activities'),
('english_watch_movies', 'english', 'watch movies', 'watch movies', 'activities'),
('english_cook', 'english', 'cook', 'cook', 'activities'),
('english_dance', 'english', 'dance', 'dance', 'activities'),
('english_sing', 'english', 'sing', 'sing', 'activities'),
('english_swim', 'english', 'swim', 'swim', 'activities'),
('english_run', 'english', 'run', 'run', 'activities'),
('english_play', 'english', 'play', 'play', 'activities'),
('english_travel', 'english', 'travel', 'travel', 'activities'),
-- Food Preferences
('english_pizza', 'english', 'pizza', 'pizza', 'food'),
('english_ice_cream', 'english', 'ice cream', 'ice cream', 'food'),
('english_chocolate', 'english', 'chocolate', 'chocolate', 'food'),
('english_fruit', 'english', 'fruit', 'fruit', 'food'),
('english_vegetables', 'english', 'vegetables', 'vegetables', 'food'),
-- Questions
('english_what_like', 'english', 'what do you like?', 'what do you like?', 'questions'),
('english_do_like', 'english', 'do you like?', 'do you like?', 'questions'),
('english_which_prefer', 'english', 'which do you prefer?', 'which do you prefer?', 'questions'),
-- Responses
('english_yes_like', 'english', 'yes, I like it', 'yes, I like it', 'responses'),
('english_no_dont_like', 'english', 'no, I don''t like it', 'no, I don''t like it', 'responses'),
('english_me_too', 'english', 'me too', 'me too', 'responses'),
('english_me_neither', 'english', 'me neither', 'me neither', 'responses'),
-- Modifiers
('english_a_lot', 'english', 'a lot', 'a lot', 'modifiers'),
('english_a_little', 'english', 'a little', 'a little', 'modifiers'),
('english_really', 'english', 'really', 'really', 'modifiers'),
('english_very_much', 'english', 'very much', 'very much', 'modifiers')
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
  'english_a1_likes_dislikes',
  'Likes, Dislikes, and Preferences',
  'Learn how to express what you like, dislike, and prefer in English. Essential for everyday conversations!',
  'english',
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
        "content": "To express what you like in English, use 'I like' followed by a noun or gerund (verb + -ing). For stronger feelings, use 'I love' or 'I really like'. These are very common in everyday conversations.",
        "examples": [
          "'I like pizza' - simple statement about preference",
          "'I love chocolate' - stronger feeling than 'like'",
          "'I really like music' - emphasizes the degree of liking"
        ]
      },
      {
        "type": "example",
        "id": "likes_example_1",
        "spanish_example": "A: What do you like to do? / B: I like reading and listening to music.",
        "english_translation": "A: What do you like to do? / B: I like reading and listening to music.",
        "explanation": "When talking about activities, use 'I like' followed by the gerund form (verb + -ing): 'reading', 'listening', etc. You can list multiple activities with 'and'."
      },
      {
        "type": "example",
        "id": "likes_example_2",
        "spanish_example": "I love pizza. / I really like ice cream.",
        "english_translation": "I love pizza. / I really like ice cream.",
        "explanation": "'Love' expresses strong liking, while 'really like' means you like something a lot. Both show strong positive feelings."
      },
      {
        "type": "exercise",
        "id": "likes_exercise_1",
        "question": "How do you say 'I like chocolate' in English?",
        "options": [
          {"text": "I like chocolate", "is_correct": true},
          {"text": "I am like chocolate", "is_correct": false},
          {"text": "I liking chocolate", "is_correct": false},
          {"text": "Me like chocolate", "is_correct": false}
        ],
        "explanation": "Use 'I like' followed by the thing you like. 'Like' is a verb that means 'to enjoy' or 'to be fond of'."
      },
      {
        "type": "text",
        "id": "dislikes_intro",
        "title": "Expressing Dislikes",
        "content": "To express that you don't like something, use 'I don't like' (contraction of 'do not like'). For strong dislikes, you can use 'I hate' or 'I really don't like'. Be careful with 'hate' as it's very strong.",
        "examples": [
          "'I don't like' means you have a negative feeling about something",
          "'I really don't like' emphasizes strong dislike",
          "'I hate' is very strong - use it carefully"
        ]
      },
      {
        "type": "example",
        "id": "dislikes_example_1",
        "spanish_example": "A: Do you like vegetables? / B: No, I don't like them. I prefer fruit.",
        "english_translation": "A: Do you like vegetables? / B: No, I don't like them. I prefer fruit.",
        "explanation": "Answer 'no' questions with 'No, I don't like...' Use 'them' to refer back to the thing mentioned (vegetables)."
      },
      {
        "type": "exercise",
        "id": "dislikes_exercise_1",
        "question": "How do you say 'I don't like vegetables' in English?",
        "options": [
          {"text": "I don't like vegetables", "is_correct": true},
          {"text": "I no like vegetables", "is_correct": false},
          {"text": "I not like vegetables", "is_correct": false},
          {"text": "I doesn't like vegetables", "is_correct": false}
        ],
        "explanation": "Use 'I don't like' (with 'do not' contracted to 'don't'). The negative comes from 'don't', not from adding 'not' after the verb."
      },
      {
        "type": "text",
        "id": "preferences_intro",
        "title": "Expressing Preferences",
        "content": "To say what you prefer, use 'I prefer' followed by a noun or gerund. You can also use 'I like X more than Y' to compare two things. These are useful for making choices.",
        "examples": [
          "'I prefer' means you like one thing better than another",
          "'I like X more than Y' compares two things",
          "Use 'Which do you prefer?' to ask about someone's choice"
        ]
      },
      {
        "type": "example",
        "id": "preferences_example_1",
        "spanish_example": "A: Do you prefer coffee or tea? / B: I prefer coffee. I like it more.",
        "english_translation": "A: Do you prefer coffee or tea? / B: I prefer coffee. I like it more.",
        "explanation": "When choosing between options, use 'I prefer' or 'I like X more'. Both express that you favor one option over another."
      },
      {
        "type": "example",
        "id": "preferences_example_2",
        "spanish_example": "I prefer cooking to eating in restaurants.",
        "english_translation": "I prefer cooking to eating in restaurants.",
        "explanation": "When comparing actions, use 'I prefer [action 1] to [action 2]' to say you favor the first action."
      },
      {
        "type": "exercise",
        "id": "preferences_exercise_1",
        "question": "How do you say 'I prefer pizza' in English?",
        "options": [
          {"text": "I prefer pizza", "is_correct": true},
          {"text": "I am prefer pizza", "is_correct": false},
          {"text": "I preferring pizza", "is_correct": false},
          {"text": "Me prefer pizza", "is_correct": false}
        ],
        "explanation": "'Prefer' is a verb meaning 'to like better'. Use 'I prefer' followed by what you prefer."
      },
      {
        "type": "text",
        "id": "activities_intro",
        "title": "Talking About Activities",
        "content": "When talking about activities you like or dislike, use the gerund form (verb + -ing) after 'like', 'love', 'don't like', etc. Common activities include reading, listening to music, watching movies, cooking, and sports.",
        "examples": [
          "'I like reading' means you enjoy the activity of reading",
          "'I like listening to music' uses the gerund form",
          "'I don't like cooking' expresses dislike for an activity"
        ]
      },
      {
        "type": "example",
        "id": "activities_example_1",
        "spanish_example": "I like dancing and singing. I also enjoy swimming.",
        "english_translation": "I like dancing and singing. I also enjoy swimming.",
        "explanation": "Use gerunds (dancing, singing, swimming) after 'like' or 'enjoy'. You can list multiple activities with 'and'. 'Enjoy' is similar to 'like'."
      },
      {
        "type": "exercise",
        "id": "activities_exercise_1",
        "question": "How do you say 'I like to travel' in English?",
        "options": [
          {"text": "I like traveling", "is_correct": true},
          {"text": "I like to travel", "is_correct": true},
          {"text": "I like travel", "is_correct": false},
          {"text": "I like travels", "is_correct": false}
        ],
        "explanation": "You can use either 'I like traveling' (gerund) or 'I like to travel' (infinitive). Both are correct in English!"
      },
      {
        "type": "text",
        "id": "agreement_intro",
        "title": "Agreeing and Disagreeing",
        "content": "When someone shares their likes or dislikes, you can agree with 'Me too' if you like the same thing, or 'Me neither' if you also don't like it. This makes conversations flow naturally and shows you're listening.",
        "examples": [
          "'Me too' means you share the same positive feeling",
          "'Me neither' means you also don't like something",
          "'I do too' is another way to say 'me too'"
        ]
      },
      {
        "type": "example",
        "id": "agreement_example_1",
        "spanish_example": "A: I like chocolate. / B: Me too! / A: I don't like cooking. / B: Me neither.",
        "english_translation": "A: I like chocolate. / B: Me too! / A: I don't like cooking. / B: Me neither.",
        "explanation": "Use 'Me too' to agree with positive statements (likes), and 'Me neither' to agree with negative statements (dislikes)."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "What's the correct way to agree when someone says 'I don't like sports'?",
        "options": [
          {"text": "Me neither", "is_correct": true},
          {"text": "Me too", "is_correct": false},
          {"text": "I like", "is_correct": false},
          {"text": "Yes, I like", "is_correct": false}
        ],
        "explanation": "When someone says they DON'T like something (negative), use 'Me neither' to agree that you also don't like it."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "Complete the sentence: 'I like ___ and ___ to music.'",
        "options": [
          {"text": "reading, listening", "is_correct": true},
          {"text": "read, listen", "is_correct": false},
          {"text": "reads, listens", "is_correct": false},
          {"text": "readed, listened", "is_correct": false}
        ],
        "explanation": "After 'I like', use gerunds (verb + -ing): 'reading' and 'listening'. This form expresses the activity itself."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_3",
        "question": "How do you emphasize that you really like something?",
        "options": [
          {"text": "I really like it", "is_correct": true},
          {"text": "I very like it", "is_correct": false},
          {"text": "I much like it", "is_correct": false},
          {"text": "I like it very", "is_correct": false}
        ],
        "explanation": "Use 'really' before 'like' to emphasize. You can also say 'I like it very much' or 'I like it a lot'."
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'english_like',
    'english_love',
    'english_dont_like',
    'english_hate',
    'english_prefer',
    'english_enjoy',
    'english_listen_music',
    'english_read',
    'english_watch_movies',
    'english_cook',
    'english_dance',
    'english_sing',
    'english_swim',
    'english_run',
    'english_play',
    'english_travel',
    'english_pizza',
    'english_ice_cream',
    'english_chocolate',
    'english_fruit',
    'english_vegetables',
    'english_what_like',
    'english_do_like',
    'english_which_prefer',
    'english_yes_like',
    'english_no_dont_like',
    'english_me_too',
    'english_me_neither',
    'english_a_lot',
    'english_a_little',
    'english_really',
    'english_very_much'
  ]::TEXT[],
  ARRAY['likes_dislikes', 'preferences', 'gerunds', 'like_prefer', 'agreeing']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  level = EXCLUDED.level,
  updated_at = NOW();


