-- A1 English Lesson: Food, Drink, and Ordering
-- This lesson teaches vocabulary for food, drinks, and ordering at restaurants in English

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Basic Foods
('english_food', 'english', 'food', 'food', 'food'),
('english_water', 'english', 'water', 'water', 'drinks'),
('english_bread', 'english', 'bread', 'bread', 'food'),
('english_rice', 'english', 'rice', 'rice', 'food'),
('english_chicken', 'english', 'chicken', 'chicken', 'food'),
('english_fish', 'english', 'fish', 'fish', 'food'),
('english_meat', 'english', 'meat', 'meat', 'food'),
('english_vegetable', 'english', 'vegetable', 'vegetable', 'food'),
('english_fruit', 'english', 'fruit', 'fruit', 'food'),
-- Common Foods
('english_apple', 'english', 'apple', 'apple', 'food'),
('english_banana', 'english', 'banana', 'banana', 'food'),
('english_orange_fruit', 'english', 'orange', 'orange', 'food'),
('english_egg', 'english', 'egg', 'egg', 'food'),
('english_milk', 'english', 'milk', 'milk', 'drinks'),
('english_cheese', 'english', 'cheese', 'cheese', 'food'),
('english_ham', 'english', 'ham', 'ham', 'food'),
('english_pasta', 'english', 'pasta', 'pasta', 'food'),
-- Drinks
('english_drink', 'english', 'drink', 'drink', 'drinks'),
('english_coffee', 'english', 'coffee', 'coffee', 'drinks'),
('english_tea', 'english', 'tea', 'tea', 'drinks'),
('english_juice', 'english', 'juice', 'juice', 'drinks'),
('english_soda', 'english', 'soda', 'soda', 'drinks'),
('english_beer', 'english', 'beer', 'beer', 'drinks'),
('english_wine', 'english', 'wine', 'wine', 'drinks'),
-- Restaurant Phrases
('english_menu', 'english', 'menu', 'menu', 'restaurant'),
('english_bill', 'english', 'bill', 'bill/check', 'restaurant'),
('english_check', 'english', 'check', 'bill/check', 'restaurant'),
('english_waiter', 'english', 'waiter', 'waiter', 'restaurant'),
('english_waitress', 'english', 'waitress', 'waitress', 'restaurant'),
('english_table', 'english', 'table', 'table', 'restaurant'),
('english_restaurant', 'english', 'restaurant', 'restaurant', 'restaurant'),
-- Ordering
('english_want', 'english', 'want', 'to want', 'verbs'),
('english_would_like', 'english', 'would like', 'would like', 'phrases'),
('english_order', 'english', 'order', 'to order', 'verbs'),
('english_please', 'english', 'please', 'please', 'phrases'),
('english_thank_you', 'english', 'thank you', 'thank you', 'phrases'),
('english_you_re_welcome', 'english', 'you''re welcome', 'you''re welcome', 'phrases'),
-- Quantity
('english_one', 'english', 'one', 'one', 'numbers'),
('english_two', 'english', 'two', 'two', 'numbers'),
('english_three', 'english', 'three', 'three', 'numbers'),
('english_a_an', 'english', 'a/an', 'a/an', 'articles')
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
  'english_a1_food_drink_ordering',
  'Food, Drink, and Ordering',
  'Learn essential vocabulary for food, drinks, and ordering at restaurants in English!',
  'english',
  'vocabulary',
  'A1',
  9,
  35,
  $lesson_json${
    "sections": [
      {
        "type": "text",
        "id": "food_drink_intro",
        "title": "Food and Drinks",
        "content": "Food vocabulary is essential for daily life! Let's learn common foods and drinks in English. These words will help you order at restaurants and shop at grocery stores.",
        "examples": [
          "food",
          "drink",
          "water",
          "bread",
          "chicken",
          "fish"
        ]
      },
      {
        "type": "example",
        "id": "basic_foods_example",
        "english_example": "I like chicken and rice. I don't like fish.",
        "explanation": "Use 'like' to express preference: 'I like...' (positive) or 'I don't like...' (negative). You can use 'and' to connect foods: 'chicken and rice'."
      },
      {
        "type": "text",
        "id": "fruits_vegetables",
        "title": "Fruits and Vegetables",
        "content": "Fruits and vegetables are healthy and delicious! Learn these common ones in English.",
        "examples": [
          "apple",
          "banana",
          "orange",
          "vegetable",
          "fruit"
        ]
      },
      {
        "type": "example",
        "id": "fruits_example",
        "english_example": "I eat an apple every day. My sister eats bananas for breakfast.",
        "explanation": "'Eat' means to consume food. Use 'an' before words starting with vowels: 'an apple', 'an egg'. Use 'a' before consonants: 'a banana', 'a sandwich'."
      },
      {
        "type": "text",
        "id": "drinks_section",
        "title": "Drinks",
        "content": "Quench your thirst with these common drinks! All drinks are countable or uncountable nouns.",
        "examples": [
          "water",
          "coffee",
          "tea",
          "juice",
          "milk"
        ]
      },
      {
        "type": "example",
        "id": "drinks_example",
        "english_example": "I drink water and coffee in the morning. In the afternoon, I drink tea.",
        "explanation": "'Drink' means to consume liquids. Some drinks are uncountable (water, coffee, tea) - you don't say 'a water', just 'water' or 'a glass of water'."
      },
      {
        "type": "text",
        "id": "restaurant_phrases",
        "title": "At the Restaurant",
        "content": "Ready to order at a restaurant? Learn these essential phrases for dining out in English!",
        "examples": [
          "restaurant",
          "menu",
          "table",
          "waiter/waitress",
          "bill/check"
        ]
      },
      {
        "type": "example",
        "id": "restaurant_example",
        "english_example": "Waiter, can I see the menu, please? I would like to order chicken and rice.",
        "explanation": "'Can I see...?' is a polite way to ask. 'I would like...' is more polite than 'I want...'. 'Please' is very important for politeness!"
      },
      {
        "type": "text",
        "id": "ordering_phrases",
        "title": "How to Order",
        "content": "Master these polite phrases for ordering food and drinks!",
        "examples": [
          "I want...",
          "I would like...",
          "Please",
          "Thank you",
          "You're welcome"
        ]
      },
      {
        "type": "example",
        "id": "ordering_example",
        "english_example": "- I would like a coffee, please. - Of course, anything else? - No, thank you. - You're welcome.",
        "explanation": "When ordering, 'I would like' is more polite than 'I want'. Always say 'please' when making requests and 'thank you' when you receive something."
      },
      {
        "type": "matching",
        "id": "food_drink_matching",
        "instruction": "Match the English words with their meanings",
        "pairs": [
          {"word": "food", "translation": "something you eat"},
          {"word": "drink", "translation": "something you drink"},
          {"word": "water", "translation": "H2O, a liquid"},
          {"word": "chicken", "translation": "a type of meat"},
          {"word": "bread", "translation": "baked food made from flour"},
          {"word": "cheese", "translation": "dairy product"}
        ],
        "distractors": ["table", "menu"],
        "explanation": "Excellent! These are essential food words. Remember that some foods are countable (apples, bananas) and others are uncountable (rice, water)."
      },
      {
        "type": "exercise",
        "id": "ordering_exercise",
        "question": "What is a polite way to say you want something?",
        "options": [
          {"text": "I would like", "is_correct": true},
          {"text": "I want", "is_correct": false},
          {"text": "Give me", "is_correct": false},
          {"text": "I need", "is_correct": false}
        ],
        "explanation": "Perfect! 'I would like' is more polite than 'I want'. Use it when ordering: 'I would like a coffee, please.' Always remember to add 'please' to be polite!"
      },
      {
        "type": "text",
        "id": "practical_tips",
        "title": "Practical Tips",
        "content": "Here are some helpful tips for ordering food in English-speaking countries:",
        "examples": [
          "Always use 'please' when ordering",
          "Say 'thank you' when the waiter brings your food",
          "To ask for the bill, say: 'The bill, please' or 'The check, please'",
          "If you don't understand, say: 'I don't understand' or 'Could you repeat that?'"
        ]
      }
    ]
  }$lesson_json$,
  ARRAY[
    'english_food', 'english_water', 'english_bread', 'english_rice', 'english_chicken', 
    'english_fish', 'english_meat', 'english_vegetable', 'english_fruit',
    'english_apple', 'english_banana', 'english_orange_fruit', 'english_egg',
    'english_milk', 'english_cheese', 'english_ham', 'english_pasta',
    'english_drink', 'english_coffee', 'english_tea', 'english_juice',
    'english_soda', 'english_beer', 'english_wine',
    'english_menu', 'english_bill', 'english_check', 'english_waiter', 'english_waitress',
    'english_table', 'english_restaurant',
    'english_want', 'english_would_like', 'english_order', 'english_please',
    'english_thank_you', 'english_you_re_welcome'
  ],
  ARRAY['present_tense_verbs', 'countable_uncountable_nouns', 'polite_expressions']
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  updated_at = NOW();

COMMENT ON TABLE words IS 'Vocabulary words unlocked by this lesson include food, drinks, and restaurant phrases';

