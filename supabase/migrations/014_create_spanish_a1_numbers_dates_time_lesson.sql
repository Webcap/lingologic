-- A1 Spanish Lesson: Numbers, Dates, and Time
-- This lesson teaches numbers (1-100), how to express dates, and tell time in Spanish

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Numbers 1-10
('spanish_uno', 'spanish', 'uno', 'one', 'numbers'),
('spanish_dos', 'spanish', 'dos', 'two', 'numbers'),
('spanish_tres', 'spanish', 'tres', 'three', 'numbers'),
('spanish_cuatro', 'spanish', 'cuatro', 'four', 'numbers'),
('spanish_cinco', 'spanish', 'cinco', 'five', 'numbers'),
('spanish_seis', 'spanish', 'seis', 'six', 'numbers'),
('spanish_siete', 'spanish', 'siete', 'seven', 'numbers'),
('spanish_ocho', 'spanish', 'ocho', 'eight', 'numbers'),
('spanish_nueve', 'spanish', 'nueve', 'nine', 'numbers'),
('spanish_diez', 'spanish', 'diez', 'ten', 'numbers'),
-- Numbers 11-20
('spanish_once', 'spanish', 'once', 'eleven', 'numbers'),
('spanish_doce', 'spanish', 'doce', 'twelve', 'numbers'),
('spanish_trece', 'spanish', 'trece', 'thirteen', 'numbers'),
('spanish_catorce', 'spanish', 'catorce', 'fourteen', 'numbers'),
('spanish_quince', 'spanish', 'quince', 'fifteen', 'numbers'),
('spanish_veinte', 'spanish', 'veinte', 'twenty', 'numbers'),
-- Larger Numbers
('spanish_cien', 'spanish', 'cien', 'one hundred', 'numbers'),
('spanish_mil', 'spanish', 'mil', 'one thousand', 'numbers'),
-- Days of the Week
('spanish_lunes', 'spanish', 'lunes', 'Monday', 'time'),
('spanish_martes', 'spanish', 'martes', 'Tuesday', 'time'),
('spanish_miercoles', 'spanish', 'miércoles', 'Wednesday', 'time'),
('spanish_jueves', 'spanish', 'jueves', 'Thursday', 'time'),
('spanish_viernes', 'spanish', 'viernes', 'Friday', 'time'),
('spanish_sabado', 'spanish', 'sábado', 'Saturday', 'time'),
('spanish_domingo', 'spanish', 'domingo', 'Sunday', 'time'),
-- Months
('spanish_enero', 'spanish', 'enero', 'January', 'time'),
('spanish_febrero', 'spanish', 'febrero', 'February', 'time'),
('spanish_marzo', 'spanish', 'marzo', 'March', 'time'),
('spanish_abril', 'spanish', 'abril', 'April', 'time'),
('spanish_mayo', 'spanish', 'mayo', 'May', 'time'),
('spanish_junio', 'spanish', 'junio', 'June', 'time'),
('spanish_julio', 'spanish', 'julio', 'July', 'time'),
('spanish_agosto', 'spanish', 'agosto', 'August', 'time'),
('spanish_septiembre', 'spanish', 'septiembre', 'September', 'time'),
('spanish_octubre', 'spanish', 'octubre', 'October', 'time'),
('spanish_noviembre', 'spanish', 'noviembre', 'November', 'time'),
('spanish_diciembre', 'spanish', 'diciembre', 'December', 'time'),
-- Time Related
('spanish_hora', 'spanish', 'hora', 'hour/time', 'time'),
('spanish_minuto', 'spanish', 'minuto', 'minute', 'time'),
('spanish_que_hora', 'spanish', '¿qué hora es?', 'what time is it?', 'time'),
('spanish_es_la', 'spanish', 'es la', 'it is (for 1:00)', 'time'),
('spanish_son_las', 'spanish', 'son las', 'it is (for other times)', 'time'),
('spanish_mediodia', 'spanish', 'mediodía', 'noon', 'time'),
('spanish_medianoche', 'spanish', 'medianoche', 'midnight', 'time'),
('spanish_manana', 'spanish', 'mañana', 'morning/tomorrow', 'time'),
('spanish_tarde', 'spanish', 'tarde', 'afternoon', 'time'),
('spanish_noche', 'spanish', 'noche', 'night', 'time'),
-- Date Related
('spanish_hoy', 'spanish', 'hoy', 'today', 'time'),
('spanish_ayer', 'spanish', 'ayer', 'yesterday', 'time'),
('spanish_mañana', 'spanish', 'mañana', 'tomorrow', 'time'),
('spanish_dia', 'spanish', 'día', 'day', 'time'),
('spanish_semana', 'spanish', 'semana', 'week', 'time'),
('spanish_mes', 'spanish', 'mes', 'month', 'time'),
('spanish_ano', 'spanish', 'año', 'year', 'time')
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
  'spanish_a1_numbers_dates_time',
  'Numbers, Dates, and Time',
  'Learn numbers, how to express dates, and tell time in Spanish. Essential for everyday conversations!',
  'spanish',
  'vocabulary',
  'A1',
  3,
  30,
  $lesson_json${
    "sections": [
      {
        "type": "text",
        "id": "numbers_intro",
        "title": "Numbers 1-20",
        "content": "Let's start with the basics - numbers! Knowing numbers is essential for telling time, talking about dates, prices, and quantities. We'll start with numbers 1-20, which are the foundation.",
        "examples": [
          "1-10: uno, dos, tres, cuatro, cinco, seis, siete, ocho, nueve, diez",
          "11-15: once, doce, trece, catorce, quince",
          "16-20: dieciséis, diecisiete, dieciocho, diecinueve, veinte"
        ]
      },
      {
        "type": "example",
        "id": "numbers_example_1",
        "spanish_example": "Uno, dos, tres, cuatro, cinco. ¿Cuántos son? Son cinco.",
        "english_translation": "One, two, three, four, five. How many are there? There are five.",
        "explanation": "Numbers in Spanish follow a pattern. Notice how we ask '¿Cuántos son?' (How many are there?) and answer 'Son [number]' (There are [number])."
      },
      {
        "type": "example",
        "id": "numbers_example_2",
        "spanish_example": "Tengo quince años. Mi hermana tiene doce años.",
        "english_translation": "I am fifteen years old. My sister is twelve years old.",
        "explanation": "Numbers are used when talking about age. 'Quince' (fifteen) and 'doce' (twelve) are examples of numbers used in everyday conversation."
      },
      {
        "type": "exercise",
        "id": "numbers_exercise_1",
        "question": "How do you say the number 15 in Spanish?",
        "options": [
          {"text": "quince", "is_correct": true},
          {"text": "cinco", "is_correct": false},
          {"text": "veinte", "is_correct": false},
          {"text": "diez", "is_correct": false}
        ],
        "explanation": "'Quince' is 15 in Spanish. It's one of the special numbers that doesn't follow the pattern of adding 'diez' (ten) to the base number."
      },
      {
        "type": "text",
        "id": "dates_intro",
        "title": "Days and Months",
        "content": "Now let's learn the days of the week and months of the year! These are important for making plans, talking about schedules, and understanding dates.",
        "examples": [
          "Days of the week: lunes (Monday), martes (Tuesday), miércoles (Wednesday), etc.",
          "Months: enero (January), febrero (February), marzo (March), etc.",
          "Days and months are not capitalized in Spanish (except at the beginning of sentences)"
        ]
      },
      {
        "type": "example",
        "id": "dates_example_1",
        "spanish_example": "¿Qué día es hoy? Hoy es lunes. ¿Qué fecha es hoy? Es el 15 de marzo.",
        "english_translation": "What day is today? Today is Monday. What date is today? It's March 15th.",
        "explanation": "To ask what day it is, use '¿Qué día es hoy?' To ask the date, use '¿Qué fecha es hoy?' Notice the format: 'el [day] de [month]'."
      },
      {
        "type": "example",
        "id": "dates_example_2",
        "spanish_example": "Mi cumpleaños es el veinte de julio.",
        "english_translation": "My birthday is July 20th.",
        "explanation": "When expressing dates, use 'el [number] de [month]'. The number comes first, followed by 'de' (of), then the month name."
      },
      {
        "type": "exercise",
        "id": "dates_exercise_1",
        "question": "How do you say 'March 15th' in Spanish?",
        "options": [
          {"text": "el quince de marzo", "is_correct": true},
          {"text": "marzo quince", "is_correct": false},
          {"text": "el marzo quince", "is_correct": false},
          {"text": "quince marzo", "is_correct": false}
        ],
        "explanation": "The correct format is 'el [day] de [month]'. So 'el quince de marzo' means 'March 15th' or literally 'the 15th of March'."
      },
      {
        "type": "text",
        "id": "time_intro",
        "title": "Telling Time",
        "content": "Now let's learn how to tell time in Spanish! This is essential for scheduling, making appointments, and daily life. Spanish has some specific rules for telling time.",
        "examples": [
          "1:00 uses 'es la una' (it is one o'clock)",
          "Other times use 'son las' (it is) followed by the hour",
          "Minutes are added with 'y' (and) or 'menos' (minus) for times like 2:45"
        ]
      },
      {
        "type": "example",
        "id": "time_example_1",
        "spanish_example": "¿Qué hora es? Son las tres y media. / Es la una y cuarto.",
        "english_translation": "What time is it? It's 3:30. / It's 1:15.",
        "explanation": "To ask the time, use '¿Qué hora es?' For 1:00, use 'Es la una'. For other hours, use 'Son las [hour]'. 'Media' means half (30 minutes) and 'cuarto' means quarter (15 minutes)."
      },
      {
        "type": "example",
        "id": "time_example_2",
        "spanish_example": "Son las diez de la mañana. / Son las ocho de la noche.",
        "english_translation": "It's 10:00 AM. / It's 8:00 PM.",
        "explanation": "To specify morning, afternoon, or night, use 'de la mañana' (in the morning), 'de la tarde' (in the afternoon), or 'de la noche' (in the evening/night)."
      },
      {
        "type": "exercise",
        "id": "time_exercise_1",
        "question": "How do you say 'It's 2:30 PM' in Spanish?",
        "options": [
          {"text": "Son las dos y media de la tarde", "is_correct": true},
          {"text": "Es las dos y media", "is_correct": false},
          {"text": "Son dos y media tarde", "is_correct": false},
          {"text": "Es la dos y media", "is_correct": false}
        ],
        "explanation": "Use 'Son las' for times other than 1:00. 'Media' means 30 minutes. 'De la tarde' specifies afternoon."
      },
      {
        "type": "text",
        "id": "combining_intro",
        "title": "Putting It All Together",
        "content": "Now let's combine numbers, dates, and time in complete conversations! These are used together in many everyday situations.",
        "examples": [
          "Making appointments: combining day, date, and time",
          "Talking about birthdays: combining dates and numbers",
          "Describing schedules: combining days, times, and activities"
        ]
      },
      {
        "type": "example",
        "id": "combining_example_1",
        "spanish_example": "A: ¿Qué día es tu cumpleaños?\nB: Es el cinco de junio.\nA: ¿A qué hora es la fiesta?\nB: Es a las siete de la noche.",
        "english_translation": "A: What day is your birthday?\nB: It's June 5th.\nA: What time is the party?\nB: It's at 7:00 PM.",
        "explanation": "A complete conversation combining dates and times. Notice how we use 'el [day] de [month]' for dates and 'a las [hour]' for scheduled times."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "How would you say 'My class is on Monday at 9:00 AM'?",
        "options": [
          {"text": "Mi clase es el lunes a las nueve de la mañana", "is_correct": true},
          {"text": "Mi clase es lunes a nueve mañana", "is_correct": false},
          {"text": "Mi clase es en lunes a las nueve", "is_correct": false},
          {"text": "Mi clase es el lunes a la nueve", "is_correct": false}
        ],
        "explanation": "Use 'el [day]' for days of the week, 'a las [hour]' for times, and 'de la mañana' to specify morning. Note: 'nueve' uses 'las' not 'la'."
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "How do you say 'It's 12:00 noon' in Spanish?",
        "options": [
          {"text": "Es mediodía", "is_correct": true},
          {"text": "Son las doce", "is_correct": false},
          {"text": "Es la doce", "is_correct": false},
          {"text": "Son mediodía", "is_correct": false}
        ],
        "explanation": "'Mediodía' means noon (12:00 PM) and uses 'Es' (not 'Son') because it's considered singular. You can also say 'Son las doce del mediodía' but 'Es mediodía' is more common."
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'spanish_uno',
    'spanish_dos',
    'spanish_tres',
    'spanish_cuatro',
    'spanish_cinco',
    'spanish_seis',
    'spanish_siete',
    'spanish_ocho',
    'spanish_nueve',
    'spanish_diez',
    'spanish_once',
    'spanish_doce',
    'spanish_trece',
    'spanish_catorce',
    'spanish_quince',
    'spanish_veinte',
    'spanish_cien',
    'spanish_mil',
    'spanish_lunes',
    'spanish_martes',
    'spanish_miercoles',
    'spanish_jueves',
    'spanish_viernes',
    'spanish_sabado',
    'spanish_domingo',
    'spanish_enero',
    'spanish_febrero',
    'spanish_marzo',
    'spanish_abril',
    'spanish_mayo',
    'spanish_junio',
    'spanish_julio',
    'spanish_agosto',
    'spanish_septiembre',
    'spanish_octubre',
    'spanish_noviembre',
    'spanish_diciembre',
    'spanish_hora',
    'spanish_minuto',
    'spanish_que_hora',
    'spanish_es_la',
    'spanish_son_las',
    'spanish_mediodia',
    'spanish_medianoche',
    'spanish_manana',
    'spanish_tarde',
    'spanish_noche',
    'spanish_hoy',
    'spanish_ayer',
    'spanish_mañana',
    'spanish_dia',
    'spanish_semana',
    'spanish_mes',
    'spanish_ano'
  ]::TEXT[],
  ARRAY['numbers', 'dates', 'telling_time', 'calendar_vocabulary']::TEXT[]
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  content_json = EXCLUDED.content_json,
  unlocks_word_ids = EXCLUDED.unlocks_word_ids,
  unlocks_grammar_concepts = EXCLUDED.unlocks_grammar_concepts,
  level = EXCLUDED.level,
  updated_at = NOW();


