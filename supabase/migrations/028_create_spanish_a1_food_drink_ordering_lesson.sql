-- A1 Spanish Lesson: Food, Drink, and Ordering
-- This lesson teaches vocabulary for food, drinks, and ordering at restaurants in Spanish

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Basic Foods
('spanish_comida', 'spanish', 'comida', 'food', 'food'),
('spanish_agua', 'spanish', 'agua', 'water', 'drinks'),
('spanish_pan', 'spanish', 'pan', 'bread', 'food'),
('spanish_arroz', 'spanish', 'arroz', 'rice', 'food'),
('spanish_pollo', 'spanish', 'pollo', 'chicken', 'food'),
('spanish_pescado', 'spanish', 'pescado', 'fish', 'food'),
('spanish_carne', 'spanish', 'carne', 'meat', 'food'),
('spanish_verdura', 'spanish', 'verdura', 'vegetable', 'food'),
('spanish_fruta', 'spanish', 'fruta', 'fruit', 'food'),
-- Common Foods
('spanish_manzana', 'spanish', 'manzana', 'apple', 'food'),
('spanish_platano', 'spanish', 'plátano', 'banana', 'food'),
('spanish_naranja', 'spanish', 'naranja', 'orange', 'food'),
('spanish_huevo', 'spanish', 'huevo', 'egg', 'food'),
('spanish_leche', 'spanish', 'leche', 'milk', 'drinks'),
('spanish_queso', 'spanish', 'queso', 'cheese', 'food'),
('spanish_jamon', 'spanish', 'jamón', 'ham', 'food'),
('spanish_pasta', 'spanish', 'pasta', 'pasta', 'food'),
-- Drinks
('spanish_bebida', 'spanish', 'bebida', 'drink', 'drinks'),
('spanish_cafe', 'spanish', 'café', 'coffee', 'drinks'),
('spanish_te', 'spanish', 'té', 'tea', 'drinks'),
('spanish_jugo', 'spanish', 'jugo', 'juice', 'drinks'),
('spanish_refresco', 'spanish', 'refresco', 'soda', 'drinks'),
('spanish_cerveza', 'spanish', 'cerveza', 'beer', 'drinks'),
('spanish_vino', 'spanish', 'vino', 'wine', 'drinks'),
-- Restaurant Phrases
('spanish_menu', 'spanish', 'menú', 'menu', 'restaurant'),
('spanish_cuenta', 'spanish', 'cuenta', 'bill/check', 'restaurant'),
('spanish_camarero', 'spanish', 'camarero', 'waiter', 'restaurant'),
('spanish_camarera', 'spanish', 'camarera', 'waitress', 'restaurant'),
('spanish_mesa', 'spanish', 'mesa', 'table', 'restaurant'),
('spanish_restaurante', 'spanish', 'restaurante', 'restaurant', 'restaurant'),
-- Ordering
('spanish_quiero', 'spanish', 'quiero', 'I want', 'phrases'),
('spanish_deseo', 'spanish', 'deseo', 'I would like', 'phrases'),
('spanish_pedir', 'spanish', 'pedir', 'to order', 'verbs'),
('spanish_por_favor', 'spanish', 'por favor', 'please', 'phrases'),
('spanish_gracias', 'spanish', 'gracias', 'thank you', 'phrases'),
('spanish_de_nada', 'spanish', 'de nada', 'you''re welcome', 'phrases'),
-- Quantity
('spanish_uno', 'spanish', 'uno', 'one', 'numbers'),
('spanish_dos', 'spanish', 'dos', 'two', 'numbers'),
('spanish_tres', 'spanish', 'tres', 'three', 'numbers'),
('spanish_una', 'spanish', 'una', 'one (fem)', 'numbers'),
('spanish_dos_cantidad', 'spanish', 'dos', 'two', 'numbers')
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
  'spanish_a1_food_drink_ordering',
  'Food, Drink, and Ordering',
  'Learn essential vocabulary for food, drinks, and ordering at restaurants in Spanish!',
  'spanish',
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
        "content": "Food vocabulary is essential for daily life! Let's learn common foods and drinks in Spanish. These words will help you order at restaurants and shop at markets.",
        "examples": [
          "comida (food)",
          "bebida (drink)",
          "agua (water)",
          "pan (bread)",
          "pollo (chicken)",
          "pescado (fish)"
        ]
      },
      {
        "type": "example",
        "id": "basic_foods_example",
        "spanish_example": "Me gusta el pollo y el arroz. No me gusta el pescado.",
        "english_translation": "I like chicken and rice. I don't like fish.",
        "explanation": "Use 'me gusta' (I like) with singular nouns: 'Me gusta el pollo'. Use 'me gustan' with plural: 'Me gustan las manzanas' (I like apples)."
      },
      {
        "type": "text",
        "id": "fruits_vegetables",
        "title": "Fruits and Vegetables",
        "content": "Fruits and vegetables are healthy and delicious! Learn these common ones in Spanish.",
        "examples": [
          "manzana (apple)",
          "plátano (banana)",
          "naranja (orange)",
          "verdura (vegetable)",
          "fruta (fruit)"
        ]
      },
      {
        "type": "example",
        "id": "fruits_example",
        "spanish_example": "Como una manzana todos los días. Mi hermana come plátanos.",
        "english_translation": "I eat an apple every day. My sister eats bananas.",
        "explanation": "'Como' means 'I eat' and 'come' means 'he/she eats'. Use 'una' (a/an) before feminine nouns: 'una manzana'."
      },
      {
        "type": "text",
        "id": "drinks_section",
        "title": "Drinks",
        "content": "Quench your thirst with these common drinks! In Spanish, drinks are usually feminine.",
        "examples": [
          "agua (water)",
          "café (coffee)",
          "té (tea)",
          "jugo (juice)",
          "leche (milk)"
        ]
      },
      {
        "type": "example",
        "id": "drinks_example",
        "spanish_example": "Bebo agua y café por la mañana. Por la tarde bebo té.",
        "english_translation": "I drink water and coffee in the morning. In the afternoon I drink tea.",
        "explanation": "'Bebo' means 'I drink'. Note: 'agua' is feminine but uses 'el' (el agua) because it starts with a stressed 'a' sound."
      },
      {
        "type": "matching",
        "id": "food_drink_matching",
        "instruction": "Match the Spanish words with their English translations",
        "pairs": [
          {"word": "comida", "translation": "food"},
          {"word": "bebida", "translation": "drink"},
          {"word": "agua", "translation": "water"},
          {"word": "pollo", "translation": "chicken"},
          {"word": "pan", "translation": "bread"},
          {"word": "queso", "translation": "cheese"}
        ],
        "distractors": ["table", "menu"],
        "explanation": "Excellent! These are essential food words. Remember that in Spanish, nouns have gender: 'el pollo' (masculine), 'la manzana' (feminine)."
      },
      {
        "type": "text",
        "id": "restaurant_phrases",
        "title": "At the Restaurant",
        "content": "Ready to order at a restaurant? Learn these essential phrases for dining out in Spanish!",
        "examples": [
          "restaurante (restaurant)",
          "menú (menu)",
          "mesa (table)",
          "camarero/camarera (waiter/waitress)",
          "cuenta (bill/check)"
        ]
      },
      {
        "type": "example",
        "id": "restaurant_example",
        "spanish_example": "Camarero, ¿puedo ver el menú, por favor? Quiero pedir pollo y arroz.",
        "english_translation": "Waiter, can I see the menu, please? I want to order chicken and rice.",
        "explanation": "'Quiero' means 'I want'. 'Pedir' means 'to order'. Always use 'por favor' (please) when making requests - it's very important for politeness!"
      },
      {
        "type": "text",
        "id": "ordering_phrases",
        "title": "How to Order",
        "content": "Master these polite phrases for ordering food and drinks!",
        "examples": [
          "Quiero... (I want...)",
          "Deseo... (I would like...)",
          "Por favor (Please)",
          "Gracias (Thank you)",
          "De nada (You're welcome)"
        ]
      },
      {
        "type": "example",
        "id": "ordering_example",
        "spanish_example": "- Quiero un café, por favor. - Claro, ¿algo más? - No, gracias. - De nada.",
        "english_translation": "- I want a coffee, please. - Of course, anything else? - No, thank you. - You're welcome.",
        "explanation": "When ordering, 'Quiero' is common but 'Deseo' is more formal. Always end with 'por favor' and say 'gracias' when you receive something."
      },
      {
        "type": "exercise",
        "id": "ordering_exercise",
        "question": "How do you say 'I want' in Spanish?",
        "options": [
          {"text": "quiero", "is_correct": true},
          {"text": "quieres", "is_correct": false},
          {"text": "quiere", "is_correct": false},
          {"text": "queremos", "is_correct": false}
        ],
        "explanation": "Perfect! 'Quiero' means 'I want'. Use it to order: 'Quiero pollo' (I want chicken). Remember to add 'por favor' (please) to be polite!"
      },
      {
        "type": "text",
        "id": "practical_tips",
        "title": "Practical Tips",
        "content": "Here are some helpful tips for ordering food in Spanish-speaking countries:",
        "examples": [
          "Always use 'por favor' (please) when ordering",
          "Say 'gracias' when the waiter brings your food",
          "To ask for the bill, say: 'La cuenta, por favor'",
          "If you don't understand, say: 'No entiendo' (I don't understand)"
        ]
      }
    ]
  }$lesson_json$,
  ARRAY[
    'spanish_comida', 'spanish_agua', 'spanish_pan', 'spanish_arroz', 'spanish_pollo', 
    'spanish_pescado', 'spanish_carne', 'spanish_verdura', 'spanish_fruta',
    'spanish_manzana', 'spanish_platano', 'spanish_naranja', 'spanish_huevo',
    'spanish_leche', 'spanish_queso', 'spanish_jamon', 'spanish_pasta',
    'spanish_bebida', 'spanish_cafe', 'spanish_te', 'spanish_jugo',
    'spanish_refresco', 'spanish_cerveza', 'spanish_vino',
    'spanish_menu', 'spanish_cuenta', 'spanish_camarero', 'spanish_camarera',
    'spanish_mesa', 'spanish_restaurante',
    'spanish_quiero', 'spanish_deseo', 'spanish_pedir', 'spanish_por_favor',
    'spanish_gracias', 'spanish_de_nada'
  ],
  ARRAY['gustar', 'present_tense_verbs', 'singular_plural_nouns']
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  updated_at = NOW();

COMMENT ON TABLE words IS 'Vocabulary words unlocked by this lesson include food, drinks, and restaurant phrases';

