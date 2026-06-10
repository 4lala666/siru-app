import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kk'),
    Locale('ru')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Siru Admin'**
  String get appTitle;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @modules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get modules;

  /// No description provided for @quizResults.
  ///
  /// In en, this message translates to:
  /// **'Quiz Results'**
  String get quizResults;

  /// No description provided for @wrongAnswers.
  ///
  /// In en, this message translates to:
  /// **'Wrong Answers'**
  String get wrongAnswers;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get russian;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @kazakh.
  ///
  /// In en, this message translates to:
  /// **'Қазақша'**
  String get kazakh;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @completedQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Completed Quizzes'**
  String get completedQuizzes;

  /// No description provided for @averageScore.
  ///
  /// In en, this message translates to:
  /// **'Average Score'**
  String get averageScore;

  /// No description provided for @totalWrongAnswers.
  ///
  /// In en, this message translates to:
  /// **'Total Wrong Answers'**
  String get totalWrongAnswers;

  /// No description provided for @activeUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get activeUsers;

  /// No description provided for @averageProgress.
  ///
  /// In en, this message translates to:
  /// **'Average Progress'**
  String get averageProgress;

  /// No description provided for @quizCompletionsByDay.
  ///
  /// In en, this message translates to:
  /// **'Quiz completions by day'**
  String get quizCompletionsByDay;

  /// No description provided for @averageScoreByModule.
  ///
  /// In en, this message translates to:
  /// **'Average score by module'**
  String get averageScoreByModule;

  /// No description provided for @mostDifficultModules.
  ///
  /// In en, this message translates to:
  /// **'Most difficult modules'**
  String get mostDifficultModules;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search user by name or email'**
  String get searchUsers;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @completedModules.
  ///
  /// In en, this message translates to:
  /// **'Completed Modules'**
  String get completedModules;

  /// No description provided for @lastActive.
  ///
  /// In en, this message translates to:
  /// **'Last Active'**
  String get lastActive;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @module.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get module;

  /// No description provided for @subtopics.
  ///
  /// In en, this message translates to:
  /// **'Subtopics'**
  String get subtopics;

  /// No description provided for @attempts.
  ///
  /// In en, this message translates to:
  /// **'Attempts'**
  String get attempts;

  /// No description provided for @wrongAnswersCol.
  ///
  /// In en, this message translates to:
  /// **'Wrong Answers'**
  String get wrongAnswersCol;

  /// No description provided for @completionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get completionRate;

  /// No description provided for @mostPopularModules.
  ///
  /// In en, this message translates to:
  /// **'Most popular modules'**
  String get mostPopularModules;

  /// No description provided for @bestAverageScore.
  ///
  /// In en, this message translates to:
  /// **'Best average score'**
  String get bestAverageScore;

  /// No description provided for @subtopic.
  ///
  /// In en, this message translates to:
  /// **'Subtopic'**
  String get subtopic;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @correctAnswers.
  ///
  /// In en, this message translates to:
  /// **'Correct Answers'**
  String get correctAnswers;

  /// No description provided for @totalQuestions.
  ///
  /// In en, this message translates to:
  /// **'Total Questions'**
  String get totalQuestions;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// No description provided for @completedAt.
  ///
  /// In en, this message translates to:
  /// **'Completed At'**
  String get completedAt;

  /// No description provided for @filterByModule.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get filterByModule;

  /// No description provided for @scoreRange.
  ///
  /// In en, this message translates to:
  /// **'Score range'**
  String get scoreRange;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get dateRange;

  /// No description provided for @quizHistory.
  ///
  /// In en, this message translates to:
  /// **'Quiz history'**
  String get quizHistory;

  /// No description provided for @questionId.
  ///
  /// In en, this message translates to:
  /// **'Question ID'**
  String get questionId;

  /// No description provided for @questionText.
  ///
  /// In en, this message translates to:
  /// **'Question Text'**
  String get questionText;

  /// No description provided for @wrongCount.
  ///
  /// In en, this message translates to:
  /// **'Wrong Count'**
  String get wrongCount;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct Answer'**
  String get correctAnswer;

  /// No description provided for @mostSelectedWrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Most Selected Wrong Answer'**
  String get mostSelectedWrongAnswer;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @top10DifficultQuestions.
  ///
  /// In en, this message translates to:
  /// **'Top 10 most difficult questions'**
  String get top10DifficultQuestions;

  /// No description provided for @activityByDay.
  ///
  /// In en, this message translates to:
  /// **'Activity by day'**
  String get activityByDay;

  /// No description provided for @activeUsersThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Active users this week'**
  String get activeUsersThisWeek;

  /// No description provided for @streakStats.
  ///
  /// In en, this message translates to:
  /// **'Streak statistics (avg daily active)'**
  String get streakStats;

  /// No description provided for @completedLessonsByDay.
  ///
  /// In en, this message translates to:
  /// **'Completed lessons by day'**
  String get completedLessonsByDay;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @adminProfile.
  ///
  /// In en, this message translates to:
  /// **'Admin profile'**
  String get adminProfile;

  /// No description provided for @dashboardSettings.
  ///
  /// In en, this message translates to:
  /// **'Dashboard settings'**
  String get dashboardSettings;

  /// No description provided for @dataSource.
  ///
  /// In en, this message translates to:
  /// **'Data source'**
  String get dataSource;

  /// No description provided for @mockRepository.
  ///
  /// In en, this message translates to:
  /// **'MockRepository'**
  String get mockRepository;

  /// No description provided for @firebaseStatus.
  ///
  /// In en, this message translates to:
  /// **'Firebase connection status'**
  String get firebaseStatus;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected yet'**
  String get notConnected;

  /// No description provided for @futureIntegration.
  ///
  /// In en, this message translates to:
  /// **'Future integration'**
  String get futureIntegration;

  /// No description provided for @firestoreRepo.
  ///
  /// In en, this message translates to:
  /// **'FirestoreAnalyticsRepository'**
  String get firestoreRepo;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @overviewLoaded.
  ///
  /// In en, this message translates to:
  /// **'Overview is visible'**
  String get overviewLoaded;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @modulesTab.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get modulesTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguageTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @min8.
  ///
  /// In en, this message translates to:
  /// **'minimum 8 characters'**
  String get min8;

  /// No description provided for @repeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get repeatPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @orLoginVia.
  ///
  /// In en, this message translates to:
  /// **'or log in with'**
  String get orLoginVia;

  /// No description provided for @orCreateVia.
  ///
  /// In en, this message translates to:
  /// **'or create account with'**
  String get orCreateVia;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account? Register'**
  String get noAccount;

  /// No description provided for @hasProfile.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get hasProfile;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordInvalid;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @resetPasswordDialogHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your account email and we will send reset instructions'**
  String get resetPasswordDialogHint;

  /// No description provided for @sendResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Send reset email'**
  String get sendResetEmail;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get passwordResetSent;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed'**
  String get passwordChanged;

  /// No description provided for @passwordChangedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed successfully'**
  String get passwordChangedSubtitle;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @resetHint.
  ///
  /// In en, this message translates to:
  /// **'Please create a new password'**
  String get resetHint;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @verifyMailTitle.
  ///
  /// In en, this message translates to:
  /// **'Please check your email'**
  String get verifyMailTitle;

  /// No description provided for @sentCode.
  ///
  /// In en, this message translates to:
  /// **'We sent a code to your email'**
  String get sentCode;

  /// No description provided for @wrongCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid code. Please try again.'**
  String get wrongCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @codeSent.
  ///
  /// In en, this message translates to:
  /// **'Code sent'**
  String get codeSent;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @checkYourEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkYourEmailTitle;

  /// No description provided for @checkYourEmailBody.
  ///
  /// In en, this message translates to:
  /// **'We sent a password reset email to {email}.'**
  String checkYourEmailBody(Object email);

  /// No description provided for @openResetLinkHint.
  ///
  /// In en, this message translates to:
  /// **'Open the link in the email to continue resetting your password in the app.'**
  String get openResetLinkHint;

  /// No description provided for @resendResetEmail.
  ///
  /// In en, this message translates to:
  /// **'Send email again'**
  String get resendResetEmail;

  /// No description provided for @checkingResetLink.
  ///
  /// In en, this message translates to:
  /// **'Checking reset link...'**
  String get checkingResetLink;

  /// No description provided for @invalidResetLink.
  ///
  /// In en, this message translates to:
  /// **'This password reset link is invalid or has expired.'**
  String get invalidResetLink;

  /// No description provided for @xpLabel.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get xpLabel;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get levelLabel;

  /// No description provided for @earnedBadges.
  ///
  /// In en, this message translates to:
  /// **'Earned badges'**
  String get earnedBadges;

  /// No description provided for @noBadgesYet.
  ///
  /// In en, this message translates to:
  /// **'No badges yet'**
  String get noBadgesYet;

  /// No description provided for @progressToNextLevel.
  ///
  /// In en, this message translates to:
  /// **'Progress to next level'**
  String get progressToNextLevel;

  /// No description provided for @badgesLabel.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badgesLabel;

  /// No description provided for @streakLabel.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streakLabel;

  /// No description provided for @xpEarnedMessage.
  ///
  /// In en, this message translates to:
  /// **'XP earned'**
  String get xpEarnedMessage;

  /// No description provided for @xpAlreadyEarnedMessage.
  ///
  /// In en, this message translates to:
  /// **'XP already earned'**
  String get xpAlreadyEarnedMessage;

  /// No description provided for @badgeFirstTestTitle.
  ///
  /// In en, this message translates to:
  /// **'First test'**
  String get badgeFirstTestTitle;

  /// No description provided for @badgeFirstTestDescription.
  ///
  /// In en, this message translates to:
  /// **'Awarded after completing your first quiz.'**
  String get badgeFirstTestDescription;

  /// No description provided for @badgeFirstSubtopicTitle.
  ///
  /// In en, this message translates to:
  /// **'First subtopic'**
  String get badgeFirstSubtopicTitle;

  /// No description provided for @badgeFirstSubtopicDescription.
  ///
  /// In en, this message translates to:
  /// **'Awarded after earning XP for the first subtopic.'**
  String get badgeFirstSubtopicDescription;

  /// No description provided for @badgeModuleMasterTitle.
  ///
  /// In en, this message translates to:
  /// **'Module master'**
  String get badgeModuleMasterTitle;

  /// No description provided for @badgeModuleMasterDescription.
  ///
  /// In en, this message translates to:
  /// **'Awarded for earning XP for every subtopic in one module.'**
  String get badgeModuleMasterDescription;

  /// No description provided for @badgeNoMistakeTitle.
  ///
  /// In en, this message translates to:
  /// **'No mistakes'**
  String get badgeNoMistakeTitle;

  /// No description provided for @badgeNoMistakeDescription.
  ///
  /// In en, this message translates to:
  /// **'Awarded for completing a quiz with a perfect score.'**
  String get badgeNoMistakeDescription;

  /// No description provided for @badgeStreak3Title.
  ///
  /// In en, this message translates to:
  /// **'3-day streak'**
  String get badgeStreak3Title;

  /// No description provided for @badgeStreak3Description.
  ///
  /// In en, this message translates to:
  /// **'Awarded for studying three days in a row.'**
  String get badgeStreak3Description;

  /// No description provided for @badgeStreak7Title.
  ///
  /// In en, this message translates to:
  /// **'7-day streak'**
  String get badgeStreak7Title;

  /// No description provided for @badgeStreak7Description.
  ///
  /// In en, this message translates to:
  /// **'Awarded for studying seven days in a row.'**
  String get badgeStreak7Description;

  /// No description provided for @badgeXp1000Title.
  ///
  /// In en, this message translates to:
  /// **'1000 XP'**
  String get badgeXp1000Title;

  /// No description provided for @badgeXp1000Description.
  ///
  /// In en, this message translates to:
  /// **'Awarded for reaching 1000 XP.'**
  String get badgeXp1000Description;

  /// No description provided for @badgeXp3000Title.
  ///
  /// In en, this message translates to:
  /// **'3000 XP'**
  String get badgeXp3000Title;

  /// No description provided for @badgeXp3000Description.
  ///
  /// In en, this message translates to:
  /// **'Awarded for reaching 3000 XP.'**
  String get badgeXp3000Description;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'kk': return AppLocalizationsKk();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
