import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'LingoLogic'**
  String get appTitle;

  /// Welcome message on login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// Subtitle on login screen
  ///
  /// In en, this message translates to:
  /// **'Continue your language learning journey'**
  String get continueLanguageJourney;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Email field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Divider text between login options
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Anonymous login button
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// Sign up prompt
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// Sign up button/link
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Login error message
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials and try again.'**
  String get loginFailed;

  /// Anonymous login error message
  ///
  /// In en, this message translates to:
  /// **'Anonymous login failed. Please try again.'**
  String get anonymousLoginFailed;

  /// Email validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// Email format validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// Password validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// Password length validation error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Lessons tab label
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// Games tab label
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// Progress label
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Settings screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Manage your preferences'**
  String get managePreferences;

  /// Account section title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Guest account label
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guestUser;

  /// Anonymous account type label
  ///
  /// In en, this message translates to:
  /// **'Anonymous Account'**
  String get anonymousAccount;

  /// Registered account type label
  ///
  /// In en, this message translates to:
  /// **'Registered Account'**
  String get registeredAccount;

  /// App language section title
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// Language selection label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language picker dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Language change success message
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully!'**
  String get languageChangedSuccessfully;

  /// Audio settings section title
  ///
  /// In en, this message translates to:
  /// **'Audio Settings'**
  String get audioSettings;

  /// Volume control label
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// Notifications section title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notifications toggle label
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// Sync status section title
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get syncStatus;

  /// Offline status label
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// Online status label
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// Offline status description
  ///
  /// In en, this message translates to:
  /// **'Data will sync when online'**
  String get dataWillSyncWhenOnline;

  /// Online status description
  ///
  /// In en, this message translates to:
  /// **'All data synced'**
  String get allDataSynced;

  /// Sync button text
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// Sync in progress text
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Terms of service link
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// View link text
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// Sign out button text
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Sign out confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get areYouSureSignOut;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Games screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Practice with interactive games'**
  String get practiceWithGames;

  /// Games locked message title
  ///
  /// In en, this message translates to:
  /// **'Games Locked'**
  String get gamesLocked;

  /// Games locked message
  ///
  /// In en, this message translates to:
  /// **'Complete your first lesson to unlock games and practice what you\'ve learned!'**
  String get completeFirstLessonToUnlock;

  /// Message shown when user tries to access locked lesson
  ///
  /// In en, this message translates to:
  /// **'Complete the mini game to unlock more lessons!'**
  String get completeMiniGameToContinue;

  /// Button to navigate to lessons
  ///
  /// In en, this message translates to:
  /// **'Go to Lessons'**
  String get goToLessons;

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Game label
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get game;

  /// Next mini game label
  ///
  /// In en, this message translates to:
  /// **'Next Mini Game'**
  String get nextMiniGame;

  /// Mini game description
  ///
  /// In en, this message translates to:
  /// **'Review vocabulary from your recent lessons!'**
  String get reviewVocabularyMiniGame;

  /// Neuro-Match game title
  ///
  /// In en, this message translates to:
  /// **'Neuro-Match'**
  String get neuroMatch;

  /// Neuro-Match game description
  ///
  /// In en, this message translates to:
  /// **'Fast-paced word matching game'**
  String get fastPacedWordMatching;

  /// Syntax Constructor game title
  ///
  /// In en, this message translates to:
  /// **'Syntax Constructor'**
  String get syntaxConstructor;

  /// Syntax Constructor game description
  ///
  /// In en, this message translates to:
  /// **'Build sentences with drag & drop'**
  String get buildSentencesWithDragDrop;

  /// Morning greeting
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// Afternoon greeting
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// Evening greeting
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// Home tab main question
  ///
  /// In en, this message translates to:
  /// **'Ready to learn?'**
  String get readyToLearn;

  /// Current level label
  ///
  /// In en, this message translates to:
  /// **'Current Level'**
  String get currentLevel;

  /// A1 level description
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// A2 level description
  ///
  /// In en, this message translates to:
  /// **'Elementary'**
  String get elementary;

  /// B1 level description
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// B2 level description
  ///
  /// In en, this message translates to:
  /// **'Upper Intermediate'**
  String get upperIntermediate;

  /// C1 level description
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// C2 level description
  ///
  /// In en, this message translates to:
  /// **'Proficient'**
  String get proficient;

  /// Default level description
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get learning;

  /// Day streak label
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreak;

  /// Next lesson label
  ///
  /// In en, this message translates to:
  /// **'Next Lesson'**
  String get nextLesson;

  /// Start button text
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Progress overview section title
  ///
  /// In en, this message translates to:
  /// **'Progress Overview'**
  String get progressOverview;

  /// Completed lessons label
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// In progress lessons label
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// Total time label
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// Minutes abbreviation
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// Lessons screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Master grammar and vocabulary'**
  String get masterGrammarVocabulary;

  /// Available lessons label
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Categories section title
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// All categories filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Empty lessons list message
  ///
  /// In en, this message translates to:
  /// **'No lessons available'**
  String get noLessonsAvailable;

  /// Error message when loading lessons fails
  ///
  /// In en, this message translates to:
  /// **'Error loading lessons'**
  String get errorLoadingLessons;

  /// Error message when launching knowledge test fails
  ///
  /// In en, this message translates to:
  /// **'Error launching knowledge test'**
  String get errorLaunchingKnowledgeTest;

  /// Message when mini game has no words
  ///
  /// In en, this message translates to:
  /// **'No words available for this mini game yet.'**
  String get noWordsAvailableForMiniGame;

  /// Error message when launching mini game fails
  ///
  /// In en, this message translates to:
  /// **'Error launching mini game'**
  String get errorLaunchingMiniGame;

  /// Lesson completed status
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Active language badge label
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Lesson not started status
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newLesson;

  /// Label for locked lessons
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// Singular lesson
  ///
  /// In en, this message translates to:
  /// **'lesson'**
  String get lesson;

  /// Plural lessons
  ///
  /// In en, this message translates to:
  /// **'lessons'**
  String get lessonsPlural;

  /// Completion status (as in X% complete)
  ///
  /// In en, this message translates to:
  /// **'complete'**
  String get complete;

  /// Mixed level description
  ///
  /// In en, this message translates to:
  /// **'Mixed Level'**
  String get mixedLevel;

  /// Error message when lesson cannot be found
  ///
  /// In en, this message translates to:
  /// **'Lesson not found'**
  String get lessonNotFound;

  /// Error message when loading lesson fails
  ///
  /// In en, this message translates to:
  /// **'Error loading lesson'**
  String get errorLoadingLesson;

  /// Lesson completion screen title
  ///
  /// In en, this message translates to:
  /// **'Lesson Complete!'**
  String get lessonComplete;

  /// Lesson completion message
  ///
  /// In en, this message translates to:
  /// **'Great job! You\'ve completed \"{title}\"'**
  String greatJobCompletedLesson(String title);

  /// Message shown when new content is unlocked
  ///
  /// In en, this message translates to:
  /// **'New content unlocked!'**
  String get newContentUnlocked;

  /// Error message when completing lesson fails
  ///
  /// In en, this message translates to:
  /// **'Error completing lesson'**
  String get errorCompletingLesson;

  /// Loading state message for lesson
  ///
  /// In en, this message translates to:
  /// **'Loading lesson...'**
  String get loadingLesson;

  /// Go back button text
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Learn section type badge
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learn;

  /// Example section type badge
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get example;

  /// Practice section type badge
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// Previous button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Complete lesson button text
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get completeButton;

  /// Error message when no language is selected in onboarding
  ///
  /// In en, this message translates to:
  /// **'Please select a language to continue'**
  String get pleaseSelectLanguageToContinue;

  /// Error message when language setup fails
  ///
  /// In en, this message translates to:
  /// **'Error setting up your language'**
  String get errorSettingUpLanguage;

  /// Welcome message in onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nLingoLogic! 🌍'**
  String get welcomeToLingologic;

  /// Instructions in language onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Choose your first language to start learning'**
  String get chooseFirstLanguageToStart;

  /// Information message about adding languages later
  ///
  /// In en, this message translates to:
  /// **'You can add more languages anytime'**
  String get canAddMoreLanguagesAnytime;

  /// Continue button in onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get continueLearning;

  /// Message when no languages are available in onboarding
  ///
  /// In en, this message translates to:
  /// **'No languages available'**
  String get noLanguagesAvailable;

  /// Error message asking user to contact support
  ///
  /// In en, this message translates to:
  /// **'Please contact support if you see this message'**
  String get contactSupportIfSeeThis;

  /// Dialog title when exiting lesson
  ///
  /// In en, this message translates to:
  /// **'Exit Lesson'**
  String get exitLesson;

  /// Dialog message when exiting lesson
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get exitLessonMessage;

  /// Reset button text to restart lesson
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Save progress and close button text
  ///
  /// In en, this message translates to:
  /// **'Save and Close'**
  String get saveAndClose;

  /// Confirmation message when resetting lesson
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset this lesson? All your progress will be lost.'**
  String get resetLessonConfirmation;

  /// Loading message when resetting lesson
  ///
  /// In en, this message translates to:
  /// **'Resetting lesson...'**
  String get resettingLesson;

  /// Error message when resetting lesson fails
  ///
  /// In en, this message translates to:
  /// **'Error resetting lesson'**
  String get errorResettingLesson;

  /// Label shown when audio is playing
  ///
  /// In en, this message translates to:
  /// **'Playing...'**
  String get playing;

  /// Button text to play word pronunciation
  ///
  /// In en, this message translates to:
  /// **'Hear Pronunciation'**
  String get hearPronunciation;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Button text to show a hint for the exercise
  ///
  /// In en, this message translates to:
  /// **'Show Hint'**
  String get showHint;

  /// Hint label
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get hint;

  /// Sign up screen title and button text
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Sign up screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Start your language learning journey today'**
  String get startLanguageLearningJourneyToday;

  /// Password field hint on signup screen
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createPassword;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Confirm password field hint
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get reEnterPassword;

  /// Confirm password validation error
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// Password mismatch validation error
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Login prompt on signup screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// Signup error message
  ///
  /// In en, this message translates to:
  /// **'Signup failed. Please check your information and try again.'**
  String get signupFailed;

  /// Progress screen title
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// Progress screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Track your learning journey'**
  String get trackYourLearningJourney;

  /// Words learned label in progress screen
  ///
  /// In en, this message translates to:
  /// **'Words Learned'**
  String get wordsLearned;

  /// Mastery progress label
  ///
  /// In en, this message translates to:
  /// **'Mastery Progress'**
  String get masteryProgress;

  /// Word mastery section title
  ///
  /// In en, this message translates to:
  /// **'Word Mastery'**
  String get wordMastery;

  /// Mastered mastery level label
  ///
  /// In en, this message translates to:
  /// **'Mastered'**
  String get mastered;

  /// Intermediate mastery level label (different from CEFR level)
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get masteryIntermediate;

  /// Novice mastery level label
  ///
  /// In en, this message translates to:
  /// **'Novice'**
  String get novice;

  /// Lessons progress section title
  ///
  /// In en, this message translates to:
  /// **'Lessons Progress'**
  String get lessonsProgress;

  /// Empty progress state title
  ///
  /// In en, this message translates to:
  /// **'No Progress Yet'**
  String get noProgressYet;

  /// Empty progress state message
  ///
  /// In en, this message translates to:
  /// **'Start learning to see your progress here!\nComplete lessons or play games to track your achievements.'**
  String get startLearningToSeeProgress;

  /// Start learning button text
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLearning;

  /// Error message when loading progress fails
  ///
  /// In en, this message translates to:
  /// **'Error loading progress'**
  String get errorLoadingProgress;

  /// Languages screen title
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// Your languages section title
  ///
  /// In en, this message translates to:
  /// **'Your Languages'**
  String get yourLanguages;

  /// Available languages section title
  ///
  /// In en, this message translates to:
  /// **'Available Languages'**
  String get availableLanguages;

  /// Empty languages state title
  ///
  /// In en, this message translates to:
  /// **'No languages yet'**
  String get noLanguagesYet;

  /// Empty languages state message
  ///
  /// In en, this message translates to:
  /// **'Add a language to get started'**
  String get addLanguageToGetStarted;

  /// Words label (plural, for stat chips)
  ///
  /// In en, this message translates to:
  /// **'words'**
  String get words;

  /// Lessons label (plural, lowercase, for stat chips)
  ///
  /// In en, this message translates to:
  /// **'lessons'**
  String get lessonsLowercase;

  /// Success message when language is added
  ///
  /// In en, this message translates to:
  /// **'Added {languageName} to your languages'**
  String addedLanguageToYourLanguages(String languageName);

  /// Success message when language is switched
  ///
  /// In en, this message translates to:
  /// **'Language switched'**
  String get languageSwitched;

  /// Error message when loading languages fails
  ///
  /// In en, this message translates to:
  /// **'Error loading languages'**
  String get errorLoadingLanguages;

  /// Error message when adding language fails
  ///
  /// In en, this message translates to:
  /// **'Error adding language'**
  String get errorAddingLanguage;

  /// Error message when switching language fails
  ///
  /// In en, this message translates to:
  /// **'Error switching language'**
  String get errorSwitchingLanguage;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Skip pronunciation dialog title
  ///
  /// In en, this message translates to:
  /// **'Skip Pronunciation'**
  String get skipPronunciation;

  /// Skip pronunciation confirmation message
  ///
  /// In en, this message translates to:
  /// **'Skip pronunciation exercises for 1 hour? You can continue with the rest of the lesson.'**
  String get skipPronunciationMessage;

  /// Success message when pronunciation is skipped
  ///
  /// In en, this message translates to:
  /// **'Pronunciation exercises skipped for 1 hour'**
  String get pronunciationSkipped;

  /// Message shown when pronunciation exercises are skipped in a lesson
  ///
  /// In en, this message translates to:
  /// **'Pronunciation exercises are currently skipped. You can continue with the rest of the lesson.'**
  String get pronunciationSkippedMessage;

  /// Title for matching exercise section
  ///
  /// In en, this message translates to:
  /// **'Match the Words'**
  String get matchTheWords;

  /// Label shown when answer is correct
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// Label shown when answer is incorrect
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Button text to retry exercise with a different question
  ///
  /// In en, this message translates to:
  /// **'Retry with Different Question'**
  String get retryWithDifferentQuestion;

  /// Button text to submit an answer
  ///
  /// In en, this message translates to:
  /// **'Submit Answer'**
  String get submitAnswer;

  /// Hint text for matching exercise
  ///
  /// In en, this message translates to:
  /// **'Tap to match'**
  String get tapToMatch;

  /// Translation label
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translation;

  /// Instruction to select translation for a word
  ///
  /// In en, this message translates to:
  /// **'Select translation for {word}'**
  String selectTranslationFor(String word);

  /// Button text to clear a match
  ///
  /// In en, this message translates to:
  /// **'Clear Match'**
  String get clearMatch;

  /// Talk Tutor feature title
  ///
  /// In en, this message translates to:
  /// **'Talk Tutor'**
  String get talkTutor;

  /// Talk Tutor subtitle
  ///
  /// In en, this message translates to:
  /// **'Practice Speaking'**
  String get practiceSpeaking;

  /// Mic button label
  ///
  /// In en, this message translates to:
  /// **'Tap to speak'**
  String get tapToSpeak;

  /// Mic listening state
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get talkTutorListening;

  /// Permission required snackbar
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required for speaking practice.'**
  String get talkTutorMicRequired;

  /// Permission dialog title
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get talkTutorPermissionRequired;

  /// Permission dialog message
  ///
  /// In en, this message translates to:
  /// **'Microphone permission is required to practice speaking. Please enable it in your device settings.'**
  String get talkTutorPermissionMessage;

  /// Open app settings button
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Speech recognition unavailable message
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not available on this device.'**
  String get talkTutorSpeechUnavailable;

  /// API error message
  ///
  /// In en, this message translates to:
  /// **'Could not get tutor response. Please try again.'**
  String get talkTutorError;

  /// Conversation history section title
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get talkTutorConversation;

  /// Talk Tutor CTA card title on home
  ///
  /// In en, this message translates to:
  /// **'Speaking Practice'**
  String get speakingPractice;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
