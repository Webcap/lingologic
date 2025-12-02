import '../../../models/lesson.dart';
import '../../../models/lesson_content.dart';

class SpanishLessons {
  /// Get seed data for Spanish grammar lessons
  static List<Lesson> getLessons() {
    return [
      _createBeginnerListeningLesson(),
      _createPresentTenseVerbsLesson(),
      _createArticlesLesson(),
      _createSubjectPronounsLesson(),
      _createBasicSentenceStructureLesson(),
    ];
  }

  static Lesson _createBeginnerListeningLesson() {
    return Lesson(
      id: 'spanish_a1_listening',
      title: 'A1 Beginner Listening',
      description: 'Practice listening comprehension with basic Spanish phrases and everyday conversations',
      language: 'spanish',
      category: 'listening',
      orderIndex: 0,
      estimatedMinutes: 25,
      content: LessonContent(
        sections: [
          TextSection(
            id: 'intro',
            title: 'Welcome to Listening Practice',
            content:
                'In this lesson, you will practice listening to basic Spanish phrases. Listen carefully to each phrase and try to understand the meaning. This will help you improve your comprehension skills.\n\nWe\'ll cover:\n• Greetings and introductions\n• Numbers and age\n• Location and family\n• Likes and preferences\n• Time expressions',
            examples: [
              'Focus on key words you recognize',
              'Listen for numbers, greetings, and common words',
              'Don\'t worry if you don\'t understand everything',
              'Practice repeating phrases out loud',
            ],
          ),
          TextSection(
            id: 'greetings_intro',
            title: 'Greetings in Spanish',
            content:
                'Spanish has different greetings for different times of day. Learning these will help you start conversations naturally.',
            examples: [
              'Buenos días - Good morning (until noon)',
              'Buenas tardes - Good afternoon (noon to evening)',
              'Buenas noches - Good evening/night',
              'Hola - Hello (any time)',
            ],
          ),
          ExampleSection(
            id: 'listening1',
            spanishExample: 'Hola, ¿cómo estás?',
            englishTranslation: 'Hello, how are you?',
            explanation: 'A common greeting. "Hola" means hello, and "¿cómo estás?" means "how are you?" This is informal - use with friends and people your age.',
          ),
          ExampleSection(
            id: 'listening1b',
            spanishExample: 'Buenos días, ¿cómo está usted?',
            englishTranslation: 'Good morning, how are you? (formal)',
            explanation: 'This is the formal version. "Usted" is used to show respect to older people, teachers, or in professional settings.',
          ),
          ExerciseSection(
            id: 'exercise1',
            question: 'Listen: "Buenos días, me llamo María." What does this mean?',
            options: [
              ExerciseOption(text: 'Good morning, my name is María', isCorrect: true),
              ExerciseOption(text: 'Good night, I am María', isCorrect: false),
              ExerciseOption(text: 'Hello, I like María', isCorrect: false),
              ExerciseOption(text: 'Goodbye, María', isCorrect: false),
            ],
            explanation: 'Correct! "Buenos días" means "good morning" and "me llamo" means "my name is".',
          ),
          ExerciseSection(
            id: 'exercise1b',
            question: 'Which greeting would you use at 2:00 PM?',
            options: [
              ExerciseOption(text: 'Buenas tardes', isCorrect: true),
              ExerciseOption(text: 'Buenos días', isCorrect: false),
              ExerciseOption(text: 'Buenas noches', isCorrect: false),
              ExerciseOption(text: 'Buenos días', isCorrect: false),
            ],
            explanation: 'Correct! "Buenas tardes" is used in the afternoon (from noon until evening).',
          ),
          TextSection(
            id: 'numbers_intro',
            title: 'Numbers and Age',
            content:
                'In Spanish, to say your age, you use "tener" (to have) instead of "ser" (to be). You literally say "I have X years".',
            examples: [
              'Tengo veinte años - I am twenty years old',
              'Tengo treinta años - I am thirty years old',
              '¿Cuántos años tienes? - How old are you?',
            ],
          ),
          ExampleSection(
            id: 'listening2',
            spanishExample: 'Tengo veinte años',
            englishTranslation: 'I am twenty years old',
            explanation: '"Tengo" means "I have" and "años" means "years". In Spanish, you say "I have X years" instead of "I am X years old".',
          ),
          ExampleSection(
            id: 'listening2b',
            spanishExample: 'Mi hermana tiene quince años',
            englishTranslation: 'My sister is fifteen years old',
            explanation: 'Notice how "tiene" (has) is used for "she". The verb changes: yo tengo, tú tienes, él/ella tiene.',
          ),
          ExerciseSection(
            id: 'exercise2',
            question: 'Listen: "¿Cuántos años tienes?" What is the person asking?',
            options: [
              ExerciseOption(text: 'How old are you?', isCorrect: true),
              ExerciseOption(text: 'What is your name?', isCorrect: false),
              ExerciseOption(text: 'Where are you from?', isCorrect: false),
              ExerciseOption(text: 'How are you?', isCorrect: false),
            ],
            explanation: 'Correct! "¿Cuántos años tienes?" means "How old are you?"',
          ),
          ExerciseSection(
            id: 'exercise2b',
            question: 'How would you say "I am twenty-five years old" in Spanish?',
            options: [
              ExerciseOption(text: 'Tengo veinticinco años', isCorrect: true),
              ExerciseOption(text: 'Soy veinticinco años', isCorrect: false),
              ExerciseOption(text: 'Tengo veinte y cinco años', isCorrect: false),
              ExerciseOption(text: 'Estoy veinticinco años', isCorrect: false),
            ],
            explanation: 'Correct! Use "tengo" (I have) with "años" (years). Veinticinco is written as one word.',
          ),
          TextSection(
            id: 'location_intro',
            title: 'Talking About Location',
            content:
                'To say where you are from or where you live, Spanish uses different verbs:\n• "Ser de" = to be from (origin)\n• "Vivir en" = to live in (current residence)',
            examples: [
              'Soy de España - I am from Spain',
              'Vivo en Madrid - I live in Madrid',
              'Soy de México pero vivo en Estados Unidos - I am from Mexico but I live in the United States',
            ],
          ),
          ExampleSection(
            id: 'listening3',
            spanishExample: 'Soy de España',
            englishTranslation: 'I am from Spain',
            explanation: '"Soy de" means "I am from". This tells where you were born or your nationality.',
          ),
          ExampleSection(
            id: 'listening3b',
            spanishExample: 'Vivo en Madrid con mi familia',
            englishTranslation: 'I live in Madrid with my family',
            explanation: '"Vivo en" means "I live in" (current residence). "Con mi familia" means "with my family".',
          ),
          ExerciseSection(
            id: 'exercise3',
            question: 'Listen: "Vivo en Madrid con mi familia." What does this mean?',
            options: [
              ExerciseOption(text: 'I live in Madrid with my family', isCorrect: true),
              ExerciseOption(text: 'I visit Madrid with friends', isCorrect: false),
              ExerciseOption(text: 'I work in Madrid', isCorrect: false),
              ExerciseOption(text: 'I like Madrid', isCorrect: false),
            ],
            explanation: 'Correct! "Vivo en" means "I live in" and "con mi familia" means "with my family".',
          ),
          ExerciseSection(
            id: 'exercise3b',
            question: 'What is the difference between "Soy de" and "Vivo en"?',
            options: [
              ExerciseOption(text: '"Soy de" = origin, "Vivo en" = current residence', isCorrect: true),
              ExerciseOption(text: 'They mean the same thing', isCorrect: false),
              ExerciseOption(text: '"Soy de" = current residence, "Vivo en" = origin', isCorrect: false),
              ExerciseOption(text: 'Both mean "I am from"', isCorrect: false),
            ],
            explanation: 'Correct! "Soy de" tells where you are from (origin/nationality), while "Vivo en" tells where you currently live.',
          ),
          TextSection(
            id: 'likes_intro',
            title: 'Expressing Likes: Me Gusta',
            content:
                'In Spanish, you don\'t say "I like coffee". Instead, you say "coffee is pleasing to me" using "me gusta".\n\n• Me gusta = I like (singular)\n• Me gustan = I like (plural)\n• ¿Qué te gusta? = What do you like?',
            examples: [
              'Me gusta el café - I like coffee',
              'Me gustan los libros - I like books',
              'No me gusta el té - I don\'t like tea',
            ],
          ),
          ExampleSection(
            id: 'listening4',
            spanishExample: 'Me gusta el café',
            englishTranslation: 'I like coffee',
            explanation: '"Me gusta" means "I like". In Spanish, you say "coffee is pleasing to me" rather than "I like coffee".',
          ),
          ExampleSection(
            id: 'listening4b',
            spanishExample: 'Me gustan los libros y la música',
            englishTranslation: 'I like books and music',
            explanation: 'Notice "me gustan" (plural) is used because "libros" (books) is plural. Use "gusta" for singular, "gustan" for plural.',
          ),
          ExerciseSection(
            id: 'exercise4',
            question: 'Listen: "¿Qué te gusta hacer?" What is the person asking?',
            options: [
              ExerciseOption(text: 'What do you like to do?', isCorrect: true),
              ExerciseOption(text: 'What is your name?', isCorrect: false),
              ExerciseOption(text: 'Where do you live?', isCorrect: false),
              ExerciseOption(text: 'How are you?', isCorrect: false),
            ],
            explanation: 'Correct! "¿Qué te gusta hacer?" means "What do you like to do?"',
          ),
          ExerciseSection(
            id: 'exercise4b',
            question: 'Which is correct: "Me gusta los libros" or "Me gustan los libros"?',
            options: [
              ExerciseOption(text: 'Me gustan los libros', isCorrect: true),
              ExerciseOption(text: 'Me gusta los libros', isCorrect: false),
              ExerciseOption(text: 'Both are correct', isCorrect: false),
              ExerciseOption(text: 'Me gusta el libros', isCorrect: false),
            ],
            explanation: 'Correct! Use "gustan" (plural) because "libros" (books) is plural. The verb must agree with what you like.',
          ),
          TextSection(
            id: 'time_intro',
            title: 'Telling Time',
            content:
                'To tell time in Spanish:\n• "Son las" + number (for most hours)\n• "Es la" + number (for 1:00)\n• "de la mañana" = in the morning\n• "de la tarde" = in the afternoon\n• "de la noche" = in the evening/night',
            examples: [
              'Son las tres de la tarde - It is 3:00 PM',
              'Es la una de la mañana - It is 1:00 AM',
              'Son las diez de la noche - It is 10:00 PM',
            ],
          ),
          ExampleSection(
            id: 'listening5',
            spanishExample: 'Son las tres de la tarde',
            englishTranslation: 'It is three in the afternoon',
            explanation: '"Son las" is used for telling time (except 1:00). "De la tarde" means "in the afternoon" (from noon to evening).',
          ),
          ExampleSection(
            id: 'listening5b',
            spanishExample: 'Es la una de la mañana',
            englishTranslation: 'It is one in the morning',
            explanation: 'For 1:00, use "Es la" (singular) instead of "Son las" (plural). "De la mañana" means "in the morning".',
          ),
          ExerciseSection(
            id: 'exercise5',
            question: 'Listen: "Son las tres de la tarde." What time is it?',
            options: [
              ExerciseOption(text: '3:00 PM (three in the afternoon)', isCorrect: true),
              ExerciseOption(text: '3:00 AM (three in the morning)', isCorrect: false),
              ExerciseOption(text: '13:00 (one o\'clock)', isCorrect: false),
              ExerciseOption(text: '30:00 (thirty o\'clock)', isCorrect: false),
            ],
            explanation: 'Correct! "Son las tres de la tarde" means "It is three in the afternoon" (3:00 PM).',
          ),
          ExerciseSection(
            id: 'exercise5b',
            question: 'How would you say "It is 1:00 PM" in Spanish?',
            options: [
              ExerciseOption(text: 'Es la una de la tarde', isCorrect: true),
              ExerciseOption(text: 'Son las una de la tarde', isCorrect: false),
              ExerciseOption(text: 'Es la uno de la tarde', isCorrect: false),
              ExerciseOption(text: 'Son las uno de la tarde', isCorrect: false),
            ],
            explanation: 'Correct! For 1:00, use "Es la una" (singular). "Una" is the feminine form of "one" used for time.',
          ),
          TextSection(
            id: 'feelings_intro',
            title: 'Expressing Feelings with Tener',
            content:
                'In Spanish, many feelings and states use "tener" (to have) instead of "estar" (to be):\n• Tengo hambre - I am hungry\n• Tengo sed - I am thirsty\n• Tengo frío - I am cold\n• Tengo calor - I am hot',
            examples: [
              'Tengo hambre - I am hungry (literally: I have hunger)',
              'Tengo sed - I am thirsty (literally: I have thirst)',
              'Tengo sueño - I am sleepy (literally: I have sleepiness)',
            ],
          ),
          ExampleSection(
            id: 'listening6',
            spanishExample: 'Tengo hambre',
            englishTranslation: 'I am hungry',
            explanation: 'Literally means "I have hunger". In Spanish, you express feelings and states using "tener" (to have).',
          ),
          ExerciseSection(
            id: 'exercise6',
            question: 'How would you say "I am thirsty" in Spanish?',
            options: [
              ExerciseOption(text: 'Tengo sed', isCorrect: true),
              ExerciseOption(text: 'Estoy sed', isCorrect: false),
              ExerciseOption(text: 'Soy sed', isCorrect: false),
              ExerciseOption(text: 'Tengo hambre', isCorrect: false),
            ],
            explanation: 'Correct! "Tengo sed" means "I am thirsty". Use "tener" (to have) for feelings like hunger and thirst.',
          ),
          TextSection(
            id: 'tips',
            title: 'Listening Tips',
            content:
                'Great job completing this lesson! Here are some tips to continue improving your listening skills:\n\n1. Listen to Spanish audio regularly, even if you don\'t understand everything\n2. Start with slow, clear speech\n3. Focus on understanding the main idea first\n4. Practice with familiar topics\n5. Repeat phrases out loud to improve pronunciation\n6. Watch Spanish videos with subtitles\n7. Listen to Spanish music and try to catch words\n8. Practice with language learning apps daily',
            examples: [
              'Watch Spanish videos with subtitles',
              'Listen to Spanish music and try to catch words',
              'Practice with language learning apps',
              'Have conversations with native speakers',
            ],
          ),
        ],
      ),
      unlocksWordIds: [
        'hola',
        'buenos_días',
        'buenas_tardes',
        'buenas_noches',
        'cómo',
        'estás',
        'está',
        'llamo',
        'años',
        'vivo',
        'familia',
        'gusta',
        'gustan',
        'café',
        'hambre',
        'sed',
        'tarde',
        'mañana',
        'noche',
      ],
      unlocksGrammarConcepts: ['greetings', 'introductions', 'basic_questions', 'tener_expressions', 'time_expressions'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Lesson _createPresentTenseVerbsLesson() {
    return Lesson(
      id: 'spanish_present_tense_verbs',
      title: 'Present Tense Verbs',
      description: 'Learn how to conjugate and use Spanish present tense verbs',
      language: 'spanish',
      category: 'verb_tenses',
      orderIndex: 1,
      estimatedMinutes: 30,
      content: LessonContent(
        sections: [
          TextSection(
            id: 'intro',
            title: 'Introduction to Present Tense',
            content:
                'The present tense in Spanish is used to describe:\n• Actions happening right now\n• Habitual actions (things you do regularly)\n• General truths\n\nSpanish verbs change their endings based on the subject (who is doing the action).',
            examples: [
              'Yo hablo español (I speak Spanish) - happening now',
              'Tú comes manzanas todos los días (You eat apples every day) - habitual',
              'El sol sale por el este (The sun rises in the east) - general truth',
            ],
          ),
          TextSection(
            id: 'ar_verbs_intro',
            title: '-AR Verbs: The Most Common Type',
            content:
                'Most Spanish verbs end in -AR. To conjugate them, remove the -AR ending and add the appropriate ending for each subject:\n\n• Yo: -o\n• Tú: -as\n• Él/Ella/Usted: -a\n• Nosotros: -amos\n• Vosotros: -áis\n• Ellos/Ellas/Ustedes: -an',
            examples: [
              'hablar (to speak): hablo, hablas, habla, hablamos, habláis, hablan',
              'caminar (to walk): camino, caminas, camina, caminamos, camináis, caminan',
            ],
          ),
          ExampleSection(
            id: 'example1',
            spanishExample: 'Yo hablo español todos los días',
            englishTranslation: 'I speak Spanish every day',
            explanation: 'The verb "hablar" (to speak) ends in -o for "yo" (I). Notice how "todos los días" (every day) shows this is a habitual action.',
          ),
          ExampleSection(
            id: 'example1b',
            spanishExample: 'Tú hablas muy bien',
            englishTranslation: 'You speak very well',
            explanation: 'For "tú" (you informal), the ending is -as. "Muy bien" means "very well".',
          ),
          ExampleSection(
            id: 'example1c',
            spanishExample: 'Él habla con su amigo',
            englishTranslation: 'He speaks with his friend',
            explanation: 'For "él" (he), the ending is -a. "Con su amigo" means "with his friend".',
          ),
          ExerciseSection(
            id: 'exercise1',
            question: 'How do you say "I speak" in Spanish?',
            options: [
              ExerciseOption(text: 'Yo hablo', isCorrect: true),
              ExerciseOption(text: 'Yo hablas', isCorrect: false),
              ExerciseOption(text: 'Yo habla', isCorrect: false),
              ExerciseOption(text: 'Yo hablan', isCorrect: false),
            ],
            explanation: 'Correct! "Yo hablo" means "I speak". The verb "hablar" uses -o ending for "yo".',
          ),
          ExerciseSection(
            id: 'exercise1b',
            question: 'Which is the correct form of "hablar" (to speak) for "tú" (you)?',
            options: [
              ExerciseOption(text: 'hablas', isCorrect: true),
              ExerciseOption(text: 'hablo', isCorrect: false),
              ExerciseOption(text: 'habla', isCorrect: false),
              ExerciseOption(text: 'hablan', isCorrect: false),
            ],
            explanation: 'Correct! "Tú hablas" means "You speak". The -as ending is used for "tú".',
          ),
          ExerciseSection(
            id: 'exercise1c',
            question: 'Complete: "Nosotros _____ español." (We speak Spanish)',
            options: [
              ExerciseOption(text: 'hablamos', isCorrect: true),
              ExerciseOption(text: 'hablan', isCorrect: false),
              ExerciseOption(text: 'habla', isCorrect: false),
              ExerciseOption(text: 'hablas', isCorrect: false),
            ],
            explanation: 'Correct! "Nosotros hablamos" means "We speak". The -amos ending is used for "nosotros".',
          ),
          TextSection(
            id: 'er_verbs_intro',
            title: '-ER Verbs: Second Type',
            content:
                'Many Spanish verbs end in -ER. The conjugation pattern is:\n\n• Yo: -o\n• Tú: -es\n• Él/Ella/Usted: -e\n• Nosotros: -emos\n• Vosotros: -éis\n• Ellos/Ellas/Ustedes: -en',
            examples: [
              'comer (to eat): como, comes, come, comemos, coméis, comen',
              'beber (to drink): bebo, bebes, bebe, bebemos, bebéis, beben',
            ],
          ),
          ExampleSection(
            id: 'example2',
            spanishExample: 'Yo como manzanas',
            englishTranslation: 'I eat apples',
            explanation: 'The verb "comer" (to eat) uses -o ending for "yo". Notice "manzanas" (apples) is plural.',
          ),
          ExampleSection(
            id: 'example2b',
            spanishExample: 'Ella come pan en el desayuno',
            englishTranslation: 'She eats bread for breakfast',
            explanation: 'For "ella" (she), the ending is -e. "En el desayuno" means "for breakfast".',
          ),
          ExerciseSection(
            id: 'exercise2',
            question: 'How do you say "I eat" in Spanish?',
            options: [
              ExerciseOption(text: 'Yo como', isCorrect: true),
              ExerciseOption(text: 'Yo come', isCorrect: false),
              ExerciseOption(text: 'Yo comen', isCorrect: false),
              ExerciseOption(text: 'Yo comes', isCorrect: false),
            ],
            explanation: 'Correct! "Yo como" means "I eat". The verb "comer" (to eat) uses -o ending for "yo".',
          ),
          ExerciseSection(
            id: 'exercise2b',
            question: 'Complete: "Tú _____ agua." (You drink water)',
            options: [
              ExerciseOption(text: 'bebes', isCorrect: true),
              ExerciseOption(text: 'bebe', isCorrect: false),
              ExerciseOption(text: 'bebo', isCorrect: false),
              ExerciseOption(text: 'beben', isCorrect: false),
            ],
            explanation: 'Correct! "Tú bebes" means "You drink". The -es ending is used for "tú" with -ER verbs.',
          ),
          TextSection(
            id: 'ir_verbs_intro',
            title: '-IR Verbs: Third Type',
            content:
                'Some Spanish verbs end in -IR. The conjugation is similar to -ER verbs:\n\n• Yo: -o\n• Tú: -es\n• Él/Ella/Usted: -e\n• Nosotros: -imos (different from -ER!)\n• Vosotros: -ís\n• Ellos/Ellas/Ustedes: -en',
            examples: [
              'vivir (to live): vivo, vives, vive, vivimos, vivís, viven',
              'escribir (to write): escribo, escribes, escribe, escribimos, escribís, escriben',
            ],
          ),
          ExampleSection(
            id: 'example3',
            spanishExample: 'Yo vivo en España',
            englishTranslation: 'I live in Spain',
            explanation: 'The verb "vivir" (to live) uses -o ending for "yo". Notice it\'s similar to -ER verbs for most forms.',
          ),
          ExampleSection(
            id: 'example3b',
            spanishExample: 'Nosotros vivimos en Madrid',
            englishTranslation: 'We live in Madrid',
            explanation: 'For "nosotros" with -IR verbs, use -imos (not -emos like -ER verbs). This is the key difference!',
          ),
          ExerciseSection(
            id: 'exercise3',
            question: 'How do you say "I write" in Spanish?',
            options: [
              ExerciseOption(text: 'Yo escribo', isCorrect: true),
              ExerciseOption(text: 'Yo escribes', isCorrect: false),
              ExerciseOption(text: 'Yo escribe', isCorrect: false),
              ExerciseOption(text: 'Yo escriben', isCorrect: false),
            ],
            explanation: 'Correct! "Yo escribo" means "I write". The verb "escribir" uses -o ending for "yo".',
          ),
          ExerciseSection(
            id: 'exercise3b',
            question: 'What is the difference between -ER and -IR verbs for "nosotros"?',
            options: [
              ExerciseOption(text: '-ER uses -emos, -IR uses -imos', isCorrect: true),
              ExerciseOption(text: 'They are the same', isCorrect: false),
              ExerciseOption(text: '-ER uses -imos, -IR uses -emos', isCorrect: false),
              ExerciseOption(text: 'Both use -amos', isCorrect: false),
            ],
            explanation: 'Correct! -ER verbs use -emos for "nosotros", while -IR verbs use -imos. This is the main difference!',
          ),
          TextSection(
            id: 'practice_intro',
            title: 'Practice: Mixing Verb Types',
            content:
                'Now let\'s practice identifying and conjugating different verb types. Remember:\n• -AR verbs: hablo, hablas, habla, hablamos, habláis, hablan\n• -ER verbs: como, comes, come, comemos, coméis, comen\n• -IR verbs: vivo, vives, vive, vivimos, vivís, viven',
            examples: [
              'Look at the infinitive ending to identify the type',
              'Remove the ending and add the correct subject ending',
              'Practice with common verbs you know',
            ],
          ),
          ExerciseSection(
            id: 'exercise4',
            question: 'Which verb type is "trabajar" (to work)?',
            options: [
              ExerciseOption(text: '-AR verb', isCorrect: true),
              ExerciseOption(text: '-ER verb', isCorrect: false),
              ExerciseOption(text: '-IR verb', isCorrect: false),
              ExerciseOption(text: 'Irregular verb', isCorrect: false),
            ],
            explanation: 'Correct! "Trabajar" ends in -AR, so it\'s an -AR verb. It conjugates: trabajo, trabajas, trabaja, trabajamos, trabajáis, trabajan.',
          ),
          ExerciseSection(
            id: 'exercise4b',
            question: 'Complete: "Él _____ en una oficina." (He works in an office)',
            options: [
              ExerciseOption(text: 'trabaja', isCorrect: true),
              ExerciseOption(text: 'trabajo', isCorrect: false),
              ExerciseOption(text: 'trabajas', isCorrect: false),
              ExerciseOption(text: 'trabajan', isCorrect: false),
            ],
            explanation: 'Correct! "Él trabaja" means "He works". For -AR verbs with "él", use the -a ending.',
          ),
          ExerciseSection(
            id: 'exercise5',
            question: 'Which is correct: "Ellos viven" or "Ellos vive"?',
            options: [
              ExerciseOption(text: 'Ellos viven', isCorrect: true),
              ExerciseOption(text: 'Ellos vive', isCorrect: false),
              ExerciseOption(text: 'Both are correct', isCorrect: false),
              ExerciseOption(text: 'Ellos vivir', isCorrect: false),
            ],
            explanation: 'Correct! "Ellos viven" means "They live". For plural subjects (ellos/ellas), use -en ending with -IR verbs.',
          ),
          TextSection(
            id: 'summary',
            title: 'Summary: Present Tense Conjugation',
            content:
                'Great work! You\'ve learned the three main verb types in Spanish:\n\n1. -AR verbs (most common): hablo, hablas, habla, hablamos, habláis, hablan\n2. -ER verbs: como, comes, come, comemos, coméis, comen\n3. -IR verbs: vivo, vives, vive, vivimos, vivís, viven\n\nKey points to remember:\n• All verbs use -o for "yo"\n• -AR and -ER/-IR differ in tú, él, ellos forms\n• -ER and -IR differ only in nosotros form (-emos vs -imos)',
            examples: [
              'Practice conjugating verbs daily',
              'Start with common verbs you use often',
              'Pay attention to the infinitive ending',
            ],
          ),
        ],
      ),
      unlocksWordIds: [
        'hablar',
        'comer',
        'vivir',
        'caminar',
        'trabajar',
        'beber',
        'escribir',
        'estudiar',
        'aprender',
        'entender',
      ],
      unlocksGrammarConcepts: ['present_tense', 'ar_verbs', 'er_verbs', 'ir_verbs', 'verb_conjugation'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Lesson _createArticlesLesson() {
    return Lesson(
      id: 'spanish_articles',
      title: 'Articles: El, La, Los, Las',
      description: 'Learn about Spanish definite articles and gender agreement',
      language: 'spanish',
      category: 'articles',
      orderIndex: 2,
      estimatedMinutes: 25,
      content: LessonContent(
        sections: [
          TextSection(
            id: 'intro',
            title: 'What are Articles?',
            content:
                'Articles are small words that come before nouns. In English, we have "the" and "a/an". Spanish has more articles because they must match the noun\'s gender (masculine/feminine) and number (singular/plural).\n\nThis lesson covers:\n• Definite articles (the)\n• Indefinite articles (a/an)\n• Gender agreement rules',
            examples: [
              'el libro (the book) - masculine singular',
              'la mesa (the table) - feminine singular',
              'los libros (the books) - masculine plural',
              'las mesas (the tables) - feminine plural',
            ],
          ),
          TextSection(
            id: 'definite_intro',
            title: 'Definite Articles: "The"',
            content:
                'Spanish has four definite articles (meaning "the"):\n\n• el (masculine singular) - the\n• la (feminine singular) - the\n• los (masculine plural) - the\n• las (feminine plural) - the\n\nThe article must match the noun in both gender and number!',
            examples: [
              'el gato (the cat) - masculine singular',
              'la gata (the female cat) - feminine singular',
              'los gatos (the cats) - masculine plural',
              'las gatas (the female cats) - feminine plural',
            ],
          ),
          ExampleSection(
            id: 'example1',
            spanishExample: 'El gato es negro',
            englishTranslation: 'The cat is black',
            explanation: '"Gato" (cat) is masculine singular, so we use "el". Notice "negro" (black) also agrees with the masculine noun.',
          ),
          ExampleSection(
            id: 'example1b',
            spanishExample: 'La gata es negra',
            englishTranslation: 'The female cat is black',
            explanation: '"Gata" (female cat) is feminine singular, so we use "la". Also notice "negra" (black) changes to feminine form!',
          ),
          ExampleSection(
            id: 'example2',
            spanishExample: 'La casa es grande',
            englishTranslation: 'The house is big',
            explanation: '"Casa" (house) is feminine singular, so we use "la". Most words ending in -a are feminine.',
          ),
          ExampleSection(
            id: 'example2b',
            spanishExample: 'Los libros son interesantes',
            englishTranslation: 'The books are interesting',
            explanation: '"Libros" (books) is masculine plural, so we use "los". Notice "son" (are) is used for plural.',
          ),
          ExerciseSection(
            id: 'exercise1',
            question: 'Which article is correct for "casa" (house)?',
            options: [
              ExerciseOption(text: 'la', isCorrect: true),
              ExerciseOption(text: 'el', isCorrect: false),
              ExerciseOption(text: 'los', isCorrect: false),
              ExerciseOption(text: 'las', isCorrect: false),
            ],
            explanation: 'Correct! "Casa" is feminine singular, so we use "la casa". Most words ending in -a are feminine.',
          ),
          ExerciseSection(
            id: 'exercise1b',
            question: 'Complete: "_____ gato es pequeño." (The cat is small)',
            options: [
              ExerciseOption(text: 'El', isCorrect: true),
              ExerciseOption(text: 'La', isCorrect: false),
              ExerciseOption(text: 'Los', isCorrect: false),
              ExerciseOption(text: 'Las', isCorrect: false),
            ],
            explanation: 'Correct! "Gato" (cat) is masculine singular, so use "el".',
          ),
          ExerciseSection(
            id: 'exercise2',
            question: 'How do you say "the books" in Spanish?',
            options: [
              ExerciseOption(text: 'los libros', isCorrect: true),
              ExerciseOption(text: 'el libro', isCorrect: false),
              ExerciseOption(text: 'la libro', isCorrect: false),
              ExerciseOption(text: 'las libros', isCorrect: false),
            ],
            explanation: 'Correct! "Libro" is masculine and becomes "libros" (plural), so we use "los libros".',
          ),
          ExerciseSection(
            id: 'exercise2b',
            question: 'Complete: "_____ mesas son grandes." (The tables are big)',
            options: [
              ExerciseOption(text: 'Las', isCorrect: true),
              ExerciseOption(text: 'La', isCorrect: false),
              ExerciseOption(text: 'Los', isCorrect: false),
              ExerciseOption(text: 'El', isCorrect: false),
            ],
            explanation: 'Correct! "Mesa" is feminine and becomes "mesas" (plural), so use "las".',
          ),
          TextSection(
            id: 'indefinite_intro',
            title: 'Indefinite Articles: "A/An"',
            content:
                'Spanish also has indefinite articles (meaning "a" or "an"):\n\n• un (masculine singular) - a/an\n• una (feminine singular) - a/an\n• unos (masculine plural) - some\n• unas (feminine plural) - some\n\nThese also must match the noun\'s gender and number!',
            examples: [
              'un libro (a book) - masculine singular',
              'una mesa (a table) - feminine singular',
              'unos libros (some books) - masculine plural',
              'unas mesas (some tables) - feminine plural',
            ],
          ),
          ExampleSection(
            id: 'example3',
            spanishExample: 'Tengo un perro',
            englishTranslation: 'I have a dog',
            explanation: '"Perro" (dog) is masculine singular, so we use "un". "Tengo" means "I have".',
          ),
          ExampleSection(
            id: 'example3b',
            spanishExample: 'Ella tiene una gata',
            englishTranslation: 'She has a female cat',
            explanation: '"Gata" (female cat) is feminine singular, so we use "una". "Ella tiene" means "she has".',
          ),
          ExerciseSection(
            id: 'exercise3',
            question: 'Complete: "Necesito _____ libro." (I need a book)',
            options: [
              ExerciseOption(text: 'un', isCorrect: true),
              ExerciseOption(text: 'una', isCorrect: false),
              ExerciseOption(text: 'el', isCorrect: false),
              ExerciseOption(text: 'la', isCorrect: false),
            ],
            explanation: 'Correct! "Libro" is masculine singular, so use "un libro" (a book).',
          ),
          ExerciseSection(
            id: 'exercise3b',
            question: 'How do you say "some apples" in Spanish? (manzana = apple)',
            options: [
              ExerciseOption(text: 'unas manzanas', isCorrect: true),
              ExerciseOption(text: 'una manzana', isCorrect: false),
              ExerciseOption(text: 'unos manzanas', isCorrect: false),
              ExerciseOption(text: 'las manzanas', isCorrect: false),
            ],
            explanation: 'Correct! "Manzana" is feminine and becomes "manzanas" (plural), so use "unas manzanas" (some apples).',
          ),
          TextSection(
            id: 'gender_rules',
            title: 'Gender Rules: How to Know?',
            content:
                'How do you know if a noun is masculine or feminine?\n\nGeneral rules:\n• Words ending in -o are usually masculine: el libro, el gato\n• Words ending in -a are usually feminine: la casa, la mesa\n• Words ending in -ión are usually feminine: la nación, la acción\n• Words ending in -dad/-tad are usually feminine: la ciudad, la libertad\n\nBut there are exceptions! You\'ll learn them with practice.',
            examples: [
              'el problema (the problem) - ends in -a but is masculine!',
              'la mano (the hand) - ends in -o but is feminine!',
              'el día (the day) - ends in -a but is masculine!',
            ],
          ),
          ExerciseSection(
            id: 'exercise4',
            question: 'Which article would you use for "problema" (problem)?',
            options: [
              ExerciseOption(text: 'el', isCorrect: true),
              ExerciseOption(text: 'la', isCorrect: false),
              ExerciseOption(text: 'los', isCorrect: false),
              ExerciseOption(text: 'las', isCorrect: false),
            ],
            explanation: 'Correct! Even though "problema" ends in -a, it\'s masculine! This is an exception. Use "el problema".',
          ),
          ExerciseSection(
            id: 'exercise4b',
            question: 'Complete: "_____ mano es pequeña." (The hand is small)',
            options: [
              ExerciseOption(text: 'La', isCorrect: true),
              ExerciseOption(text: 'El', isCorrect: false),
              ExerciseOption(text: 'Los', isCorrect: false),
              ExerciseOption(text: 'Las', isCorrect: false),
            ],
            explanation: 'Correct! "Mano" (hand) ends in -o but is feminine! This is an exception. Use "la mano".',
          ),
          TextSection(
            id: 'summary',
            title: 'Summary: Articles in Spanish',
            content:
                'Excellent work! You\'ve learned:\n\nDefinite Articles (the):\n• el / la (singular)\n• los / las (plural)\n\nIndefinite Articles (a/an, some):\n• un / una (singular)\n• unos / unas (plural)\n\nKey points:\n• Articles must match gender (masculine/feminine)\n• Articles must match number (singular/plural)\n• Most -o words are masculine, most -a words are feminine\n• But there are exceptions you\'ll learn with practice!',
            examples: [
              'Practice with common nouns daily',
              'Pay attention to article-noun agreement',
              'Learn exceptions as you encounter them',
            ],
          ),
        ],
      ),
      unlocksWordIds: [
        'el',
        'la',
        'los',
        'las',
        'un',
        'una',
        'unos',
        'unas',
        'casa',
        'libro',
        'mesa',
        'gato',
        'perro',
        'manzana',
        'problema',
        'mano',
      ],
      unlocksGrammarConcepts: ['articles', 'definite_articles', 'indefinite_articles', 'gender_agreement', 'number_agreement'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Lesson _createSubjectPronounsLesson() {
    return Lesson(
      id: 'spanish_subject_pronouns',
      title: 'Subject Pronouns',
      description: 'Learn Spanish subject pronouns: yo, tú, él, ella, etc.',
      language: 'spanish',
      category: 'pronouns',
      orderIndex: 3,
      estimatedMinutes: 7,
      content: LessonContent(
        sections: [
          TextSection(
            id: 'intro',
            title: 'Subject Pronouns',
            content:
                'Subject pronouns in Spanish are: yo (I), tú (you informal), él (he), ella (she), nosotros/nosotras (we), vosotros/vosotras (you plural), ellos/ellas (they).',
            examples: [
              'Yo soy estudiante (I am a student)',
              'Tú eres profesor (You are a teacher)',
              'Él es médico (He is a doctor)',
            ],
          ),
          ExampleSection(
            id: 'example1',
            spanishExample: 'Yo hablo español',
            englishTranslation: 'I speak Spanish',
            explanation: '"Yo" is the first person singular pronoun',
          ),
          ExerciseSection(
            id: 'exercise1',
            question: 'Which pronoun means "we" (masculine)?',
            options: [
              ExerciseOption(text: 'yo', isCorrect: false),
              ExerciseOption(text: 'tú', isCorrect: false),
              ExerciseOption(text: 'nosotros', isCorrect: true),
              ExerciseOption(text: 'ellos', isCorrect: false),
            ],
            explanation: 'Correct! "Nosotros" means "we" (masculine or mixed group).',
          ),
        ],
      ),
      unlocksWordIds: [
        'yo',
        'tú',
        'él',
        'ella',
        'nosotros',
        'nosotras',
        'ellos',
        'ellas',
      ],
      unlocksGrammarConcepts: ['subject_pronouns'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Lesson _createBasicSentenceStructureLesson() {
    return Lesson(
      id: 'spanish_basic_sentence_structure',
      title: 'Basic Sentence Structure',
      description: 'Learn how to build basic Spanish sentences',
      language: 'spanish',
      category: 'syntax',
      orderIndex: 4,
      estimatedMinutes: 30,
      content: LessonContent(
        sections: [
          TextSection(
            id: 'intro',
            title: 'Building Sentences in Spanish',
            content:
                'Spanish sentences follow a specific word order, similar to English but with some important differences.\n\nBasic pattern:\nSubject + Verb + Object\n\nBut remember:\n• Articles and adjectives must agree with nouns\n• Adjectives usually come AFTER nouns\n• Questions use inverted word order or question words',
            examples: [
              'El gato come pescado (The cat eats fish)',
              'La niña juega en el parque (The girl plays in the park)',
              'El libro es interesante (The book is interesting)',
            ],
          ),
          TextSection(
            id: 'simple_sentences',
            title: 'Simple Sentences: Subject + Verb',
            content:
                'The simplest sentences have just a subject and a verb. The subject can be:\n• A noun with article: "El perro corre"\n• A pronoun: "Yo hablo"\n• Or omitted: "Hablo" (I speak)',
            examples: [
              'El perro corre (The dog runs)',
              'Yo estudio (I study)',
              'Ella canta (She sings)',
            ],
          ),
          ExampleSection(
            id: 'example1',
            spanishExample: 'El perro corre',
            englishTranslation: 'The dog runs',
            explanation: 'Simple sentence: Subject (el perro) + Verb (corre). Notice the article "el" agrees with the masculine noun "perro".',
          ),
          ExampleSection(
            id: 'example1b',
            spanishExample: 'Las niñas juegan',
            englishTranslation: 'The girls play',
            explanation: 'Subject (las niñas) + Verb (juegan). Notice "las" (plural feminine) and "juegan" (plural verb form).',
          ),
          ExerciseSection(
            id: 'exercise1',
            question: 'Complete: "_____ gato duerme." (The cat sleeps)',
            options: [
              ExerciseOption(text: 'El', isCorrect: true),
              ExerciseOption(text: 'La', isCorrect: false),
              ExerciseOption(text: 'Los', isCorrect: false),
              ExerciseOption(text: 'Las', isCorrect: false),
            ],
            explanation: 'Correct! "Gato" (cat) is masculine singular, so use "el". The sentence is: "El gato duerme" (The cat sleeps).',
          ),
          TextSection(
            id: 'object_intro',
            title: 'Adding Objects: Subject + Verb + Object',
            content:
                'When you add an object (what receives the action), the order is:\n\nSubject + Verb + Direct Object\n\nExamples:\n• El niño come una manzana (The boy eats an apple)\n• La mujer lee un libro (The woman reads a book)\n• Yo compro pan (I buy bread)',
            examples: [
              'El niño come una manzana (The boy eats an apple)',
              'La mujer lee un libro (The woman reads a book)',
              'Nosotros compramos pan (We buy bread)',
            ],
          ),
          ExampleSection(
            id: 'example2',
            spanishExample: 'La niña come una manzana',
            englishTranslation: 'The girl eats an apple',
            explanation: 'Subject (la niña) + Verb (come) + Object (una manzana). Notice "una" (feminine) agrees with "manzana".',
          ),
          ExampleSection(
            id: 'example2b',
            spanishExample: 'El estudiante lee los libros',
            englishTranslation: 'The student reads the books',
            explanation: 'Subject (el estudiante) + Verb (lee) + Object (los libros). Notice "los" (masculine plural) agrees with "libros".',
          ),
          ExerciseSection(
            id: 'exercise2',
            question: 'What is the correct order for "The boy eats an apple"?',
            options: [
              ExerciseOption(text: 'El niño come una manzana', isCorrect: true),
              ExerciseOption(text: 'Come el niño una manzana', isCorrect: false),
              ExerciseOption(text: 'Una manzana come el niño', isCorrect: false),
              ExerciseOption(text: 'El niño una manzana come', isCorrect: false),
            ],
            explanation: 'Correct! Spanish follows Subject + Verb + Object order: "El niño come una manzana".',
          ),
          ExerciseSection(
            id: 'exercise2b',
            question: 'Complete: "La mujer _____ un libro." (The woman reads a book)',
            options: [
              ExerciseOption(text: 'lee', isCorrect: true),
              ExerciseOption(text: 'leer', isCorrect: false),
              ExerciseOption(text: 'leemos', isCorrect: false),
              ExerciseOption(text: 'leen', isCorrect: false),
            ],
            explanation: 'Correct! "La mujer" (the woman) is third person singular, so use "lee" (reads).',
          ),
          TextSection(
            id: 'adjectives_intro',
            title: 'Adding Adjectives',
            content:
                'In Spanish, adjectives usually come AFTER the noun (unlike English!):\n\n• El libro interesante (The interesting book)\n• La casa grande (The big house)\n• Los gatos negros (The black cats)\n\nAdjectives must agree with the noun in:\n• Gender (masculine/feminine)\n• Number (singular/plural)',
            examples: [
              'El libro interesante (The interesting book)',
              'La casa grande (The big house)',
              'Los gatos negros (The black cats)',
              'Las casas grandes (The big houses)',
            ],
          ),
          ExampleSection(
            id: 'example3',
            spanishExample: 'El gato negro duerme',
            englishTranslation: 'The black cat sleeps',
            explanation: 'Notice "negro" (black) comes AFTER "gato" and agrees with it (masculine singular). In English, adjectives come before nouns!',
          ),
          ExampleSection(
            id: 'example3b',
            spanishExample: 'Las casas grandes son bonitas',
            englishTranslation: 'The big houses are pretty',
            explanation: 'Both "grandes" (big) and "bonitas" (pretty) come after the noun and agree: feminine plural. "Son" means "are".',
          ),
          ExerciseSection(
            id: 'exercise3',
            question: 'Complete: "El libro _____ es interesante." (The red book is interesting)',
            options: [
              ExerciseOption(text: 'rojo', isCorrect: true),
              ExerciseOption(text: 'roja', isCorrect: false),
              ExerciseOption(text: 'rojos', isCorrect: false),
              ExerciseOption(text: 'rojas', isCorrect: false),
            ],
            explanation: 'Correct! "Libro" is masculine singular, so "rojo" (red) must also be masculine singular. The adjective comes after the noun.',
          ),
          ExerciseSection(
            id: 'exercise3b',
            question: 'Which sentence is correct?',
            options: [
              ExerciseOption(text: 'La casa grande', isCorrect: true),
              ExerciseOption(text: 'La grande casa', isCorrect: false),
              ExerciseOption(text: 'Grande la casa', isCorrect: false),
              ExerciseOption(text: 'La casa grande es', isCorrect: false),
            ],
            explanation: 'Correct! In Spanish, adjectives usually come AFTER the noun: "la casa grande" (the big house).',
          ),
          TextSection(
            id: 'questions_intro',
            title: 'Forming Questions',
            content:
                'Spanish questions can be formed in two ways:\n\n1. Invert word order:\n• "¿Hablas español?" (Do you speak Spanish?)\n• "¿Come el gato?" (Does the cat eat?)\n\n2. Use question words:\n• ¿Qué? (What?)\n• ¿Quién? (Who?)\n• ¿Dónde? (Where?)\n• ¿Cuándo? (When?)\n• ¿Por qué? (Why?)\n• ¿Cómo? (How?)',
            examples: [
              '¿Hablas español? (Do you speak Spanish?)',
              '¿Qué comes? (What do you eat?)',
              '¿Dónde vives? (Where do you live?)',
            ],
          ),
          ExampleSection(
            id: 'example4',
            spanishExample: '¿Hablas español?',
            englishTranslation: 'Do you speak Spanish?',
            explanation: 'Question formed by inverting word order. In statements: "Tú hablas español". In questions: "¿Hablas español?" (pronoun often omitted).',
          ),
          ExampleSection(
            id: 'example4b',
            spanishExample: '¿Qué comes?',
            englishTranslation: 'What do you eat?',
            explanation: 'Question using "¿Qué?" (What?). The question word comes first, then the verb. "Comes" means "you eat".',
          ),
          ExerciseSection(
            id: 'exercise4',
            question: 'How would you ask "Where do you live?" in Spanish?',
            options: [
              ExerciseOption(text: '¿Dónde vives?', isCorrect: true),
              ExerciseOption(text: '¿Dónde vives tú?', isCorrect: false),
              ExerciseOption(text: '¿Vives dónde?', isCorrect: false),
              ExerciseOption(text: '¿Dónde tú vives?', isCorrect: false),
            ],
            explanation: 'Correct! "¿Dónde vives?" means "Where do you live?". The question word comes first, then the verb. The pronoun is usually omitted.',
          ),
          ExerciseSection(
            id: 'exercise4b',
            question: 'Complete: "¿_____ estudias?" (What do you study?)',
            options: [
              ExerciseOption(text: 'Qué', isCorrect: true),
              ExerciseOption(text: 'Quién', isCorrect: false),
              ExerciseOption(text: 'Dónde', isCorrect: false),
              ExerciseOption(text: 'Cuándo', isCorrect: false),
            ],
            explanation: 'Correct! "¿Qué estudias?" means "What do you study?". "Qué" means "what".',
          ),
          TextSection(
            id: 'negation_intro',
            title: 'Making Negative Sentences',
            content:
                'To make a sentence negative in Spanish, put "no" BEFORE the verb:\n\n• No hablo español (I don\'t speak Spanish)\n• No como carne (I don\'t eat meat)\n• No tengo hambre (I am not hungry)\n\nYou can also use other negative words:\n• nunca (never)\n• nada (nothing)\n• nadie (nobody)',
            examples: [
              'No hablo español (I don\'t speak Spanish)',
              'Nunca como carne (I never eat meat)',
              'No tengo nada (I don\'t have anything)',
            ],
          ),
          ExampleSection(
            id: 'example5',
            spanishExample: 'No hablo inglés',
            englishTranslation: 'I don\'t speak English',
            explanation: 'Simply put "no" before the verb to make it negative. "No hablo" means "I don\'t speak".',
          ),
          ExerciseSection(
            id: 'exercise5',
            question: 'How would you say "I don\'t eat meat" in Spanish?',
            options: [
              ExerciseOption(text: 'No como carne', isCorrect: true),
              ExerciseOption(text: 'Como no carne', isCorrect: false),
              ExerciseOption(text: 'No carne como', isCorrect: false),
              ExerciseOption(text: 'Como carne no', isCorrect: false),
            ],
            explanation: 'Correct! Put "no" before the verb: "No como carne" (I don\'t eat meat).',
          ),
          TextSection(
            id: 'summary',
            title: 'Summary: Sentence Structure',
            content:
                'Excellent work! You\'ve learned:\n\nBasic word order:\n• Subject + Verb + Object\n• El niño come una manzana\n\nAdjectives:\n• Usually come AFTER nouns\n• Must agree in gender and number\n• La casa grande (the big house)\n\nQuestions:\n• Invert word order or use question words\n• ¿Hablas español? (Do you speak Spanish?)\n• ¿Qué comes? (What do you eat?)\n\nNegation:\n• Put "no" before the verb\n• No hablo español (I don\'t speak Spanish)',
            examples: [
              'Practice building sentences daily',
              'Pay attention to word order',
              'Remember adjective placement and agreement',
            ],
          ),
        ],
      ),
      unlocksWordIds: [
        'perro',
        'gato',
        'niño',
        'niña',
        'libro',
        'manzana',
        'casa',
        'estudiante',
        'qué',
        'dónde',
        'cuándo',
        'cómo',
      ],
      unlocksGrammarConcepts: [
        'basic_sentence_structure',
        'subject_verb_object',
        'adjective_placement',
        'question_formation',
        'negation',
        'word_order',
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

