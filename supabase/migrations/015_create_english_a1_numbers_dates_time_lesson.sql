-- A1 English Lesson: Numbers, Dates, and Time
-- This lesson teaches numbers (1-20), how to express dates, and tell time in English

-- First, create the vocabulary words that will be unlocked by this lesson
INSERT INTO words (id, language, word_text, translation, category) VALUES
-- Numbers 1-10
('english_one', 'english', 'one', 'one', 'numbers'),
('english_two', 'english', 'two', 'two', 'numbers'),
('english_three', 'english', 'three', 'three', 'numbers'),
('english_four', 'english', 'four', 'four', 'numbers'),
('english_five', 'english', 'five', 'five', 'numbers'),
('english_six', 'english', 'six', 'six', 'numbers'),
('english_seven', 'english', 'seven', 'seven', 'numbers'),
('english_eight', 'english', 'eight', 'eight', 'numbers'),
('english_nine', 'english', 'nine', 'nine', 'numbers'),
('english_ten', 'english', 'ten', 'ten', 'numbers'),
-- Numbers 11-20
('english_eleven', 'english', 'eleven', 'eleven', 'numbers'),
('english_twelve', 'english', 'twelve', 'twelve', 'numbers'),
('english_thirteen', 'english', 'thirteen', 'thirteen', 'numbers'),
('english_fourteen', 'english', 'fourteen', 'fourteen', 'numbers'),
('english_fifteen', 'english', 'fifteen', 'fifteen', 'numbers'),
('english_twenty', 'english', 'twenty', 'twenty', 'numbers'),
-- Larger Numbers
('english_hundred', 'english', 'hundred', 'hundred', 'numbers'),
('english_thousand', 'english', 'thousand', 'thousand', 'numbers'),
-- Days of the Week
('english_monday', 'english', 'Monday', 'Monday', 'time'),
('english_tuesday', 'english', 'Tuesday', 'Tuesday', 'time'),
('english_wednesday', 'english', 'Wednesday', 'Wednesday', 'time'),
('english_thursday', 'english', 'Thursday', 'Thursday', 'time'),
('english_friday', 'english', 'Friday', 'Friday', 'time'),
('english_saturday', 'english', 'Saturday', 'Saturday', 'time'),
('english_sunday', 'english', 'Sunday', 'Sunday', 'time'),
-- Months
('english_january', 'english', 'January', 'January', 'time'),
('english_february', 'english', 'February', 'February', 'time'),
('english_march', 'english', 'March', 'March', 'time'),
('english_april', 'english', 'April', 'April', 'time'),
('english_may', 'english', 'May', 'May', 'time'),
('english_june', 'english', 'June', 'June', 'time'),
('english_july', 'english', 'July', 'July', 'time'),
('english_august', 'english', 'August', 'August', 'time'),
('english_september', 'english', 'September', 'September', 'time'),
('english_october', 'english', 'October', 'October', 'time'),
('english_november', 'english', 'November', 'November', 'time'),
('english_december', 'english', 'December', 'December', 'time'),
-- Time Related
('english_time', 'english', 'time', 'time', 'time'),
('english_hour', 'english', 'hour', 'hour', 'time'),
('english_minute', 'english', 'minute', 'minute', 'time'),
('english_what_time', 'english', 'what time is it?', 'what time is it?', 'time'),
('english_oclock', 'english', 'o''clock', 'o''clock', 'time'),
('english_am', 'english', 'AM', 'AM', 'time'),
('english_pm', 'english', 'PM', 'PM', 'time'),
('english_noon', 'english', 'noon', 'noon', 'time'),
('english_midnight', 'english', 'midnight', 'midnight', 'time'),
('english_morning', 'english', 'morning', 'morning', 'time'),
('english_afternoon', 'english', 'afternoon', 'afternoon', 'time'),
('english_evening', 'english', 'evening', 'evening', 'time'),
('english_night', 'english', 'night', 'night', 'time'),
-- Date Related
('english_today', 'english', 'today', 'today', 'time'),
('english_yesterday', 'english', 'yesterday', 'yesterday', 'time'),
('english_tomorrow', 'english', 'tomorrow', 'tomorrow', 'time'),
('english_day', 'english', 'day', 'day', 'time'),
('english_week', 'english', 'week', 'week', 'time'),
('english_month', 'english', 'month', 'month', 'time'),
('english_year', 'english', 'year', 'year', 'time')
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
  'english_a1_numbers_dates_time',
  'Numbers, Dates, and Time',
  'Learn numbers, how to express dates, and tell time in English. Essential for everyday conversations!',
  'english',
  'vocabulary',
  'A1',
  3,
  30,
  $lesson_json${
    "translations": {
      "es": {
        "title": "Números, Fechas y Hora",
        "description": "¡Aprende los números, cómo expresar fechas y decir la hora en inglés. Esencial para las conversaciones diarias!"
      }
    },
    "sections": [
      {
        "type": "text",
        "id": "numbers_intro",
        "title": "Numbers 1-20",
        "content": "Let's start with the basics - numbers! Knowing numbers is essential for telling time, talking about dates, prices, and quantities. We'll start with numbers 1-20, which are the foundation.",
        "examples": [
          "1-10: one, two, three, four, five, six, seven, eight, nine, ten",
          "11-15: eleven, twelve, thirteen, fourteen, fifteen",
          "16-20: sixteen, seventeen, eighteen, nineteen, twenty"
        ],
        "translations": {
          "es": {
            "title": "Números 1-20",
            "content": "¡Comencemos con lo básico: los números! Conocer los números es esencial para decir la hora, hablar sobre fechas, precios y cantidades. Comenzaremos con los números 1-20, que son la base.",
            "examples": [
              "1-10: one, two, three, four, five, six, seven, eight, nine, ten",
              "11-15: eleven, twelve, thirteen, fourteen, fifteen",
              "16-20: sixteen, seventeen, eighteen, nineteen, twenty"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "numbers_example_1",
        "spanish_example": "Uno, dos, tres, cuatro, cinco. ¿Cuántos son? Son cinco.",
        "english_translation": "One, two, three, four, five. How many are there? There are five.",
        "explanation": "Numbers in English follow a pattern. Notice how we ask 'How many are there?' and answer 'There are [number]'.",
        "translations": {
          "es": {
            "explanation": "Los números en inglés siguen un patrón. Nota cómo preguntamos 'How many are there?' y respondemos 'There are [número]'."
          }
        }
      },
      {
        "type": "example",
        "id": "numbers_example_2",
        "spanish_example": "Tengo quince años. Mi hermana tiene doce años.",
        "english_translation": "I'm fifteen years old. My sister is twelve years old.",
        "explanation": "Numbers are used when talking about age. 'Fifteen' and 'twelve' are examples of numbers used in everyday conversation.",
        "translations": {
          "es": {
            "explanation": "Los números se usan cuando hablas de edad. 'Fifteen' y 'twelve' son ejemplos de números usados en conversaciones diarias."
          }
        }
      },
      {
        "type": "exercise",
        "id": "numbers_exercise_1",
        "question": "How do you write the number 15 in words?",
        "options": [
          {"text": "fifteen", "is_correct": true},
          {"text": "fiveteen", "is_correct": false},
          {"text": "fiftheen", "is_correct": false},
          {"text": "fifty", "is_correct": false}
        ],
        "explanation": "'Fifteen' is 15 in English. Notice the spelling - it's 'fifteen' not 'fiveteen'. 'Fifty' is 50, which is different.",
        "translations": {
          "es": {
            "question": "¿Cómo escribes el número 15 en palabras?",
            "options": [
              {"text": "fifteen", "is_correct": true},
              {"text": "fiveteen", "is_correct": false},
              {"text": "fiftheen", "is_correct": false},
              {"text": "fifty", "is_correct": false}
            ],
            "explanation": "'Fifteen' es 15 en inglés. Nota la ortografía: es 'fifteen', no 'fiveteen'. 'Fifty' es 50, que es diferente."
          }
        }
      },
      {
        "type": "text",
        "id": "dates_intro",
        "title": "Days and Months",
        "content": "Now let's learn the days of the week and months of the year! These are important for making plans, talking about schedules, and understanding dates.",
        "examples": [
          "Days of the week: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday",
          "Months: January, February, March, April, May, June, July, August, September, October, November, December",
          "Days and months are always capitalized in English"
        ],
        "translations": {
          "es": {
            "title": "Días y Meses",
            "content": "¡Ahora aprendamos los días de la semana y los meses del año! Estos son importantes para hacer planes, hablar sobre horarios y entender fechas.",
            "examples": [
              "Días de la semana: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday",
              "Meses: January, February, March, April, May, June, July, August, September, October, November, December",
              "Los días y meses siempre se escriben con mayúscula en inglés"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "dates_example_1",
        "spanish_example": "¿Qué día es hoy? Hoy es lunes. ¿Qué fecha es hoy? Es el 15 de marzo.",
        "english_translation": "What day is today? Today is Monday. What's the date today? It's March 15th.",
        "explanation": "To ask what day it is, use 'What day is today?' To ask the date, use 'What's the date today?' or 'What date is it?' Notice the format: '[Month] [day]th' or '[Month] [day]'.",
        "translations": {
          "es": {
            "explanation": "Para preguntar qué día es, usa 'What day is today?' Para preguntar la fecha, usa 'What's the date today?' o 'What date is it?' Nota el formato: '[Mes] [día]th' o '[Mes] [día]'."
          }
        }
      },
      {
        "type": "example",
        "id": "dates_example_2",
        "spanish_example": "Mi cumpleaños es el veinte de julio.",
        "english_translation": "My birthday is July 20th.",
        "explanation": "When expressing dates, you can say '[Month] [day]th' or 'on [Month] [day]th'. Both are correct. The 'th' is added to most day numbers (1st, 2nd, 3rd, 4th, etc.).",
        "translations": {
          "es": {
            "explanation": "Cuando expresas fechas, puedes decir '[Mes] [día]th' o 'on [Mes] [día]th'. Ambos son correctos. El 'th' se agrega a la mayoría de los números de días (1st, 2nd, 3rd, 4th, etc.)."
          }
        }
      },
      {
        "type": "exercise",
        "id": "dates_exercise_1",
        "question": "How do you say 'March 15th' in English?",
        "options": [
          {"text": "March 15th", "is_correct": true},
          {"text": "15th March", "is_correct": false},
          {"text": "The 15th of March", "is_correct": false},
          {"text": "March the 15th", "is_correct": false}
        ],
        "explanation": "In American English, the format is '[Month] [day]th'. So 'March 15th' is the standard way. 'The 15th of March' is also correct but less common in American English.",
        "translations": {
          "es": {
            "question": "¿Cómo se dice '15 de marzo' en inglés?",
            "options": [
              {"text": "March 15th", "is_correct": true},
              {"text": "15th March", "is_correct": false},
              {"text": "The 15th of March", "is_correct": false},
              {"text": "March the 15th", "is_correct": false}
            ],
            "explanation": "En inglés americano, el formato es '[Mes] [día]th'. Entonces 'March 15th' es la forma estándar. 'The 15th of March' también es correcto pero menos común en inglés americano."
          }
        }
      },
      {
        "type": "text",
        "id": "time_intro",
        "title": "Telling Time",
        "content": "Now let's learn how to tell time in English! This is essential for scheduling, making appointments, and daily life. English has two main ways to express time: 12-hour format (with AM/PM) and 24-hour format.",
        "examples": [
          "12-hour format: '3:30 PM' or '3:30 in the afternoon'",
          "Using 'o'clock': 'It's 3 o'clock'",
          "Using 'half past', 'quarter past', 'quarter to' for common times"
        ],
        "translations": {
          "es": {
            "title": "Decir la Hora",
            "content": "¡Ahora aprendamos a decir la hora en inglés! Esto es esencial para programar, hacer citas y la vida diaria. El inglés tiene dos formas principales de expresar la hora: formato de 12 horas (con AM/PM) y formato de 24 horas.",
            "examples": [
              "Formato de 12 horas: '3:30 PM' o '3:30 in the afternoon'",
              "Usando 'o'clock': 'It's 3 o'clock'",
              "Usando 'half past', 'quarter past', 'quarter to' para horas comunes"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "time_example_1",
        "spanish_example": "¿Qué hora es? Son las tres y media. / Es la una y cuarto.",
        "english_translation": "What time is it? It's 3:30. / It's half past three. / It's 1:15. / It's a quarter past one.",
        "explanation": "To ask the time, use 'What time is it?' or 'What's the time?' You can tell time using numbers (3:30) or phrases like 'half past three' (3:30) or 'a quarter past one' (1:15).",
        "translations": {
          "es": {
            "explanation": "Para preguntar la hora, usa 'What time is it?' o 'What's the time?' Puedes decir la hora usando números (3:30) o frases como 'half past three' (3:30) o 'a quarter past one' (1:15)."
          }
        }
      },
      {
        "type": "example",
        "id": "time_example_2",
        "spanish_example": "Son las diez de la mañana. / Son las ocho de la noche.",
        "english_translation": "It's 10:00 AM. / It's 10 in the morning. / It's 8:00 PM. / It's 8 in the evening.",
        "explanation": "You can specify morning, afternoon, or evening using AM/PM or by saying 'in the morning', 'in the afternoon', or 'in the evening'. AM is for morning (before noon) and PM is for afternoon/evening (after noon).",
        "translations": {
          "es": {
            "explanation": "Puedes especificar mañana, tarde o noche usando AM/PM o diciendo 'in the morning', 'in the afternoon', o 'in the evening'. AM es para la mañana (antes del mediodía) y PM es para la tarde/noche (después del mediodía)."
          }
        }
      },
      {
        "type": "exercise",
        "id": "time_exercise_1",
        "question": "How do you say '2:30 PM' in English?",
        "options": [
          {"text": "It's 2:30 PM", "is_correct": true},
          {"text": "It's 2:30 AM", "is_correct": false},
          {"text": "It's 14:30", "is_correct": false},
          {"text": "It's two and thirty", "is_correct": false}
        ],
        "explanation": "'It's 2:30 PM' is the standard way. PM indicates afternoon/evening. AM would be morning. While '14:30' (24-hour format) is correct, it's less common in casual conversation.",
        "translations": {
          "es": {
            "question": "¿Cómo se dice '2:30 PM' en inglés?",
            "options": [
              {"text": "It's 2:30 PM", "is_correct": true},
              {"text": "It's 2:30 AM", "is_correct": false},
              {"text": "It's 14:30", "is_correct": false},
              {"text": "It's two and thirty", "is_correct": false}
            ],
            "explanation": "'It's 2:30 PM' es la forma estándar. PM indica tarde/noche. AM sería mañana. Aunque '14:30' (formato de 24 horas) es correcto, es menos común en conversación casual."
          }
        }
      },
      {
        "type": "exercise",
        "id": "time_exercise_2",
        "question": "What does 'half past three' mean?",
        "options": [
          {"text": "3:30", "is_correct": true},
          {"text": "3:15", "is_correct": false},
          {"text": "3:45", "is_correct": false},
          {"text": "3:00", "is_correct": false}
        ],
        "explanation": "'Half past three' means 3:30. 'Half past' means 30 minutes past the hour. 'Quarter past' means 15 minutes past, and 'quarter to' means 15 minutes before.",
        "translations": {
          "es": {
            "question": "¿Qué significa 'half past three'?",
            "options": [
              {"text": "3:30", "is_correct": true},
              {"text": "3:15", "is_correct": false},
              {"text": "3:45", "is_correct": false},
              {"text": "3:00", "is_correct": false}
            ],
            "explanation": "'Half past three' significa 3:30. 'Half past' significa 30 minutos después de la hora. 'Quarter past' significa 15 minutos después, y 'quarter to' significa 15 minutos antes."
          }
        }
      },
      {
        "type": "text",
        "id": "combining_intro",
        "title": "Putting It All Together",
        "content": "Now let's combine numbers, dates, and time in complete conversations! These are used together in many everyday situations like making appointments, talking about schedules, and planning events.",
        "examples": [
          "Making appointments: combining day, date, and time",
          "Talking about birthdays: combining dates and numbers",
          "Describing schedules: combining days, times, and activities"
        ],
        "translations": {
          "es": {
            "title": "Poniendo Todo Junto",
            "content": "¡Ahora combinemos números, fechas y hora en conversaciones completas! Estos se usan juntos en muchas situaciones diarias como hacer citas, hablar sobre horarios y planificar eventos.",
            "examples": [
              "Hacer citas: combinando día, fecha y hora",
              "Hablar sobre cumpleaños: combinando fechas y números",
              "Describir horarios: combinando días, horas y actividades"
            ]
          }
        }
      },
      {
        "type": "example",
        "id": "combining_example_1",
        "spanish_example": "A: ¿Qué día es tu cumpleaños?\nB: Es el cinco de junio.\nA: ¿A qué hora es la fiesta?\nB: Es a las siete de la noche.",
        "english_translation": "A: What day is your birthday?\nB: It's June 5th.\nA: What time is the party?\nB: It's at 7:00 PM.",
        "explanation": "A complete conversation combining dates and times. Notice how we use '[Month] [day]th' for dates and 'at [time]' for scheduled times. Use 'at' before times.",
        "translations": {
          "es": {
            "explanation": "Una conversación completa que combina fechas y horas. Nota cómo usamos '[Mes] [día]th' para fechas y 'at [hora]' para horarios programados. Usa 'at' antes de las horas."
          }
        }
      },
      {
        "type": "example",
        "id": "combining_example_2",
        "spanish_example": "A: ¿Cuándo es la reunión?\nB: Es el lunes a las nueve y media de la mañana.\nA: ¿Qué fecha es eso?\nB: Es el 15 de marzo.",
        "english_translation": "A: When is the meeting?\nB: It's on Monday at 9:30 AM.\nA: What date is that?\nB: That's March 15th.",
        "explanation": "When specifying days and times together, use 'on [day] at [time]'. 'On' is used for days, 'at' is used for times.",
        "translations": {
          "es": {
            "explanation": "Cuando especificas días y horas juntos, usa 'on [día] at [hora]'. 'On' se usa para días, 'at' se usa para horas."
          }
        }
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_1",
        "question": "How would you say 'My class is on Monday at 9:00 AM'?",
        "options": [
          {"text": "My class is on Monday at 9:00 AM", "is_correct": true},
          {"text": "My class is Monday at 9:00 AM", "is_correct": false},
          {"text": "My class is on Monday in 9:00 AM", "is_correct": false},
          {"text": "My class is at Monday 9:00 AM", "is_correct": false}
        ],
        "explanation": "Use 'on [day]' for days of the week and 'at [time]' for specific times. So 'on Monday at 9:00 AM' is correct.",
        "translations": {
          "es": {
            "question": "¿Cómo dirías 'Mi clase es el lunes a las 9:00 AM'?",
            "options": [
              {"text": "My class is on Monday at 9:00 AM", "is_correct": true},
              {"text": "My class is Monday at 9:00 AM", "is_correct": false},
              {"text": "My class is on Monday in 9:00 AM", "is_correct": false},
              {"text": "My class is at Monday 9:00 AM", "is_correct": false}
            ],
            "explanation": "Usa 'on [día]' para días de la semana y 'at [hora]' para horas específicas. Entonces 'on Monday at 9:00 AM' es correcto."
          }
        }
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_2",
        "question": "How do you say 'It's 12:00 noon' in English?",
        "options": [
          {"text": "It's noon", "is_correct": true},
          {"text": "It's 12:00", "is_correct": false},
          {"text": "It's midday", "is_correct": false},
          {"text": "It's twelve o'clock", "is_correct": false}
        ],
        "explanation": "'It's noon' means 12:00 PM. You can also say 'It's 12:00 PM' or 'It's twelve o'clock' (but this could be AM or PM without context). 'Noon' is the clearest way to say 12:00 PM.",
        "translations": {
          "es": {
            "question": "¿Cómo se dice 'Es mediodía (12:00)' en inglés?",
            "options": [
              {"text": "It's noon", "is_correct": true},
              {"text": "It's 12:00", "is_correct": false},
              {"text": "It's midday", "is_correct": false},
              {"text": "It's twelve o'clock", "is_correct": false}
            ],
            "explanation": "'It's noon' significa 12:00 PM. También puedes decir 'It's 12:00 PM' o 'It's twelve o'clock' (pero esto podría ser AM o PM sin contexto). 'Noon' es la forma más clara de decir 12:00 PM."
          }
        }
      },
      {
        "type": "exercise",
        "id": "comprehensive_exercise_3",
        "question": "What's the correct way to write a date in American English?",
        "options": [
          {"text": "March 15th, 2024", "is_correct": true},
          {"text": "15th March, 2024", "is_correct": false},
          {"text": "15/3/2024", "is_correct": false},
          {"text": "2024, March 15th", "is_correct": false}
        ],
        "explanation": "In American English, the format is '[Month] [day], [year]'. So 'March 15th, 2024' is the standard format. Numbers are also acceptable: 'March 15, 2024'.",
        "translations": {
          "es": {
            "question": "¿Cuál es la forma correcta de escribir una fecha en inglés americano?",
            "options": [
              {"text": "March 15th, 2024", "is_correct": true},
              {"text": "15th March, 2024", "is_correct": false},
              {"text": "15/3/2024", "is_correct": false},
              {"text": "2024, March 15th", "is_correct": false}
            ],
            "explanation": "En inglés americano, el formato es '[Mes] [día], [año]'. Entonces 'March 15th, 2024' es el formato estándar. Los números también son aceptables: 'March 15, 2024'."
          }
        }
      }
    ]
  }$lesson_json$::jsonb,
  ARRAY[
    'english_one',
    'english_two',
    'english_three',
    'english_four',
    'english_five',
    'english_six',
    'english_seven',
    'english_eight',
    'english_nine',
    'english_ten',
    'english_eleven',
    'english_twelve',
    'english_thirteen',
    'english_fourteen',
    'english_fifteen',
    'english_twenty',
    'english_hundred',
    'english_thousand',
    'english_monday',
    'english_tuesday',
    'english_wednesday',
    'english_thursday',
    'english_friday',
    'english_saturday',
    'english_sunday',
    'english_january',
    'english_february',
    'english_march',
    'english_april',
    'english_may',
    'english_june',
    'english_july',
    'english_august',
    'english_september',
    'english_october',
    'english_november',
    'english_december',
    'english_time',
    'english_hour',
    'english_minute',
    'english_what_time',
    'english_oclock',
    'english_am',
    'english_pm',
    'english_noon',
    'english_midnight',
    'english_morning',
    'english_afternoon',
    'english_evening',
    'english_night',
    'english_today',
    'english_yesterday',
    'english_tomorrow',
    'english_day',
    'english_week',
    'english_month',
    'english_year'
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

