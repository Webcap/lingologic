// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LingoLogic';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get continueLanguageJourney =>
      'Continue your language learning journey';

  @override
  String get email => 'Email';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get login => 'Login';

  @override
  String get or => 'OR';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get loginFailed =>
      'Login failed. Please check your credentials and try again.';

  @override
  String get anonymousLoginFailed =>
      'Anonymous login failed. Please try again.';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get home => 'Home';

  @override
  String get lessons => 'Lessons';

  @override
  String get games => 'Games';

  @override
  String get progress => 'Progress';

  @override
  String get settings => 'Settings';

  @override
  String get managePreferences => 'Manage your preferences';

  @override
  String get account => 'Account';

  @override
  String get guestUser => 'Guest User';

  @override
  String get anonymousAccount => 'Anonymous Account';

  @override
  String get registeredAccount => 'Registered Account';

  @override
  String get appLanguage => 'App Language';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageChangedSuccessfully => 'Language changed successfully!';

  @override
  String get audioSettings => 'Audio Settings';

  @override
  String get volume => 'Volume';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get syncStatus => 'Sync Status';

  @override
  String get offline => 'Offline';

  @override
  String get online => 'Online';

  @override
  String get dataWillSyncWhenOnline => 'Data will sync when online';

  @override
  String get allDataSynced => 'All data synced';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get syncing => 'Syncing...';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get view => 'View';

  @override
  String get signOut => 'Sign Out';

  @override
  String get areYouSureSignOut => 'Are you sure you want to sign out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get practiceWithGames => 'Practice with interactive games';

  @override
  String get gamesLocked => 'Games Locked';

  @override
  String get completeFirstLessonToUnlock =>
      'Complete your first lesson to unlock games and practice what you\'ve learned!';

  @override
  String get goToLessons => 'Go to Lessons';

  @override
  String get refresh => 'Refresh';

  @override
  String get neuroMatch => 'Neuro-Match';

  @override
  String get fastPacedWordMatching => 'Fast-paced word matching game';

  @override
  String get syntaxConstructor => 'Syntax Constructor';

  @override
  String get buildSentencesWithDragDrop => 'Build sentences with drag & drop';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get readyToLearn => 'Ready to learn?';

  @override
  String get currentLevel => 'Current Level';

  @override
  String get beginner => 'Beginner';

  @override
  String get elementary => 'Elementary';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get upperIntermediate => 'Upper Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get proficient => 'Proficient';

  @override
  String get learning => 'Learning';

  @override
  String get dayStreak => 'Day Streak';

  @override
  String get nextLesson => 'Next Lesson';

  @override
  String get start => 'Start';

  @override
  String get progressOverview => 'Progress Overview';

  @override
  String get completed => 'Completed';

  @override
  String get inProgress => 'In Progress';

  @override
  String get totalTime => 'Total Time';

  @override
  String get min => 'min';

  @override
  String get masterGrammarVocabulary => 'Master grammar and vocabulary';

  @override
  String get available => 'Available';

  @override
  String get categories => 'Categories';

  @override
  String get all => 'All';

  @override
  String get noLessonsAvailable => 'No lessons available';

  @override
  String get errorLoadingLessons => 'Error loading lessons';

  @override
  String get errorLaunchingKnowledgeTest => 'Error launching knowledge test';

  @override
  String get noWordsAvailableForMiniGame =>
      'No words available for this mini game yet.';

  @override
  String get errorLaunchingMiniGame => 'Error launching mini game';

  @override
  String get done => 'Done';

  @override
  String get active => 'Active';

  @override
  String get newLesson => 'New';

  @override
  String get locked => 'Locked';

  @override
  String get lesson => 'lesson';

  @override
  String get lessonsPlural => 'lessons';

  @override
  String get complete => 'complete';

  @override
  String get mixedLevel => 'Mixed Level';

  @override
  String get lessonNotFound => 'Lesson not found';

  @override
  String get errorLoadingLesson => 'Error loading lesson';

  @override
  String get lessonComplete => 'Lesson Complete!';

  @override
  String greatJobCompletedLesson(String title) {
    return 'Great job! You\'ve completed \"$title\"';
  }

  @override
  String get newContentUnlocked => 'New content unlocked!';

  @override
  String get errorCompletingLesson => 'Error completing lesson';

  @override
  String get loadingLesson => 'Loading lesson...';

  @override
  String get goBack => 'Go Back';

  @override
  String get learn => 'Learn';

  @override
  String get example => 'Example';

  @override
  String get practice => 'Practice';

  @override
  String get previous => 'Previous';

  @override
  String get continueButton => 'Continue';

  @override
  String get completeButton => 'Complete';

  @override
  String get pleaseSelectLanguageToContinue =>
      'Please select a language to continue';

  @override
  String get errorSettingUpLanguage => 'Error setting up your language';

  @override
  String get welcomeToLingologic => 'Welcome to\nLingoLogic! 🌍';

  @override
  String get chooseFirstLanguageToStart =>
      'Choose your first language to start learning';

  @override
  String get canAddMoreLanguagesAnytime => 'You can add more languages anytime';

  @override
  String get continueLearning => 'Continue Learning';

  @override
  String get noLanguagesAvailable => 'No languages available';

  @override
  String get contactSupportIfSeeThis =>
      'Please contact support if you see this message';

  @override
  String get exitLesson => 'Exit Lesson';

  @override
  String get exitLessonMessage => 'What would you like to do?';

  @override
  String get reset => 'Reset';

  @override
  String get saveAndClose => 'Save and Close';

  @override
  String get resetLessonConfirmation =>
      'Are you sure you want to reset this lesson? All your progress will be lost.';

  @override
  String get resettingLesson => 'Resetting lesson...';

  @override
  String get errorResettingLesson => 'Error resetting lesson';

  @override
  String get playing => 'Playing...';

  @override
  String get hearPronunciation => 'Hear Pronunciation';

  @override
  String get close => 'Close';

  @override
  String get showHint => 'Show Hint';

  @override
  String get hint => 'Hint';

  @override
  String get createAccount => 'Create Account';

  @override
  String get startLanguageLearningJourneyToday =>
      'Start your language learning journey today';

  @override
  String get createPassword => 'Create a password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get reEnterPassword => 'Re-enter your password';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get signupFailed =>
      'Signup failed. Please check your information and try again.';

  @override
  String get yourProgress => 'Your Progress';

  @override
  String get trackYourLearningJourney => 'Track your learning journey';

  @override
  String get wordsLearned => 'Words Learned';

  @override
  String get masteryProgress => 'Mastery Progress';

  @override
  String get wordMastery => 'Word Mastery';

  @override
  String get mastered => 'Mastered';

  @override
  String get masteryIntermediate => 'Intermediate';

  @override
  String get novice => 'Novice';

  @override
  String get lessonsProgress => 'Lessons Progress';

  @override
  String get noProgressYet => 'No Progress Yet';

  @override
  String get startLearningToSeeProgress =>
      'Start learning to see your progress here!\nComplete lessons or play games to track your achievements.';

  @override
  String get startLearning => 'Start Learning';

  @override
  String get errorLoadingProgress => 'Error loading progress';

  @override
  String get languages => 'Languages';

  @override
  String get yourLanguages => 'Your Languages';

  @override
  String get availableLanguages => 'Available Languages';

  @override
  String get noLanguagesYet => 'No languages yet';

  @override
  String get addLanguageToGetStarted => 'Add a language to get started';

  @override
  String get words => 'words';

  @override
  String get lessonsLowercase => 'lessons';

  @override
  String addedLanguageToYourLanguages(String languageName) {
    return 'Added $languageName to your languages';
  }

  @override
  String get languageSwitched => 'Language switched';

  @override
  String get errorLoadingLanguages => 'Error loading languages';

  @override
  String get errorAddingLanguage => 'Error adding language';

  @override
  String get errorSwitchingLanguage => 'Error switching language';

  @override
  String get skip => 'Skip';

  @override
  String get skipPronunciation => 'Skip Pronunciation';

  @override
  String get skipPronunciationMessage =>
      'Skip pronunciation exercises for 1 hour? You can continue with the rest of the lesson.';

  @override
  String get pronunciationSkipped =>
      'Pronunciation exercises skipped for 1 hour';

  @override
  String get pronunciationSkippedMessage =>
      'Pronunciation exercises are currently skipped. You can continue with the rest of the lesson.';
}
