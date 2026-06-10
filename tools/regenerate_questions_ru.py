import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MODULES_PATH = ROOT / "assets/data/modules.json"
QUESTIONS_PATH = ROOT / "assets/data/questions.json"
LOCALES = ("ru", "en", "kk")


def clean(text: str) -> str:
    text = str(text or "").replace("\uFFFD", "").strip()
    text = re.sub(r"\s+", " ", text)
    return text


def demojibake(text: str) -> str:
    s = str(text or "")
    if "Р " in s or "РЎ" in s:
        try:
            fixed = s.encode("latin1", errors="ignore").decode("utf-8", errors="ignore")
            fixed = fixed.replace("\uFFFD", "")
            if fixed:
                s = fixed
        except Exception:
            pass
    return clean(s)


def tr(obj: dict, key: str, locale: str) -> str:
    val = obj.get(key, {})
    if isinstance(val, dict):
        return demojibake(
            val.get(locale)
            or val.get("ru")
            or val.get("en")
            or val.get("kk")
            or ""
        )
    return ""


def tr_list(obj: dict, key: str, locale: str) -> list[str]:
    val = obj.get(key, {})
    if not isinstance(val, dict):
        return []
    arr = val.get(locale) or val.get("ru") or val.get("en") or val.get("kk") or []
    if not isinstance(arr, list):
        return []
    return [demojibake(x) for x in arr if clean(x)]


def crop(text: str, n: int = 140) -> str:
    t = clean(text)
    return t if len(t) <= n else t[: n - 1].rstrip() + "…"


def localized(ru: str, en: str, kk: str) -> dict[str, str]:
    return {
        "ru": clean(ru),
        "en": clean(en),
        "kk": clean(kk),
    }


def localized_list(ru: list[str], en: list[str], kk: list[str]) -> dict[str, list[str]]:
    return {
        "ru": [clean(x) for x in ru],
        "en": [clean(x) for x in en],
        "kk": [clean(x) for x in kk],
    }


def qobj(
    qid: str,
    module_id: str,
    lesson_id: str,
    qtype: str,
    difficulty: str,
    question: dict[str, str],
    options: dict[str, list[str]],
    correct: int,
    explanation: dict[str, str],
    hint: str,
) -> dict:
    return {
        "questionId": qid,
        "moduleId": module_id,
        "lessonId": lesson_id,
        "type": qtype,
        "difficulty": difficulty,
        "question": question,
        "options": options,
        "correctIndex": correct,
        "correctAnswer": correct,
        "explanation": explanation,
        "hint": clean(hint),
    }


def build_base_items(lesson: dict) -> list[dict[str, str]]:
    items: list[dict[str, str]] = []

    summary = {locale: tr(lesson, "summary", locale) for locale in LOCALES}
    if summary["ru"]:
        items.append(summary)

    for key in ("whatYouWillLearn", "keyFacts", "examples"):
        localized_lists = {locale: tr_list(lesson, key, locale) for locale in LOCALES}
        max_len = max((len(values) for values in localized_lists.values()), default=0)
        for index in range(max_len):
            item = {
                locale: clean(
                    localized_lists[locale][index]
                    if index < len(localized_lists[locale])
                    else localized_lists["ru"][index]
                    if index < len(localized_lists["ru"])
                    else ""
                )
                for locale in LOCALES
            }
            if item["ru"]:
                items.append(item)

    deduped: list[dict[str, str]] = []
    seen_ru: set[str] = set()
    for item in items:
        if item["ru"] and item["ru"] not in seen_ru:
            deduped.append(item)
            seen_ru.add(item["ru"])

    filler = localized(
        "Следовать безопасной процедуре и снижать риск.",
        "Follow a safe procedure and reduce risk.",
        "Қауіпсіз рәсімді сақтап, тәуекелді азайту.",
    )

    while len(deduped) < 6:
        deduped.append(filler)

    return [{locale: crop(item[locale]) for locale in LOCALES} for item in deduped[:6]]


def make_questions(mi: int, si: int, module: dict, lesson: dict) -> list[dict]:
    module_id = module["id"]
    lesson_id = lesson["id"]
    title = {locale: tr(lesson, "title", locale) or lesson_id for locale in LOCALES}
    base = build_base_items(lesson)
    b1, b2, b3, b4, b5, b6 = base

    return [
        qobj(
            f"m{mi:02d}_s{si:02d}_q01",
            module_id,
            lesson_id,
            "multiple_choice",
            "easy",
            localized(
                f"Как лучше всего описать ключевую идею подтемы «{title['ru']}»?",
                f"Which option best describes the key idea of the subtopic “{title['en']}”?",
                f"«{title['kk']}» ішкі тақырыбының негізгі идеясын қай нұсқа жақсы сипаттайды?",
            ),
            localized_list(
                [
                    b1["ru"],
                    "Быстро выполнить действие без проверки.",
                    "Игнорировать риск ради удобства.",
                    "Отключить защиту для ускорения.",
                ],
                [
                    b1["en"],
                    "Perform an action quickly without verification.",
                    "Ignore risk for convenience.",
                    "Disable protection to speed things up.",
                ],
                [
                    b1["kk"],
                    "Тексерусіз әрекетті жылдам орындау.",
                    "Ыңғай үшін тәуекелді елемеу.",
                    "Жылдамдату үшін қорғауды өшіру.",
                ],
            ),
            0,
            localized(
                f"Ключевая идея подтемы отражена в материале: {b1['ru']}",
                f"The key idea of the subtopic is reflected in the material: {b1['en']}",
                f"Ішкі тақырыптың негізгі идеясы материалда көрсетілген: {b1['kk']}",
            ),
            "Вспомните основную мысль урока.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q02",
            module_id,
            lesson_id,
            "true_false",
            "easy",
            localized(
                f"Верно ли, что в подтеме «{title['ru']}» важны проверка контекста и безопасные действия?",
                f"Is it true that the subtopic “{title['en']}” emphasizes checking context and safe actions?",
                f"«{title['kk']}» ішкі тақырыбында контексті тексеру мен қауіпсіз әрекет маңызды деген дұрыс па?",
            ),
            localized_list(
                ["Верно", "Неверно"],
                ["True", "False"],
                ["Дұрыс", "Бұрыс"],
            ),
            0,
            localized(
                "Верно. Подтема учит снижать риск за счет проверки и корректных действий.",
                "True. The subtopic teaches reducing risk through verification and correct actions.",
                "Дұрыс. Ішкі тақырып тексеру мен дұрыс әрекеттер арқылы тәуекелді азайтуды үйретеді.",
            ),
            "Ориентируйтесь на практический вывод урока.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q03",
            module_id,
            lesson_id,
            "multiple_choice",
            "easy",
            localized(
                "Какой тезис относится к содержанию этой подтемы?",
                "Which statement belongs to this subtopic?",
                "Бұл ішкі тақырыптың мазмұнына қай тұжырым сәйкес келеді?",
            ),
            localized_list(
                [
                    b2["ru"],
                    "Как обойти контроль безопасности.",
                    "Как скрыть следы нарушения.",
                    "Как отключить уведомления защиты.",
                ],
                [
                    b2["en"],
                    "How to bypass security controls.",
                    "How to hide traces of a violation.",
                    "How to disable protection alerts.",
                ],
                [
                    b2["kk"],
                    "Қауіпсіздік бақылауын қалай айналып өтуге болады.",
                    "Бұзушылық іздерін қалай жасыруға болады.",
                    "Қорғау хабарламаларын қалай өшіруге болады.",
                ],
            ),
            0,
            localized(
                f"Этот тезис взят из учебного материала подтемы: {b2['ru']}",
                f"This statement comes directly from the subtopic learning material: {b2['en']}",
                f"Бұл тұжырым ішкі тақырыптың оқу материалынан алынған: {b2['kk']}",
            ),
            "Сопоставьте вариант с тем, что разбиралось в уроке.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q04",
            module_id,
            lesson_id,
            "multiple_choice",
            "easy",
            localized(
                "Какое действие в этой теме является базово правильным?",
                "Which action is a basic correct practice in this topic?",
                "Бұл тақырыпта қай әрекет бастапқыда дұрыс тәжірибе болып саналады?",
            ),
            localized_list(
                [
                    "Сверять признаки риска перед действием.",
                    "Действовать сразу без уточнений.",
                    "Передавать доступ без проверки.",
                    "Игнорировать правила при нехватке времени.",
                ],
                [
                    "Verify risk signs before acting.",
                    "Act immediately without clarification.",
                    "Share access without verification.",
                    "Ignore rules when time is short.",
                ],
                [
                    "Әрекет алдында тәуекел белгілерін тексеру.",
                    "Нақтыламай бірден әрекет ету.",
                    "Тексерусіз қолжетімділік беру.",
                    "Уақыт жетпегенде ережелерді елемеу.",
                ],
            ),
            0,
            localized(
                "Сначала нужно проверить риск и контекст, это базовая безопасная практика.",
                "You should first check the risk and context; this is a basic safe practice.",
                "Алдымен тәуекел мен контексті тексеру керек, бұл негізгі қауіпсіз тәжірибе.",
            ),
            "Выберите вариант, который уменьшает риск.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q05",
            module_id,
            lesson_id,
            "multiple_choice",
            "easy",
            localized(
                "Что из списка соответствует обучающему материалу подтемы?",
                "Which option matches the learning material of this subtopic?",
                "Тізімдегі қай нұсқа осы ішкі тақырыптың оқу материалына сәйкес келеді?",
            ),
            localized_list(
                [
                    "Случайные действия без плана.",
                    b3["ru"],
                    "Отключение защитных мер.",
                    "Игнорирование сигналов риска.",
                ],
                [
                    "Random actions without a plan.",
                    b3["en"],
                    "Disabling protective measures.",
                    "Ignoring risk signals.",
                ],
                [
                    "Жоспарсыз кездейсоқ әрекеттер.",
                    b3["kk"],
                    "Қорғаныс шараларын өшіру.",
                    "Тәуекел сигналдарын елемеу.",
                ],
            ),
            1,
            localized(
                f"Верно, потому что этот пункт раскрывается в уроке: {b3['ru']}",
                f"Correct, because this point is covered in the lesson: {b3['en']}",
                f"Дұрыс, себебі бұл тармақ сабақта қарастырылады: {b3['kk']}",
            ),
            "Ориентируйтесь на разделы «Что вы узнаете» и «Ключевые факты».",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q06",
            module_id,
            lesson_id,
            "true_false",
            "medium",
            localized(
                "Верно ли, что сомнительные действия можно выполнять без дополнительной проверки?",
                "Is it safe to perform suspicious actions without additional verification?",
                "Күмәнді әрекеттерді қосымша тексерусіз орындауға бола ма?",
            ),
            localized_list(
                ["Верно", "Неверно"],
                ["True", "False"],
                ["Дұрыс", "Бұрыс"],
            ),
            1,
            localized(
                "Неверно. Если есть сомнение или риск, нужна дополнительная проверка.",
                "False. If there is doubt or risk, additional verification is required.",
                "Бұрыс. Егер күмән немесе тәуекел болса, қосымша тексеру қажет.",
            ),
            "В этой теме приоритет — безопасность, а не спешка.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q07",
            module_id,
            lesson_id,
            "scenario",
            "medium",
            localized(
                f"Сценарий: при выполнении задачи по теме «{title['ru']}» вы заметили подозрительный признак. Что сделать сначала?",
                f"Scenario: while working on “{title['en']}”, you notice a suspicious sign. What should you do first?",
                f"Сценарий: «{title['kk']}» тақырыбы бойынша тапсырманы орындау кезінде күмәнді белгі байқадыңыз. Алдымен не істеу керек?",
            ),
            localized_list(
                [
                    "Продолжить как обычно.",
                    "Отключить проверку для скорости.",
                    "Проверить признак по безопасной процедуре и только потом действовать.",
                    "Сразу передать данные без подтверждения.",
                ],
                [
                    "Continue as usual.",
                    "Disable verification for speed.",
                    "Check the sign using a safe procedure and act only after that.",
                    "Send the data immediately without confirmation.",
                ],
                [
                    "Әдеттегідей жалғастыру.",
                    "Жылдамдық үшін тексеруді өшіру.",
                    "Белгіні қауіпсіз рәсіммен тексеріп, содан кейін ғана әрекет ету.",
                    "Растамай деректерді бірден жіберу.",
                ],
            ),
            2,
            localized(
                "Первый шаг — верификация по безопасной процедуре. Это снижает риск ошибочного действия.",
                "The first step is verification through a safe procedure. This reduces the risk of a mistaken action.",
                "Бірінші қадам — қауіпсіз рәсім бойынша тексеру. Бұл қате әрекет қаупін азайтады.",
            ),
            "Подумайте, какой вариант добавляет контроль.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q08",
            module_id,
            lesson_id,
            "scenario",
            "hard",
            localized(
                "Сценарий: коллега просит пропустить обязательную проверку ради скорости. Какое решение наиболее безопасно?",
                "Scenario: a colleague asks to skip a mandatory check to save time. Which decision is the safest?",
                "Сценарий: әріптес уақыт үнемдеу үшін міндетті тексеруді өткізіп жіберуді сұрайды. Ең қауіпсіз шешім қайсы?",
            ),
            localized_list(
                [
                    "Согласиться, чтобы уложиться в срок.",
                    "Зафиксировать риск и выполнить обязательную проверку.",
                    "Сделать исключение без подтверждения.",
                    "Отключить проверку только на этот раз.",
                ],
                [
                    "Agree so the deadline is met.",
                    "Record the risk and complete the mandatory check.",
                    "Make an exception without confirmation.",
                    "Disable the check just this once.",
                ],
                [
                    "Мерзімге үлгеру үшін келісу.",
                    "Тәуекелді тіркеп, міндетті тексеруді орындау.",
                    "Растамай ерекшелік жасау.",
                    "Тек осы жолы тексеруді өшіру.",
                ],
            ),
            1,
            localized(
                "Даже при ограничении времени нужно фиксировать риск и выполнять обязательный контроль.",
                "Even under time pressure, the risk should be recorded and the mandatory control completed.",
                "Уақыт шектеулі болса да, тәуекелді тіркеп, міндетті бақылауды орындау керек.",
            ),
            "Выберите вариант, где риск управляется, а не игнорируется.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q09",
            module_id,
            lesson_id,
            "multiple_choice",
            "hard",
            localized(
                "Какое действие является ошибкой с точки зрения практик этой подтемы?",
                "Which action is a mistake from the perspective of this subtopic’s practices?",
                "Осы ішкі тақырып тәжірибесі тұрғысынан қай әрекет қате болып саналады?",
            ),
            localized_list(
                [
                    "Следовать регламенту.",
                    "Проверять контекст перед действием.",
                    "Документировать сомнительные ситуации.",
                    "Игнорировать признаки риска и обходить проверку.",
                ],
                [
                    "Follow the procedure.",
                    "Check the context before acting.",
                    "Document suspicious situations.",
                    "Ignore risk signs and bypass verification.",
                ],
                [
                    "Регламентті сақтау.",
                    "Әрекет жасамас бұрын контексті тексеру.",
                    "Күмәнді жағдайларды құжаттау.",
                    "Тәуекел белгілерін елемей, тексеруді айналып өту.",
                ],
            ),
            3,
            localized(
                "Игнорирование признаков риска и обход проверки противоречат безопасной практике.",
                "Ignoring risk signs and bypassing verification go against safe practice.",
                "Тәуекел белгілерін елемеу және тексеруді айналып өту қауіпсіз тәжірибеге қайшы келеді.",
            ),
            "Найдите вариант, который повышает риск.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q10",
            module_id,
            lesson_id,
            "multiple_choice",
            "medium",
            localized(
                "Какой итог правильно отражает практическое применение подтемы?",
                "Which conclusion best reflects the practical use of this subtopic?",
                "Қай қорытынды ішкі тақырыптың практикалық қолданылуын дұрыс көрсетеді?",
            ),
            localized_list(
                [
                    "Главное — скорость, а не проверка.",
                    "Достаточно одной меры без анализа.",
                    "Оценка риска, проверка контекста и действие по процедуре.",
                    "Можно пропускать контроль в нестандартной ситуации.",
                ],
                [
                    "Speed matters more than verification.",
                    "One measure is enough without analysis.",
                    "Risk assessment, context verification, and action by procedure.",
                    "Controls can be skipped in a non-standard situation.",
                ],
                [
                    "Бастысы — тексеру емес, жылдамдық.",
                    "Талдаусыз бір шараның өзі жеткілікті.",
                    "Тәуекелді бағалау, контексті тексеру және рәсім бойынша әрекет ету.",
                    "Стандарттан тыс жағдайда бақылауды өткізіп жіберуге болады.",
                ],
            ),
            2,
            localized(
                "Подтема подводит к комбинированному подходу: оценить риск, проверить контекст и действовать по правилу.",
                "The subtopic leads to a combined approach: assess risk, verify context, and act according to the procedure.",
                "Ішкі тақырып біріктірілген тәсілге әкеледі: тәуекелді бағалау, контексті тексеру және ереже бойынша әрекет ету.",
            ),
            "Ищите самый полный безопасный подход.",
        ),
    ]


def main() -> None:
    modules = json.loads(MODULES_PATH.read_text(encoding="utf-8-sig"))
    questions = []
    for mi, module in enumerate(modules.get("modules", []), start=1):
        for si, lesson in enumerate(module.get("lessons", []), start=1):
            questions.extend(make_questions(mi, si, module, lesson))

    QUESTIONS_PATH.write_text(
        json.dumps(questions, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"written={len(questions)}")


if __name__ == "__main__":
    main()
