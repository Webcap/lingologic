-- A1 English Lesson: Shopping and Prices
-- This lesson teaches vocabulary for shopping and talking about prices in English

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Shopping Places
('english_store', 'english', 'store', 'store/shop', 'shopping'),
('english_shop', 'english', 'shop', 'shop/store', 'shopping'),
('english_supermarket', 'english', 'supermarket', 'supermarket', 'shopping'),
('english_market', 'english', 'market', 'market', 'shopping'),
('english_mall', 'english', 'mall', 'mall/shopping center', 'shopping'),
('english_pharmacy', 'english', 'pharmacy', 'pharmacy', 'shopping'),
-- Shopping Items
('english_product', 'english', 'product', 'product', 'shopping'),
('english_clothing', 'english', 'clothing', 'clothing', 'shopping'),
('english_shirt', 'english', 'shirt', 'shirt', 'clothing'),
('english_pants', 'english', 'pants', 'pants', 'clothing'),
('english_shoes', 'english', 'shoes', 'shoes', 'clothing'),
('english_bag', 'english', 'bag', 'bag/purse', 'shopping'),
-- Money and Prices
('english_money', 'english', 'money', 'money', 'money'),
('english_dollar', 'english', 'dollar', 'dollar', 'money'),
('english_price', 'english', 'price', 'price', 'money'),
('english_how_much', 'english', 'how much', 'how much', 'phrases'),
('english_cheap', 'english', 'cheap', 'cheap', 'descriptions'),
('english_expensive', 'english', 'expensive', 'expensive', 'descriptions'),
-- Shopping Actions
('english_buy', 'english', 'buy', 'to buy', 'verbs'),
('english_sell', 'english', 'sell', 'to sell', 'verbs'),
('english_look_for', 'english', 'look for', 'to look for', 'verbs'),
('english_find', 'english', 'find', 'to find', 'verbs'),
('english_take', 'english', 'take', 'to take/carry', 'verbs'),
-- Shopping Phrases
('english_what_looking_for', 'english', 'what are you looking for?', 'what are you looking for?', 'phrases'),
('english_i_need', 'english', 'I need', 'I need', 'phrases'),
('english_do_you_have', 'english', 'do you have...?', 'do you have...?', 'phrases'),
('english_size', 'english', 'size', 'size', 'shopping'),
('english_color_shopping', 'english', 'color', 'color', 'shopping'),
-- Numbers for Prices
('english_zero', 'english', 'zero', 'zero', 'numbers'),
('english_five', 'english', 'five', 'five', 'numbers'),
('english_ten', 'english', 'ten', 'ten', 'numbers'),
('english_twenty', 'english', 'twenty', 'twenty', 'numbers'),
('english_fifty', 'english', 'fifty', 'fifty', 'numbers'),
('english_one_hundred', 'english', 'one hundred', 'one hundred', 'numbers')
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
  'english_a1_shopping_prices',
  'Shopping and Prices',
  'Learn essential vocabulary for shopping and talking about prices in English!',
  'english',
  'vocabulary',
  'A1',
  10,
  35,
  $lesson_json${
    "sections": [
      {
        "type": "text",
        "id": "shopping_intro",
        "title": "Shopping Places",
        "content": "Shopping is part of daily life! Let's learn where to shop in English. Different places sell different things.",
        "examples": [
          "store/shop",
          "supermarket",
          "market",
          "mall",
          "pharmacy"
        ]
      },
      {
        "type": "example",
        "id": "shopping_places_example",
        "english_example": "I go to the supermarket to buy food. My sister goes to the clothing store.",
        "explanation": "Use 'go to' with shopping places: 'I go to...' or 'I'm going to...'. 'To buy' explains the purpose of going: 'I go to the store to buy shoes'."
      },
      {
        "type": "text",
        "id": "shopping_items",
        "title": "Common Shopping Items",
        "content": "Learn vocabulary for items you commonly buy when shopping!",
        "examples": [
          "clothing",
          "shirt",
          "pants",
          "shoes",
          "product"
        ]
      },
      {
        "type": "example",
        "id": "shopping_items_example",
        "english_example": "I need to buy a shirt and new shoes. I'm going to look for clothing.",
        "explanation": "'I need' means you require something. 'I'm going to look for' means you will search for something. Use 'a' before singular nouns: 'a shirt'."
      },
      {
        "type": "text",
        "id": "money_prices",
        "title": "Money and Prices",
        "content": "Talking about prices is essential when shopping! Learn how to ask about costs and describe prices.",
        "examples": [
          "money",
          "price",
          "dollar",
          "cheap",
          "expensive"
        ]
      },
      {
        "type": "example",
        "id": "prices_example",
        "english_example": "- How much does this shirt cost? - It costs twenty dollars. - It's cheap. - Yes, it's very cheap.",
        "explanation": "'How much does... cost?' is the most common way to ask about price. You can also say 'How much is...?' Both mean the same thing. 'Cheap' means low price, 'expensive' means high price."
      },
      {
        "type": "text",
        "id": "shopping_actions",
        "title": "Shopping Actions",
        "content": "Learn the verbs you need when shopping!",
        "examples": [
          "buy (to purchase)",
          "sell (to offer for sale)",
          "look for (to search)",
          "find (to discover)",
          "take (to carry away)"
        ]
      },
      {
        "type": "example",
        "id": "shopping_actions_example",
        "english_example": "I'm looking for a bag. Do you have bags? Yes, here they are. I'll buy this one.",
        "explanation": "'I'm looking for' means you're searching for something. 'Do you have...?' is a question to ask if the store has something. 'I'll buy' means 'I will buy' - future tense."
      },
      {
        "type": "text",
        "id": "shopping_phrases",
        "title": "Useful Shopping Phrases",
        "content": "Master these phrases for successful shopping!",
        "examples": [
          "How much does it cost?",
          "Do you have...?",
          "I need...",
          "What are you looking for?"
        ]
      },
      {
        "type": "example",
        "id": "shopping_phrases_example",
        "english_example": "- Hello, what are you looking for? - I need shoes. - What size? - Size ten. - And what color? - Black, please.",
        "explanation": "When shopping for clothes, you'll need to know your size and preferred color. Common sizes in the US use numbers (like 8, 10, 12) or letters (S, M, L, XL) depending on the item."
      },
      {
        "type": "matching",
        "id": "shopping_matching",
        "instruction": "Match the English words with their meanings",
        "pairs": [
          {"word": "store", "translation": "a place where you buy things"},
          {"word": "buy", "translation": "to purchase something"},
          {"word": "price", "translation": "the cost of something"},
          {"word": "cheap", "translation": "low price"},
          {"word": "expensive", "translation": "high price"},
          {"word": "clothing", "translation": "things you wear"}
        ],
        "distractors": ["money", "product"],
        "explanation": "Excellent! These are essential shopping words. Remember that 'expensive' is the opposite of 'cheap'. You can say 'It's expensive' or 'It costs a lot'."
      },
      {
        "type": "exercise",
        "id": "prices_exercise",
        "question": "How do you ask about the price of something?",
        "options": [
          {"text": "How much does it cost?", "is_correct": true},
          {"text": "How many does it cost?", "is_correct": false},
          {"text": "How long does it cost?", "is_correct": false},
          {"text": "How big does it cost?", "is_correct": false}
        ],
        "explanation": "Perfect! 'How much does it cost?' is the correct way to ask about price. You can also say 'How much is it?' Both questions are common and mean the same thing."
      },
      {
        "type": "text",
        "id": "practical_tips",
        "title": "Practical Tips",
        "content": "Here are some helpful tips for shopping in English-speaking countries:",
        "examples": [
          "Always ask 'How much does it cost?' before buying",
          "If something is too expensive, say: 'It's too expensive' or 'It's too much'",
          "To ask for a discount, say: 'Do you have any discounts?' or 'Is there a sale?'",
          "Many stores have sales on weekends and holidays",
          "Remember to say 'thank you' when leaving!"
        ]
      }
    ]
  }$lesson_json$,
  ARRAY[
    'english_store', 'english_shop', 'english_supermarket', 'english_market', 'english_mall', 'english_pharmacy',
    'english_product', 'english_clothing', 'english_shirt', 'english_pants', 'english_shoes', 'english_bag',
    'english_money', 'english_dollar', 'english_price', 'english_how_much',
    'english_cheap', 'english_expensive',
    'english_buy', 'english_sell', 'english_look_for', 'english_find', 'english_take',
    'english_what_looking_for', 'english_i_need', 'english_do_you_have', 'english_size', 'english_color_shopping'
  ],
  ARRAY['present_tense_verbs', 'question_formation', 'numbers', 'going_to_future']
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  updated_at = NOW();

COMMENT ON TABLE words IS 'Vocabulary words unlocked by this lesson include shopping places, items, prices, and shopping phrases';


