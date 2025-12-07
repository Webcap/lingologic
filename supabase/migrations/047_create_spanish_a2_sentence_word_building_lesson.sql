-- A2 Spanish Lesson: Building Sentences and Words
-- This lesson teaches sentence construction and word building skills in Spanish

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Sentence Building Words
('spanish_construir', 'spanish', 'construir', 'to build', 'actions'),
('spanish_formar', 'spanish', 'formar', 'to form', 'actions'),
('spanish_crear', 'spanish', 'crear', 'to create', 'actions'),
('spanish_combinar', 'spanish', 'combinar', 'to combine', 'actions'),
('spanish_agregar', 'spanish', 'agregar', 'to add', 'actions'),
('spanish_juntar', 'spanish', 'juntar', 'to join', 'actions'),
-- Sentence Components
('spanish_sujeto', 'spanish', 'sujeto', 'subject', 'grammar'),
('spanish_verbo', 'spanish', 'verbo', 'verb', 'grammar'),
('spanish_objeto', 'spanish', 'objeto', 'object', 'grammar'),
('spanish_adjetivo', 'spanish', 'adjetivo', 'adjective', 'grammar'),
('spanish_sustantivo', 'spanish', 'sustantivo', 'noun', 'grammar'),
('spanish_articulo', 'spanish', 'artículo', 'article', 'grammar'),
-- Word Building - Prefixes
('spanish_des', 'spanish', 'des-', 'un-/dis- (prefix)', 'word_building'),
('spanish_re', 'spanish', 're-', 're- (prefix)', 'word_building'),
('spanish_pre', 'spanish', 'pre-', 'pre- (prefix)', 'word_building'),
('spanish_in', 'spanish', 'in-', 'in-/un- (prefix)', 'word_building'),
('spanish_sobre', 'spanish', 'sobre-', 'over-/super- (prefix)', 'word_building'),
-- Word Building - Suffixes
('spanish_ito', 'spanish', '-ito', '-ito (diminutive)', 'word_building'),
('spanish_ita', 'spanish', '-ita', '-ita (diminutive)', 'word_building'),
('spanish_mente', 'spanish', '-mente', '-ly (adverb suffix)', 'word_building'),
('spanish_acion', 'spanish', '-ción', '-tion (noun suffix)', 'word_building'),
('spanish_ero', 'spanish', '-ero', '-er (occupation)', 'word_building'),
-- Common Sentence Starters
('spanish_para', 'spanish', 'para', 'for/to', 'prepositions'),
('spanish_con', 'spanish', 'con', 'with', 'prepositions'),
('spanish_sin', 'spanish', 'sin', 'without', 'prepositions'),
('spanish_por', 'spanish', 'por', 'by/for', 'prepositions'),
('spanish_sobre_prep', 'spanish', 'sobre', 'about/on', 'prepositions'),
-- Sentence Connectors
('spanish_y', 'spanish', 'y', 'and', 'connectors'),
('spanish_o', 'spanish', 'o', 'or', 'connectors'),
('spanish_pero', 'spanish', 'pero', 'but', 'connectors'),
('spanish_porque', 'spanish', 'porque', 'because', 'connectors'),
('spanish_cuando', 'spanish', 'cuando', 'when', 'connectors'),
('spanish_donde', 'spanish', 'dónde', 'where', 'connectors'),
-- Action Verbs for Sentence Building
('spanish_hablo', 'spanish', 'hablo', 'I speak', 'verbs'),
('spanish_hablas', 'spanish', 'hablas', 'you speak', 'verbs'),
('spanish_habla', 'spanish', 'habla', 'he/she speaks', 'verbs'),
('spanish_como', 'spanish', 'como', 'I eat', 'verbs'),
('spanish_comes', 'spanish', 'comes', 'you eat', 'verbs'),
('spanish_come', 'spanish', 'come', 'he/she eats', 'verbs'),
('spanish_escribo', 'spanish', 'escribo', 'I write', 'verbs'),
('spanish_escribes', 'spanish', 'escribes', 'you write', 'verbs'),
('spanish_escribe', 'spanish', 'escribe', 'he/she writes', 'verbs'),
-- Building Tools
('spanish_palabra', 'spanish', 'palabra', 'word', 'vocabulary'),
('spanish_frase', 'spanish', 'frase', 'phrase', 'vocabulary'),
('spanish_oracion', 'spanish', 'oración', 'sentence', 'vocabulary'),
('spanish_significado', 'spanish', 'significado', 'meaning', 'vocabulary'),
('spanish_practica', 'spanish', 'práctica', 'practice', 'vocabulary')
ON CONFLICT (id) DO NOTHING;

-- Create the A2 Spanish lesson with comprehensive content
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
  'spanish_a2_sentence_word_building',
  'Building Sentences and Words',
  'Learn to construct sentences and build words in Spanish! Master sentence structure, word formation with prefixes and suffixes, and how to combine words to create meaning.',
  'spanish',
  'grammar',
  'A2',
  3,
  45,
  $lesson_json${
    "sections": [
      {
        "type": "text",
        "id": "building_intro",
        "title": "Building Sentences and Words",
        "content": "Welcome! This lesson teaches you how to construct sentences and build words in Spanish. You'll learn sentence structure, word formation, and how to combine words to express your ideas clearly.",
        "examples": [
          "Simple sentence: 'Yo hablo español' (I speak Spanish)",
          "Complex sentence: 'Yo hablo español porque me gusta' (I speak Spanish because I like it)",
          "Word building: 'escribir' + '-ción' = 'escritura' (writing)"
        ]
      },
      {
        "type": "text",
        "id": "sentence_structure",
        "title": "Basic Sentence Structure",
        "content": "Every Spanish sentence has basic components. Understanding them helps you build better sentences!",
        "examples": [
          "Subject (Sujeto): Who or what does the action - 'Yo' (I), 'Tú' (You), 'María' (Maria)",
          "Verb (Verbo): The action - 'hablo' (speak), 'como' (eat), 'escribo' (write)",
          "Object (Objeto): What receives the action - 'español' (Spanish), 'pan' (bread)",
          "Adjectives: Describe nouns - 'bueno' (good), 'interesante' (interesting)"
        ]
      },
      {
        "type": "example",
        "id": "structure_example",
        "spanish_example": "Yo (sujeto) como (verbo) pan (objeto) bueno (adjetivo).",
        "english_translation": "I (subject) eat (verb) good (adjective) bread (object).",
        "explanation": "In Spanish, the order is often Subject + Verb + Object + Adjective. The adjective usually comes after the noun, unlike English where it often comes before."
      },
      {
        "type": "text",
        "id": "building_simple_sentences",
        "title": "Building Simple Sentences",
        "content": "Start with simple sentences and gradually add more information. Here's how:",
        "examples": [
          "Basic: 'Yo hablo' (I speak)",
          "Add object: 'Yo hablo español' (I speak Spanish)",
          "Add adjective: 'Yo hablo español bueno' (I speak good Spanish)",
          "Add more detail: 'Yo hablo español con mis amigos' (I speak Spanish with my friends)"
        ]
      },
      {
        "type": "example",
        "id": "simple_sentence_example",
        "spanish_example": "María escribe. → María escribe una carta. → María escribe una carta larga. → María escribe una carta larga para su amiga.",
        "english_translation": "Maria writes. → Maria writes a letter. → Maria writes a long letter. → Maria writes a long letter for her friend.",
        "explanation": "See how we start simple and add more information step by step? Each step adds a new piece of information: object (carta), adjective (larga), and prepositional phrase (para su amiga)."
      },
      {
        "type": "matching",
        "id": "sentence_components",
        "instruction": "Match the sentence components with their definitions",
        "pairs": [
          {"word": "sujeto", "translation": "subject"},
          {"word": "verbo", "translation": "verb"},
          {"word": "objeto", "translation": "object"},
          {"word": "adjetivo", "translation": "adjective"},
          {"word": "sustantivo", "translation": "noun"}
        ],
        "distractors": ["frase", "oración"],
        "explanation": "Perfect! Understanding these components helps you build sentences correctly. Remember: Sujeto (subject) does the action, Verbo (verb) is the action, and Objeto (object) receives the action."
      },
      {
        "type": "text",
        "id": "word_building_prefixes",
        "title": "Building Words: Prefixes",
        "content": "Prefixes are added to the beginning of words to change their meaning. Learn these common Spanish prefixes!",
        "examples": [
          "'des-' means 'un-' or 'opposite': 'deshacer' (undo), 'desorganizado' (disorganized)",
          "'re-' means 'again': 'rehacer' (redo), 'revisar' (review)",
          "'pre-' means 'before': 'preparar' (prepare), 'precocinar' (precook)",
          "'in-' means 'not' or 'un-': 'incorrecto' (incorrect), 'invisible' (invisible)",
          "'sobre-' means 'over' or 'super': 'sobrecargar' (overload), 'sobresaliente' (outstanding)"
        ]
      },
      {
        "type": "example",
        "id": "prefix_example",
        "spanish_example": "hacer (to do) → deshacer (to undo) → rehacer (to redo) → prehacer (to pre-do)",
        "english_translation": "do → undo → redo → pre-do",
        "explanation": "See how prefixes change the meaning? 'hacer' means 'to do', 'deshacer' means 'to undo' (opposite), 'rehacer' means 'to do again', and 'prehacer' means 'to do before'."
      },
      {
        "type": "text",
        "id": "word_building_suffixes",
        "title": "Building Words: Suffixes",
        "content": "Suffixes are added to the end of words to change their type or meaning. These are very useful!",
        "examples": [
          "'-ito/-ita': Makes things smaller or cuter - 'casa' (house) → 'casita' (little house), 'perro' (dog) → 'perrito' (puppy)",
          "'-mente': Turns adjectives into adverbs - 'rápido' (fast) → 'rápidamente' (quickly), 'fácil' (easy) → 'fácilmente' (easily)",
          "'-ción': Turns verbs into nouns - 'crear' (create) → 'creación' (creation), 'formar' (form) → 'formación' (formation)",
          "'-ero/-era': Shows occupation or purpose - 'pan' (bread) → 'panadero' (baker), 'café' (coffee) → 'cafetera' (coffee maker)"
        ]
      },
      {
        "type": "example",
        "id": "suffix_example",
        "spanish_example": "escribir (to write) → escritor (writer) → escritura (writing) → escritorito (little writer)",
        "english_translation": "write → writer → writing → little writer",
        "explanation": "From the verb 'escribir' (to write), we can create: 'escritor' (writer, person), 'escritura' (writing, action/thing), and even 'escritorito' (little writer) with the diminutive suffix!"
      },
      {
        "type": "exercise",
        "id": "word_building_exercise",
        "question": "If 'construir' means 'to build', what does 'construcción' mean?",
        "options": [
          {"text": "construction (the act of building)", "is_correct": true},
          {"text": "to build again", "is_correct": false},
          {"text": "little builder", "is_correct": false},
          {"text": "builder (person)", "is_correct": false}
        ],
        "explanation": "Excellent! '-ción' turns verbs into nouns. So 'construir' (to build, verb) becomes 'construcción' (construction, noun - the act of building). 'Constructor' would be 'builder' (person)."
      },
      {
        "type": "text",
        "id": "combining_words",
        "title": "Combining Words in Sentences",
        "content": "Learn to connect words and ideas using connectors and prepositions!",
        "examples": [
          "'y' (and): 'Yo hablo y escribo' (I speak and write)",
          "'pero' (but): 'Hablo español pero no perfecto' (I speak Spanish but not perfectly)",
          "'porque' (because): 'Estudio porque me gusta' (I study because I like it)",
          "'con' (with): 'Hablo con mis amigos' (I speak with my friends)",
          "'para' (for): 'Estudio para aprender' (I study to learn)"
        ]
      },
      {
        "type": "example",
        "id": "combining_example",
        "spanish_example": "Yo estudio español porque me gusta y quiero hablar con mis amigos, pero todavía no hablo perfectamente.",
        "english_translation": "I study Spanish because I like it and I want to speak with my friends, but I still don't speak perfectly.",
        "explanation": "This sentence combines multiple ideas using connectors: 'porque' (because) explains the reason, 'y' (and) adds information, 'con' (with) shows who, and 'pero' (but) introduces a contrast."
      },
      {
        "type": "text",
        "id": "building_complex_sentences",
        "title": "Building More Complex Sentences",
        "content": "As you progress, you can build longer, more complex sentences by combining what you know!",
        "examples": [
          "Add 'cuando' (when): 'Hablo español cuando estoy con mis amigos' (I speak Spanish when I'm with my friends)",
          "Add 'dónde' (where): 'Escribo cartas donde tengo tranquilidad' (I write letters where I have peace)",
          "Add multiple ideas: 'Estudio, practico y hablo español para mejorar' (I study, practice and speak Spanish to improve)"
        ]
      },
      {
        "type": "example",
        "id": "complex_example",
        "spanish_example": "Cuando estudio español en casa, escribo palabras nuevas porque quiero recordarlas, pero a veces olvido algunas.",
        "english_translation": "When I study Spanish at home, I write new words because I want to remember them, but sometimes I forget some.",
        "explanation": "This complex sentence has: a time clause ('Cuando estudio...'), a main action ('escribo'), a reason ('porque quiero'), and a contrast ('pero a veces'). Notice how connectors help organize the ideas!"
      },
      {
        "type": "matching",
        "id": "sentence_building",
        "instruction": "Match the Spanish connectors with their meanings",
        "pairs": [
          {"word": "y", "translation": "and"},
          {"word": "pero", "translation": "but"},
          {"word": "porque", "translation": "because"},
          {"word": "cuando", "translation": "when"},
          {"word": "con", "translation": "with"},
          {"word": "para", "translation": "for/to"}
        ],
        "distractors": ["sin", "sobre"],
        "explanation": "Great! These connectors are essential for building sentences. 'y' adds ideas, 'pero' shows contrast, 'porque' explains reasons, 'cuando' shows time, 'con' means 'with', and 'para' means 'for' or 'to' (purpose)."
      },
      {
        "type": "text",
        "id": "practice_building",
        "title": "Practice Building Sentences",
        "content": "Here's how to practice building sentences effectively:",
        "examples": [
          "Start with a simple sentence: 'Yo hablo'",
          "Add an object: 'Yo hablo español'",
          "Add a reason: 'Yo hablo español porque me gusta'",
          "Add more detail: 'Yo hablo español porque me gusta y quiero viajar'",
          "Add time/place: 'Yo hablo español porque me gusta y quiero viajar cuando tengo vacaciones'"
        ]
      },
      {
        "type": "example",
        "id": "building_practice",
        "spanish_example": "Simple: 'María come.' → 'María come pan.' → 'María come pan con mantequilla.' → 'María come pan con mantequilla porque le gusta.' → 'María come pan con mantequilla porque le gusta cuando desayuna.'",
        "english_translation": "Simple: 'Maria eats.' → 'Maria eats bread.' → 'Maria eats bread with butter.' → 'Maria eats bread with butter because she likes it.' → 'Maria eats bread with butter because she likes it when she has breakfast.'",
        "explanation": "Notice how each step adds one new piece of information! This is the best way to build complex sentences - start simple and add one thing at a time."
      },
      {
        "type": "exercise",
        "id": "sentence_construction",
        "question": "Which sentence is correctly built in Spanish?",
        "options": [
          {"text": "Yo hablo español porque me gusta y quiero aprender más.", "is_correct": true},
          {"text": "Yo hablo porque español me gusta.", "is_correct": false},
          {"text": "Porque yo hablo español me gusta.", "is_correct": false},
          {"text": "Español hablo yo porque gusta me.", "is_correct": false}
        ],
        "explanation": "Perfect! The correct sentence follows Spanish word order: Subject (Yo) + Verb (hablo) + Object (español) + Connector (porque) + Reason. Spanish word order is usually Subject-Verb-Object, though it can be flexible."
      },
      {
        "type": "text",
        "id": "word_families",
        "title": "Word Families - Building Vocabulary",
        "content": "Words that come from the same root form word families. Learning word families helps you expand your vocabulary quickly!",
        "examples": [
          "From 'escribir' (to write): escritor (writer), escritura (writing), escritorio (desk), escribiente (scribe)",
          "From 'crear' (to create): creador (creator), creación (creation), creativo (creative), creatividad (creativity)",
          "From 'formar' (to form): forma (form/shape), formación (formation), formativo (formative), formador (trainer)"
        ]
      },
      {
        "type": "example",
        "id": "word_family_example",
        "spanish_example": "raíz: escribir → escritor (person), escritura (action), escritorio (place), escrito (result)",
        "english_translation": "root: write → writer (person), writing (action), desk (place), written (result)",
        "explanation": "One root word can create many related words! When you learn 'escribir', you automatically understand words like 'escritor', 'escritura', and 'escritorio' because they share the same root meaning."
      },
      {
        "type": "text",
        "id": "tips_for_building",
        "title": "Tips for Building Sentences and Words",
        "content": "Remember these tips as you practice:",
        "examples": [
          "Start simple, then add complexity one step at a time",
          "Practice with word families to expand vocabulary quickly",
          "Use prefixes and suffixes to understand new words",
          "Connect ideas with 'y', 'pero', 'porque', 'cuando'",
          "Remember: adjectives usually come after nouns in Spanish",
          "Practice building sentences daily - it's like exercise for your Spanish!"
        ]
      },
      {
        "type": "example",
        "id": "final_practice",
        "spanish_example": "Yo construyo (I build) oraciones (sentences) nuevas (new) cuando (when) practico (I practice) español porque (because) quiero (I want) mejorar (to improve) y (and) formar (to form) palabras (words) correctamente (correctly).",
        "english_translation": "I build new sentences when I practice Spanish because I want to improve and form words correctly.",
        "explanation": "This sentence demonstrates everything we've learned: sentence structure (Yo construyo oraciones), adjectives (nuevas), connectors (cuando, porque, y), and word building concepts! Keep practicing and you'll master sentence construction!"
      }
    ]
  }$lesson_json$,
  ARRAY[
    'spanish_construir', 'spanish_formar', 'spanish_crear', 'spanish_combinar', 'spanish_agregar', 'spanish_juntar',
    'spanish_sujeto', 'spanish_verbo', 'spanish_objeto', 'spanish_adjetivo', 'spanish_sustantivo', 'spanish_articulo',
    'spanish_des', 'spanish_re', 'spanish_pre', 'spanish_in', 'spanish_sobre',
    'spanish_ito', 'spanish_ita', 'spanish_mente', 'spanish_acion', 'spanish_ero',
    'spanish_para', 'spanish_con', 'spanish_sin', 'spanish_por', 'spanish_sobre_prep',
    'spanish_y', 'spanish_o', 'spanish_pero', 'spanish_porque', 'spanish_cuando', 'spanish_donde',
    'spanish_hablo', 'spanish_hablas', 'spanish_habla', 'spanish_como', 'spanish_comes', 'spanish_come',
    'spanish_escribo', 'spanish_escribes', 'spanish_escribe',
    'spanish_palabra', 'spanish_frase', 'spanish_oracion', 'spanish_significado', 'spanish_practica'
  ],
  ARRAY['sentence_structure', 'word_building', 'prefixes', 'suffixes', 'sentence_construction', 'word_families', 'grammar_basics']
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  updated_at = NOW();

COMMENT ON TABLE words IS 'Vocabulary words unlocked by this lesson include sentence building components, word formation tools (prefixes/suffixes), connectors, and action verbs for constructing sentences';


