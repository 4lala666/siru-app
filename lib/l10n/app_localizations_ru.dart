// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Siru Admin';

  @override
  String get overview => 'Обзор';

  @override
  String get users => 'Пользователи';

  @override
  String get modules => 'Модули';

  @override
  String get quizResults => 'Результаты тестов';

  @override
  String get wrongAnswers => 'Ошибки';

  @override
  String get activity => 'Активность';

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get russian => 'Русский';

  @override
  String get english => 'English';

  @override
  String get kazakh => 'Қазақша';

  @override
  String get notifications => 'Уведомления';

  @override
  String get admin => 'Админ';

  @override
  String get totalUsers => 'Всего пользователей';

  @override
  String get completedQuizzes => 'Пройдено тестов';

  @override
  String get averageScore => 'Средний балл';

  @override
  String get totalWrongAnswers => 'Всего ошибок';

  @override
  String get activeUsers => 'Активные пользователи';

  @override
  String get averageProgress => 'Средний прогресс';

  @override
  String get quizCompletionsByDay => 'Прохождения тестов по дням';

  @override
  String get averageScoreByModule => 'Средний балл по модулям';

  @override
  String get mostDifficultModules => 'Самые сложные модули';

  @override
  String get recentActivity => 'Недавняя активность';

  @override
  String get searchUsers => 'Поиск пользователей по имени или email';

  @override
  String get all => 'Все';

  @override
  String get active => 'Активен';

  @override
  String get inactive => 'Неактивен';

  @override
  String get user => 'Пользователь';

  @override
  String get email => 'Email';

  @override
  String get completedModules => 'Завершённые модули';

  @override
  String get lastActive => 'Последняя активность';

  @override
  String get status => 'Статус';

  @override
  String get module => 'Модуль';

  @override
  String get subtopics => 'Подтемы';

  @override
  String get attempts => 'Попытки';

  @override
  String get wrongAnswersCol => 'Ошибки';

  @override
  String get completionRate => 'Процент завершения';

  @override
  String get mostPopularModules => 'Самые популярные модули';

  @override
  String get bestAverageScore => 'Лучший средний результат';

  @override
  String get subtopic => 'Подтема';

  @override
  String get score => 'Балл';

  @override
  String get correctAnswers => 'Правильные ответы';

  @override
  String get totalQuestions => 'Всего вопросов';

  @override
  String get percentage => 'Процент';

  @override
  String get completedAt => 'Завершено';

  @override
  String get filterByModule => 'Модуль';

  @override
  String get scoreRange => 'Диапазон баллов';

  @override
  String get dateRange => 'Диапазон дат';

  @override
  String get quizHistory => 'История тестов';

  @override
  String get questionId => 'ID вопроса';

  @override
  String get questionText => 'Текст вопроса';

  @override
  String get wrongCount => 'Количество ошибок';

  @override
  String get correctAnswer => 'Правильный ответ';

  @override
  String get mostSelectedWrongAnswer => 'Самый частый неправильный ответ';

  @override
  String get difficulty => 'Сложность';

  @override
  String get top10DifficultQuestions => 'Топ-10 самых сложных вопросов';

  @override
  String get activityByDay => 'Активность по дням';

  @override
  String get activeUsersThisWeek => 'Активные пользователи за неделю';

  @override
  String get streakStats => 'Статистика streak (средняя дневная активность)';

  @override
  String get completedLessonsByDay => 'Завершённые уроки по дням';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get adminProfile => 'Профиль администратора';

  @override
  String get dashboardSettings => 'Настройки дашборда';

  @override
  String get dataSource => 'Источник данных';

  @override
  String get mockRepository => 'MockRepository';

  @override
  String get firebaseStatus => 'Статус подключения Firebase';

  @override
  String get notConnected => 'Пока не подключено';

  @override
  String get futureIntegration => 'Будущая интеграция';

  @override
  String get firestoreRepo => 'FirestoreAnalyticsRepository';

  @override
  String get loading => 'Загрузка...';

  @override
  String get overviewLoaded => 'Overview виден';

  @override
  String get difficultyEasy => 'Легко';

  @override
  String get difficultyMedium => 'Средне';

  @override
  String get difficultyHard => 'Сложно';

  @override
  String get homeTab => 'Главная';

  @override
  String get modulesTab => 'Модули';

  @override
  String get profileTab => 'Профиль';

  @override
  String get chooseLanguageTitle => 'Выберите язык';

  @override
  String get login => 'Войти';

  @override
  String get register => 'Регистрация';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get min8 => 'минимум 8 символов';

  @override
  String get repeatPassword => 'Повторите пароль';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get orLoginVia => 'или войти через';

  @override
  String get orCreateVia => 'или зарегистрироваться через';

  @override
  String get noAccount => 'Нет аккаунта? Зарегистрироваться';

  @override
  String get hasProfile => 'Уже есть профиль? Войти';

  @override
  String get emailInvalid => 'Введите корректный email';

  @override
  String get passwordInvalid => 'Пароль должен содержать минимум 8 символов';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get resetPassword => 'Сброс пароля';

  @override
  String get resetPasswordDialogHint => 'Введите email аккаунта, и мы отправим инструкции для сброса';

  @override
  String get sendResetEmail => 'Отправить письмо для сброса';

  @override
  String get passwordResetSent => 'Письмо для сброса отправлено';

  @override
  String get passwordChanged => 'Пароль изменен';

  @override
  String get passwordChangedSubtitle => 'Ваш пароль был успешно изменен';

  @override
  String get backToLogin => 'Вернуться ко входу';

  @override
  String get resetHint => 'Пожалуйста, создайте новый пароль';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get confirmNewPassword => 'Подтвердите новый пароль';

  @override
  String get verifyMailTitle => 'Пожалуйста, проверьте вашу почту';

  @override
  String get sentCode => 'Мы отправили код на вашу почту';

  @override
  String get wrongCode => 'Неверный код. Попробуйте снова.';

  @override
  String get verify => 'Подтвердить';

  @override
  String get codeSent => 'Код отправлен';

  @override
  String get resendCode => 'Отправить код еще раз';
}
