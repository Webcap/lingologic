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

  /// Lesson in progress status
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
