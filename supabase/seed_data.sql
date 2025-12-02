-- Seed Data for LingoLogic MVP
-- Run this after creating the schema to populate initial Spanish vocabulary

-- Insert Spanish vocabulary words
INSERT INTO words (id, language, word_text, translation, category, image_url, audio_url) VALUES
-- Nouns
('word_001', 'es', 'casa', 'house', 'nouns', 'assets/images/words/casa.png', 'assets/audio/words/casa.mp3'),
('word_002', 'es', 'perro', 'dog', 'nouns', 'assets/images/words/perro.png', 'assets/audio/words/perro.mp3'),
('word_003', 'es', 'gato', 'cat', 'nouns', 'assets/images/words/gato.png', 'assets/audio/words/gato.mp3'),
('word_004', 'es', 'libro', 'book', 'nouns', 'assets/images/words/libro.png', 'assets/audio/words/libro.mp3'),
('word_005', 'es', 'agua', 'water', 'nouns', 'assets/images/words/agua.png', 'assets/audio/words/agua.mp3'),
('word_006', 'es', 'manzana', 'apple', 'nouns', 'assets/images/words/manzana.png', 'assets/audio/words/manzana.mp3'),
('word_007', 'es', 'sol', 'sun', 'nouns', 'assets/images/words/sol.png', 'assets/audio/words/sol.mp3'),
('word_008', 'es', 'luna', 'moon', 'nouns', 'assets/images/words/luna.png', 'assets/audio/words/luna.mp3'),
('word_009', 'es', 'árbol', 'tree', 'nouns', 'assets/images/words/arbol.png', 'assets/audio/words/arbol.mp3'),
('word_010', 'es', 'flor', 'flower', 'nouns', 'assets/images/words/flor.png', 'assets/audio/words/flor.mp3'),

-- Verbs
('word_011', 'es', 'comer', 'to eat', 'verbs', 'assets/images/words/comer.png', 'assets/audio/words/comer.mp3'),
('word_012', 'es', 'beber', 'to drink', 'verbs', 'assets/images/words/beber.png', 'assets/audio/words/beber.mp3'),
('word_013', 'es', 'dormir', 'to sleep', 'verbs', 'assets/images/words/dormir.png', 'assets/audio/words/dormir.mp3'),
('word_014', 'es', 'correr', 'to run', 'verbs', 'assets/images/words/correr.png', 'assets/audio/words/correr.mp3'),
('word_015', 'es', 'caminar', 'to walk', 'verbs', 'assets/images/words/caminar.png', 'assets/audio/words/caminar.mp3'),
('word_016', 'es', 'hablar', 'to speak', 'verbs', 'assets/images/words/hablar.png', 'assets/audio/words/hablar.mp3'),
('word_017', 'es', 'ver', 'to see', 'verbs', 'assets/images/words/ver.png', 'assets/audio/words/ver.mp3'),
('word_018', 'es', 'escuchar', 'to listen', 'verbs', 'assets/images/words/escuchar.png', 'assets/audio/words/escuchar.mp3'),
('word_019', 'es', 'leer', 'to read', 'verbs', 'assets/images/words/leer.png', 'assets/audio/words/leer.mp3'),
('word_020', 'es', 'escribir', 'to write', 'verbs', 'assets/images/words/escribir.png', 'assets/audio/words/escribir.mp3'),

-- Adjectives
('word_021', 'es', 'grande', 'big', 'adjectives', 'assets/images/words/grande.png', 'assets/audio/words/grande.mp3'),
('word_022', 'es', 'pequeño', 'small', 'adjectives', 'assets/images/words/pequeno.png', 'assets/audio/words/pequeno.mp3'),
('word_023', 'es', 'bueno', 'good', 'adjectives', 'assets/images/words/bueno.png', 'assets/audio/words/bueno.mp3'),
('word_024', 'es', 'malo', 'bad', 'adjectives', 'assets/images/words/malo.png', 'assets/audio/words/malo.mp3'),
('word_025', 'es', 'rojo', 'red', 'adjectives', 'assets/images/words/rojo.png', 'assets/audio/words/rojo.mp3'),
('word_026', 'es', 'azul', 'blue', 'adjectives', 'assets/images/words/azul.png', 'assets/audio/words/azul.mp3'),
('word_027', 'es', 'verde', 'green', 'adjectives', 'assets/images/words/verde.png', 'assets/audio/words/verde.mp3'),
('word_028', 'es', 'amarillo', 'yellow', 'adjectives', 'assets/images/words/amarillo.png', 'assets/audio/words/amarillo.mp3'),
('word_029', 'es', 'blanco', 'white', 'adjectives', 'assets/images/words/blanco.png', 'assets/audio/words/blanco.mp3'),
('word_030', 'es', 'negro', 'black', 'adjectives', 'assets/images/words/negro.png', 'assets/audio/words/negro.mp3'),

-- Articles
('word_031', 'es', 'el', 'the (masculine)', 'articles', NULL, 'assets/audio/words/el.mp3'),
('word_032', 'es', 'la', 'the (feminine)', 'articles', NULL, 'assets/audio/words/la.mp3'),
('word_033', 'es', 'un', 'a/an (masculine)', 'articles', NULL, 'assets/audio/words/un.mp3'),
('word_034', 'es', 'una', 'a/an (feminine)', 'articles', NULL, 'assets/audio/words/una.mp3')
ON CONFLICT (id) DO NOTHING;

