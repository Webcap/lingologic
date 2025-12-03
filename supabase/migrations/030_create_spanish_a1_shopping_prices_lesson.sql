-- A1 Spanish Lesson: Shopping and Prices
-- This lesson teaches vocabulary for shopping and talking about prices in Spanish

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Shopping Places
('spanish_tienda', 'spanish', 'tienda', 'store/shop', 'shopping'),
('spanish_supermercado', 'spanish', 'supermercado', 'supermarket', 'shopping'),
('spanish_mercado', 'spanish', 'mercado', 'market', 'shopping'),
('spanish_centro_comercial', 'spanish', 'centro comercial', 'mall/shopping center', 'shopping'),
('spanish_farmacia', 'spanish', 'farmacia', 'pharmacy', 'shopping'),
-- Shopping Items
('spanish_producto', 'spanish', 'producto', 'product', 'shopping'),
('spanish_ropa', 'spanish', 'ropa', 'clothing', 'shopping'),
('spanish_camisa', 'spanish', 'camisa', 'shirt', 'clothing'),
('spanish_pantalon', 'spanish', 'pantalón', 'pants', 'clothing'),
('spanish_zapatos', 'spanish', 'zapatos', 'shoes', 'clothing'),
('spanish_bolso', 'spanish', 'bolso', 'bag/purse', 'shopping'),
-- Money and Prices
('spanish_dinero', 'spanish', 'dinero', 'money', 'money'),
('spanish_euro', 'spanish', 'euro', 'euro', 'money'),
('spanish_precio', 'spanish', 'precio', 'price', 'money'),
('spanish_cuanto_cuesta', 'spanish', '¿cuánto cuesta?', 'how much does it cost?', 'phrases'),
('spanish_cuanto_cuestan', 'spanish', '¿cuánto cuestan?', 'how much do they cost?', 'phrases'),
('spanish_barato', 'spanish', 'barato', 'cheap', 'descriptions'),
('spanish_caro', 'spanish', 'caro', 'expensive', 'descriptions'),
-- Shopping Actions
('spanish_comprar', 'spanish', 'comprar', 'to buy', 'verbs'),
('spanish_vender', 'spanish', 'vender', 'to sell', 'verbs'),
('spanish_buscar', 'spanish', 'buscar', 'to look for', 'verbs'),
('spanish_encontrar', 'spanish', 'encontrar', 'to find', 'verbs'),
('spanish_llevar', 'spanish', 'llevar', 'to take/carry', 'verbs'),
-- Shopping Phrases
('spanish_que_busca', 'spanish', '¿qué busca?', 'what are you looking for?', 'phrases'),
('spanish_necesito', 'spanish', 'necesito', 'I need', 'phrases'),
('spanish_tiene', 'spanish', '¿tiene...?', 'do you have...?', 'phrases'),
('spanish_talla', 'spanish', 'talla', 'size', 'shopping'),
('spanish_color_shopping', 'spanish', 'color', 'color', 'shopping'),
-- Numbers for Prices
('spanish_cero', 'spanish', 'cero', 'zero', 'numbers'),
('spanish_cinco', 'spanish', 'cinco', 'five', 'numbers'),
('spanish_diez', 'spanish', 'diez', 'ten', 'numbers'),
('spanish_veinte', 'spanish', 'veinte', 'twenty', 'numbers'),
('spanish_cincuenta', 'spanish', 'cincuenta', 'fifty', 'numbers'),
('spanish_cien', 'spanish', 'cien', 'one hundred', 'numbers')
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
  'spanish_a1_shopping_prices',
  'Shopping and Prices',
  'Learn essential vocabulary for shopping and talking about prices in Spanish!',
  'spanish',
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
        "content": "Shopping is part of daily life! Let's learn where to shop in Spanish. Different places sell different things.",
        "examples": [
          "tienda (store/shop)",
          "supermercado (supermarket)",
          "mercado (market)",
          "centro comercial (mall)",
          "farmacia (pharmacy)"
        ]
      },
      {
        "type": "example",
        "id": "shopping_places_example",
        "spanish_example": "Voy al supermercado para comprar comida. Mi hermana va a la tienda de ropa.",
        "english_translation": "I go to the supermarket to buy food. My sister goes to the clothing store.",
        "explanation": "Use 'ir a' (to go to) with shopping places. 'Voy' (I go), 'va' (he/she goes). 'Para comprar' means 'to buy' or 'in order to buy'."
      },
      {
        "type": "text",
        "id": "shopping_items",
        "title": "Common Shopping Items",
        "content": "Learn vocabulary for items you commonly buy when shopping!",
        "examples": [
          "ropa (clothing)",
          "camisa (shirt)",
          "pantalón (pants)",
          "zapatos (shoes)",
          "producto (product)"
        ]
      },
      {
        "type": "example",
        "id": "shopping_items_example",
        "spanish_example": "Necesito comprar una camisa y unos zapatos nuevos. Voy a buscar ropa.",
        "english_translation": "I need to buy a shirt and new shoes. I'm going to look for clothing.",
        "explanation": "'Necesito' means 'I need'. 'Buscar' means 'to look for' or 'to search'. Use 'una' (a) for feminine nouns and 'unos' for plural masculine nouns."
      },
      {
        "type": "text",
        "id": "money_prices",
        "title": "Money and Prices",
        "content": "Talking about prices is essential when shopping! Learn how to ask about costs and describe prices.",
        "examples": [
          "dinero (money)",
          "precio (price)",
          "euro (euro)",
          "barato (cheap)",
          "caro (expensive)"
        ]
      },
      {
        "type": "example",
        "id": "prices_example",
        "spanish_example": "- ¿Cuánto cuesta esta camisa? - Cuesta veinte euros. - Es barata. - Sí, es muy barata.",
        "english_translation": "- How much does this shirt cost? - It costs twenty euros. - It's cheap. - Yes, it's very cheap.",
        "explanation": "'¿Cuánto cuesta?' means 'How much does it cost?' Use 'cuesta' for singular items and 'cuestan' for plural. 'Barato/barata' means cheap, 'caro/cara' means expensive."
      },
      {
        "type": "text",
        "id": "shopping_actions",
        "title": "Shopping Actions",
        "content": "Learn the verbs you need when shopping!",
        "examples": [
          "comprar (to buy)",
          "vender (to sell)",
          "buscar (to look for)",
          "encontrar (to find)",
          "llevar (to take/carry)"
        ]
      },
      {
        "type": "example",
        "id": "shopping_actions_example",
        "spanish_example": "Busco una bolsa. ¿Tiene bolsas? Sí, aquí están. Compro esta.",
        "english_translation": "I'm looking for a bag. Do you have bags? Yes, here they are. I'll buy this one.",
        "explanation": "'Busco' means 'I'm looking for'. '¿Tiene...?' means 'Do you have...?'. 'Compro' means 'I buy' or 'I'll buy'."
      },
      {
        "type": "matching",
        "id": "shopping_matching",
        "instruction": "Match the Spanish words with their English translations",
        "pairs": [
          {"word": "tienda", "translation": "store/shop"},
          {"word": "comprar", "translation": "to buy"},
          {"word": "precio", "translation": "price"},
          {"word": "barato", "translation": "cheap"},
          {"word": "caro", "translation": "expensive"},
          {"word": "ropa", "translation": "clothing"}
        ],
        "distractors": ["money", "product"],
        "explanation": "Excellent! These are essential shopping words. Remember that 'barato' changes to 'barata' with feminine nouns, and 'caro' becomes 'cara'."
      },
      {
        "type": "text",
        "id": "shopping_phrases",
        "title": "Useful Shopping Phrases",
        "content": "Master these phrases for successful shopping!",
        "examples": [
          "¿Cuánto cuesta? (How much does it cost?)",
          "¿Tiene...? (Do you have...?)",
          "Necesito... (I need...)",
          "¿Qué busca? (What are you looking for?)"
        ]
      },
      {
        "type": "example",
        "id": "shopping_phrases_example",
        "spanish_example": "- Hola, ¿qué busca? - Necesito unos zapatos. - ¿Qué talla? - Talla cuarenta. - ¿Y qué color? - Negro, por favor.",
        "english_translation": "- Hello, what are you looking for? - I need shoes. - What size? - Size forty. - And what color? - Black, please.",
        "explanation": "When shopping for clothes, you'll need to know your size (talla) and preferred color. Common sizes in Spain use numbers like 38, 40, 42, etc."
      },
      {
        "type": "exercise",
        "id": "prices_exercise",
        "question": "How do you ask 'How much does it cost?' in Spanish?",
        "options": [
          {"text": "¿Cuánto cuesta?", "is_correct": true},
          {"text": "¿Cuánto es?", "is_correct": false},
          {"text": "¿Cuánto vale?", "is_correct": false},
          {"text": "¿Qué precio?", "is_correct": false}
        ],
        "explanation": "Perfect! '¿Cuánto cuesta?' is the most common way to ask about price. You can also say '¿Cuánto es?' or '¿Cuánto vale?' but 'cuesta' is the most widely used."
      },
      {
        "type": "text",
        "id": "practical_tips",
        "title": "Practical Tips",
        "content": "Here are some helpful tips for shopping in Spanish-speaking countries:",
        "examples": [
          "Always ask '¿Cuánto cuesta?' before buying",
          "If something is too expensive, say: 'Es muy caro' (It's very expensive)",
          "To negotiate, you can say: '¿Tiene descuento?' (Do you have a discount?)",
          "At markets, prices are often negotiable",
          "Remember to say 'gracias' when leaving!"
        ]
      }
    ]
  }$lesson_json$,
  ARRAY[
    'spanish_tienda', 'spanish_supermercado', 'spanish_mercado', 'spanish_centro_comercial', 'spanish_farmacia',
    'spanish_producto', 'spanish_ropa', 'spanish_camisa', 'spanish_pantalon', 'spanish_zapatos', 'spanish_bolso',
    'spanish_dinero', 'spanish_euro', 'spanish_precio', 'spanish_cuanto_cuesta', 'spanish_cuanto_cuestan',
    'spanish_barato', 'spanish_caro',
    'spanish_comprar', 'spanish_vender', 'spanish_buscar', 'spanish_encontrar', 'spanish_llevar',
    'spanish_que_busca', 'spanish_necesito', 'spanish_tiene', 'spanish_talla', 'spanish_color_shopping'
  ],
  ARRAY['present_tense_verbs', 'ir_a_infinitive', 'question_formation', 'numbers']
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  updated_at = NOW();

COMMENT ON TABLE words IS 'Vocabulary words unlocked by this lesson include shopping places, items, prices, and shopping phrases';

