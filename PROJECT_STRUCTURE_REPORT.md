# PROJECT_STRUCTURE_REPORT.md

## 1. Общая информация о проекте
Siru — Flutter-приложение для микрообучения по кибербезопасности: пользователь проходит короткие подтемы (уроки), затем тест по конкретной подтеме, получает результат и накапливает прогресс/ошибки.

Проект построен как feature-oriented структура (`lib/features/*`) с роутингом через GoRouter и состоянием через Riverpod.

## 2. Используемые технологии
| Технология | Где используется | Назначение |
|---|---|---|
| Flutter (Dart) | весь проект | Кроссплатформенный UI (web/mobile/desktop) |
| flutter_riverpod | `main.dart`, `features/*`, `core/localization/*` | State management и реактивные провайдеры |
| go_router | `lib/app_router.dart` | Декларативная маршрутизация, shell-навигация |
| Firebase Core/Auth/Firestore | `main.dart`, `firebase_options.dart`, `features/auth/*`, `features/profile/profile_state.dart` | Инициализация Firebase, авторизация, профиль пользователя |
| SharedPreferences | onboarding, quiz attempts, language | Локальное хранение флагов/результатов |
| Assets JSON | `assets/data/*.json` | Контент модулей/вопросов/фактов |

## 3. Архитектура приложения
- Точка входа: `lib/main.dart`.
- В `main()` выполняется:
1. `WidgetsFlutterBinding.ensureInitialized()`.
2. `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`.
3. Запуск `ProviderScope` + `SiruApp`.
- `SiruApp` использует `MaterialApp.router` и `AppRouter.router`.
- Локализация берётся из Riverpod-провайдера языка.
- Навигация организована через GoRouter + `StatefulShellRoute.indexedStack` для нижней навигации.
- Разделение по feature-модулям: onboarding/auth/home/modules/quiz(profile mistakes)/profile и т.д.

## 4. Структура папок
| Папка/файл | Назначение | Что реализовано |
|---|---|---|
| `lib/main.dart` | запуск приложения | Firebase init, ProviderScope, MaterialApp.router |
| `lib/app_router.dart` | маршруты | все основные route + shell tabs |
| `lib/firebase_options.dart` | конфиг Firebase | web/android/ios/macos/windows |
| `lib/core/localization/*` | язык/locale | провайдеры языка и LocaleController |
| `lib/features/auth/*` | авторизация | email/pass, Google, Apple(iOS), reset/change password |
| `lib/features/language/*` | выбор языка | LanguageScreen + сохранение языка |
| `lib/features/welcome/*` | welcome | WelcomeScreen |
| `lib/features/survey/*` | опрос | SurveyScreen + завершение onboarding |
| `lib/features/onboarding/*` | первичный onboarding | OnboardingScreen |
| `lib/features/app_shell/*` | shell | нижняя навигация и каркас `/app/*` |
| `lib/features/home/*` | главный экран | header, quick actions, activity card, continue learning, fact/tip/progress |
| `lib/features/modules/*` | обучение | каталог модулей, детали модуля, экран урока |
| `lib/features/mistakes/*` | quiz/mistakes | модель вопросов, сервис ошибок, adaptive quiz |
| `lib/features/profile/*` | профиль | профиль, настройки, privacy/security, mistakes entry |
| `assets/data/modules.json` | контент обучения | 14 модулей и 108 подтем |
| `assets/data/questions.json` | банк тестов | 1080 вопросов (по 10 на подтему) |
| `assets/data/facts.json` | факты дня | контент фактов на Home |
| `assets/modules/card_1600x500/` | изображения карточек | card backgrounds модулей |
| `assets/modules/hero_1800x600/` | hero-изображения | hero backgrounds в деталях модулей |

## 5. Навигация
| Route | Экран | Назначение | Параметры |
|---|---|---|---|
| `/` | StartGate | решает куда вести: onboarding/auth/app | - |
| `/onboarding` | OnboardingScreen | стартовый onboarding splash | - |
| `/language` | LanguageScreen | выбор языка | - |
| `/welcome` | WelcomeScreen | приветственный экран | - |
| `/survey` | SurveyScreen | опрос перед входом | - |
| `/auth` | AuthScreen | вход/регистрация | - |
| `/auth/forgot` | ForgotPasswordScreen | восстановление пароля | - |
| `/auth/verify` | VerifyCodeScreen | шаг верификации | - |
| `/auth/reset` | ResetPasswordScreen | сброс пароля | - |
| `/auth/success` | PasswordChangedScreen | подтверждение смены | - |
| `/change-password` | ChangePasswordPage | смена пароля | - |
| `/privacy-security` | PrivacySecurityPage | раздел приватности | nested routes |
| `/module/:id` | ModuleDetailScreen | детали модуля | `id` |
| `/module-topic` | ModuleTopicPage | экран урока/подтемы | `extra: ModuleTopicArgs` |
| `/lesson-quiz/:moduleId/:lessonId` | LessonQuizScreen | тест по текущей подтеме | `moduleId`, `lessonId` |
| `/lesson-quiz/result` | ResultScreen | результат урокового теста | `extra` map |
| `/app/home` | HomeScreen | главная вкладка | - |
| `/app/modules` | ModulesCatalogView | список модулей | - |
| `/app/profile` | ProfileScreen | профиль | - |
| `/app/profile/mistakes` | WorkOnMistakesScreen | работа над ошибками | - |
| `/app/profile/mistakes/quiz` | QuestionScreen | quiz по ошибкам | `extra: List<QuizQuestion>` |
| `/app/profile/mistakes/result` | ResultScreen | результат quiz по ошибкам | `extra` map |

## 6. Onboarding flow
Реальный flow:
1. Первый запуск -> `/` (`StartGate`).
2. Если `onboarding_done != true` в SharedPreferences -> `/language`.
3. `LanguageScreen` -> `/welcome`.
4. `WelcomeScreen` -> `/survey`.
5. `SurveyScreen` ставит `onboarding_done=true` -> `/auth`.
6. Далее вход и переход в `/app/home`.

Статус: реализовано.

## 7. Auth flow
- Файлы: `features/auth/auth_screen.dart`, `auth_controller.dart`, `user_profile_service.dart`.
- Поддержано:
1. Email/password sign in/up.
2. Google sign-in.
3. Apple sign-in (только iOS).
4. Logout.
5. Forgot/reset/change password.
- При входе/регистрации создаётся/обновляется документ пользователя в Firestore (`users/{uid}`).

Статус: реализовано (часть экранов-потоков может быть упрощена UI-логикой).

## 8. Home Screen
Файл: `lib/features/home/home_screen.dart`.

Текущая структура (сверху вниз):
1. Header (`Hello, username`, подзаголовок, notifications icon).
2. Quick actions (3 действия).
3. Activity calendar card (`ActivityCalendarCard`).
4. Continue Learning.
5. Fact of the day.
6. Daily Cyber Tip.
7. Progress.

`Threat of the day` в роутере есть, но на Home не приоритетен/вынесен.

Activity/streak:
- Виджет: `lib/features/home/widgets/activity_calendar_card.dart`.
- Сейчас используется mock/placeholder-данные (`activeDates`, `streakCount`) без полноценного persistent streak-engine.

## 9. Модули обучения
Источник: `assets/data/modules.json` (+ чтение в `ModuleRepository`).

- Количество модулей: 14.
- Количество подтем (lessons): 108.
- Модель: `lib/features/modules/domain/module_models.dart`.
- Для изображений у модуля есть отдельные поля `cardImagePath` и `heroImagePath`.

| № | Модуль (id) | Подтем | Источник | Контент | Тесты | Изображения |
|---|---|---:|---|---|---|---|
| 1 | `gov_risk` | 8 | `assets/data/modules.json` | Да | Да | card+hero |
| 2 | `social_eng` | 8 | `assets/data/modules.json` | Да | Да | card+hero |
| 3 | `network_sec` | 8 | `assets/data/modules.json` | Да | Да | card+hero |
| 4 | `endpoint_mobile` | 8 | `assets/data/modules.json` | Да | Да | card+hero |
| 5 | `iam` | 8 | `assets/data/modules.json` | Да | Да | card+hero |
| 6 | `crypto` | 8 | `assets/data/modules.json` | Да | Да | card+hero |
| 7 | `data_privacy` | 8 | `assets/data/modules.json` | Да | Да | card+hero |
| 8 | `appsec_devsecops` | 8 | `assets/data/modules.json` | Да | Да | card+hero |
| 9 | `secops_ir` | 8 | `assets/data/modules.json` | Да | Да | card+hero |
| 10 | `cloud_sec` | 8 | `assets/data/modules.json` | Да | Да | card+hero |
| 11 | `offsec` | 8 | `assets/data/modules.json` | Да | Да | card+hero |
| 12 | `phys_forensics` | 8 | `assets/data/modules.json` | Да | Да | card+hero |
| 13 | `ai_llm_sec` | 8 | `assets/data/modules.json` | Да | Да | card+hero |
| 14 | `iot` | 4 | `assets/data/modules.json` | Да | Да | card+hero |

Примечание: экран каталога модулей — `ModulesCatalogView`, детали — `ModuleDetailScreen`, урок — `ModuleTopicPage`.

## 10. Микрообучение и уроки
- Экран урока: `lib/features/modules/presentation/module_topic_page.dart`.
- Контент урока формируется через `LessonContentBuilder`.
- Используются структурированные блоки: definition/importance/example/warning/checklist/comparison/remember/selfCheck.
- В конце урока подключён CTA теста (sticky button `StartQuizStickyButton`).
- Тест запускается только для текущей подтемы (`moduleId + lessonId`).

Статус: реализовано (есть признаки шаблонизации контента в `LessonContentBuilder`, не все уроки равномерно детализированы одинаково).

## 11. Тесты и Quiz logic
### Где хранятся вопросы
- `assets/data/questions.json`.
- Чтение: `MistakesService._loadQuestions()` через `rootBundle.loadString` + `jsonDecode`.

### Модель вопроса
Файл: `lib/features/mistakes/domain/mistake.dart` (`QuizQuestion`).

| Поле вопроса | Назначение |
|---|---|
| `questionId` | уникальный id вопроса |
| `moduleId` | привязка к модулю |
| `lessonId` | привязка к подтеме |
| `type` | тип (`multiple_choice`, `true_false`, `scenario`, и др.) |
| `difficulty` | сложность (`easy`, `medium`, `hard`) |
| `question` | текст вопроса |
| `options` | варианты ответа |
| `correctIndex` | индекс правильного ответа |
| `explanation` | объяснение |
| `hint` | подсказка |
| `source` | источник (не обязателен) |

### Логика показа/оценки
- Экран: `lib/features/modules/presentation/lesson_quiz_screen.dart`.
- Вопросы показываются по одному.
- Кнопки: `Далее`/`Завершить`.
- Результат: подсчёт correct/total, переход на `/lesson-quiz/result`.

### Сохранение результата
- `QuizAttemptStore` (`lib/features/modules/data/quiz_attempt_store.dart`).
- В `SharedPreferences` ключ `lesson_quiz_attempts_v1`.
- Сохраняются: `moduleId`, `subtopicId`, `score`, `totalQuestions`, `correctAnswers`, `wrongQuestionIds`, `selectedAnswers`, `completedAt`.

### Количественный статус вопросов
Проверка JSON показала:
- Всего вопросов: 1080.
- Подтем: 108.
- Для каждой подтемы ровно 10 вопросов.
- Непокрытых подтем: 0.

## 12. Работа над ошибками
- Экран: `lib/features/mistakes/presentation/work_on_mistakes_screen.dart`.
- Сервис: `lib/features/mistakes/data/mistakes_service.dart`.
- При ошибке в LessonQuiz вызывается `addMistake(...)`.
- Хранятся: `questionId`, `moduleId`, `lessonId`, `difficulty`, `wrongCount`, `lastWrongAt`.
- Есть генерация adaptive набора до 10 вопросов из ошибочных/связанных.

Статус: интерфейс и базовая логика реализованы; долговременное хранилище ошибок (между перезапусками) в текущем виде ограничено (state notifier в памяти + seed).

## 13. Профиль и настройки
- Экран: `lib/features/profile/presentation/profile_screen.dart`.
- Разделы: summary, cyber stats, badges, settings.
- Настройки включают:
1. Язык.
2. Privacy & Security (`/privacy-security`).
3. Work on mistakes.
4. Logout.

Статус: реализовано, часть данных профиля демонстрационная (примерные stats/badges).

## 14. Privacy & Security
Файлы:
- `privacy_security_page.dart`
- `privacy_security/manage_email_page.dart`
- `privacy_security/two_factor_page.dart`
- `privacy_security/active_sessions_page.dart`
- `privacy_security/login_history_page.dart`
- `privacy_security/data_usage_page.dart`
- `privacy_security/delete_account_page.dart`

Статус: UI и маршруты реализованы; часть действий имеет безопасный stub/демо-характер (без полноценной серверной оркестрации).

## 15. Хранение данных
| Данные | Где хранятся | Назначение |
|---|---|---|
| `onboarding_done` | SharedPreferences | определяет прохождение onboarding |
| выбранный язык | SharedPreferences + Riverpod | локализация UI |
| модули/уроки | `assets/data/modules.json` | контент микрообучения |
| quiz-вопросы | `assets/data/questions.json` | тесты по подтемам |
| факты дня | `assets/data/facts.json` | контент Home |
| quiz attempts | SharedPreferences (`lesson_quiz_attempts_v1`) | история прохождения тестов |
| профиль пользователя | Firestore `users/{uid}` | displayName, email, metadata |
| auth-сессия | Firebase Auth | авторизация |
| mistakes runtime state | Riverpod `mistakesServiceProvider` | работа над ошибками |

## 16. Firebase
- Конфиг: `lib/firebase_options.dart`.
- Подключённые платформы: web/android/ios/macos/windows (linux не сконфигурирован).
- Firebase Auth используется активно.
- Firestore используется для пользовательского профиля.

Статус: подключено и используется.

## 17. Assets и изображения
- Объявлены в `pubspec.yaml`:
1. `assets/modules/card_1600x500/`
2. `assets/modules/hero_1800x600/`
3. data json assets.
- `card_*` используется в карточках списка модулей.
- `hero_*` используется в hero-блоке экрана деталей модуля.
- В наборах есть смешение форматов PNG/WebP — в путях используются реальные расширения.
- Для hero применяется `BoxFit.cover` (сохранение пропорций) + градиентный overlay для читаемости текста.

## 18. Providers / State management
| Provider | Назначение | Где используется |
|---|---|---|
| `authControllerProvider` | auth state + auth actions | `features/auth/*`, profile logout |
| `modulesProvider` | загрузка модулей из JSON | modules catalog/detail |
| `moduleRepositoryProvider` | DI репозитория модулей | modules provider |
| `mistakesServiceProvider` | ошибки + выдача quiz-вопросов | lesson quiz, work on mistakes |
| `quizAttemptStoreProvider` | сохранение результатов quiz | lesson quiz |
| `languageProvider` | код языка (ru/en/kk) | language screen, app locale |
| `localeControllerProvider` | Locale для MaterialApp | `main.dart` |
| `factOfTheDayProvider` | факт дня | home |
| `profileNameProvider`/`profileAvatarProvider` | состояние профиля | profile |
| `effectiveProfileNameProvider` | вычисление имени | profile/home |
| `profileBootstrapProvider` | загрузка профиля из Firestore | profile |

## 19. Что реализовано
| Функция | Статус | Комментарий |
|---|---|---|
| Onboarding | Готово | язык/welcome/survey + флаг завершения |
| Language selection | Готово | через provider + prefs |
| Auth | Готово | email/google/apple + password flows |
| Home | Частично | функционально есть; streak/activity пока mock |
| Modules list/detail | Готово | каталог, детали, hero/card images |
| Lessons (microlearning) | Готово | структурные блоки урока, CTA теста |
| Quiz per subtopic | Готово | 10 вопросов, по одному, result |
| Quiz result persistence | Готово | SharedPreferences attempts |
| Work on mistakes | Частично | есть UI+алгоритм, долговременная история ограничена |
| Profile | Готово | экран и настройки |
| Privacy/Security pages | Частично | UI готов, часть действий заглушки |
| Progress/streak | Частично | progress UI есть, streak полноценный расчёт не завершён |

## 20. Что требует доработки
1. В данных контента/вопросов заметны проблемы кодировки (моджибейк в русских строках в ряде файлов/JSON).
2. В `LessonQuizScreen` часть русских UI-строк отображается в повреждённом виде в исходнике.
3. Streak/activity на Home сейчас placeholder/mocked, нужно связать с реальными учебными событиями.
4. Work on mistakes желательно сохранить в постоянное хранилище, а не только runtime state.
5. Некоторые страницы privacy/security реализованы как UI-first и требуют backend-логики для production.

## 21. Как рассказать это на защите
1. Начать с цели: микрообучение по ИБ + тест сразу после каждого урока.
2. Показать архитектуру: Flutter + Riverpod + GoRouter + Firebase.
3. Объяснить onboarding/auth и переход к shell-навигации.
4. Показать модульную структуру данных (`modules.json`) и связь с UI.
5. Отдельно объяснить quiz-модель и привязку `moduleId + lessonId`.
6. Показать сохранение результатов и блок "работа над ошибками".
7. Указать текущие ограничения (streak mock, кодировка контента, часть privacy как заглушка) как план развития.

## Краткий текст для защиты
Приложение Siru — это обучающая платформа по кибербезопасности в формате микрообучения. Технически проект реализован на Flutter, поэтому один код работает на web и мобильных платформах. В качестве архитектурной основы используется feature-подход: отдельные модули для onboarding, авторизации, главного экрана, обучения, тестов и профиля. Состояние управляется через Riverpod, а навигация построена на GoRouter с shell-структурой для нижних вкладок.

Пользовательский путь начинается с первого запуска: выбор языка, welcome и короткий survey. После этого сохраняется флаг onboarding в SharedPreferences, и пользователь переходит к авторизации через Firebase Authentication. После входа открывается основной интерфейс с Home-экраном и вкладками модулей и профиля.

Учебный контент хранится в JSON-данных и состоит из модулей и подтем. Для каждого модуля есть карточка и hero-изображение, что разделяет превью и детальный экран. Внутри подтемы пользователь проходит короткие блоки материала: определения, ключевые факты, примеры и чеклисты. После завершения подтемы запускается тест именно по этой подтеме, а не по всему модулю.

Тестовая система поддерживает типы вопросов multiple choice, true/false и scenario. Вопросы связаны с конкретными `moduleId` и `lessonId`, показываются по одному, после чего считается результат. Итоги прохождения сохраняются локально: балл, количество правильных ответов, выбранные варианты и список ошибок. Эти ошибки используются в отдельном блоке "работа над ошибками", где формируется повторный адаптивный тест.

Таким образом, выбранная архитектура даёт понятное разделение ответственности, быстрое развитие по feature-модулям и готовую основу для дальнейшего усиления аналитики прогресса, streak-логики и production-функций профиля и privacy.
