import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MODULES_PATH = ROOT / "assets/data/modules.json"
QUESTIONS_PATH = ROOT / "assets/data/questions.json"


def clean(text: str) -> str:
    text = str(text or "").replace("\uFFFD", "").strip()
    text = re.sub(r"\s+", " ", text)
    return text


def demojibake(text: str) -> str:
    s = str(text or "")
    # Typical broken UTF-8 -> cp1251 artifacts: "РџСЂ..."
    if "Р" in s or "С" in s:
        try:
            fixed = s.encode("latin1", errors="ignore").decode("utf-8", errors="ignore")
            fixed = fixed.replace("\uFFFD", "")
            if fixed:
                s = fixed
        except Exception:
            pass
    return clean(s)


def tr_ru(obj: dict, key: str) -> str:
    val = obj.get(key, {})
    if isinstance(val, dict):
        return demojibake(val.get("ru") or val.get("en") or val.get("kk") or "")
    return ""


def tr_ru_list(obj: dict, key: str) -> list[str]:
    val = obj.get(key, {})
    if not isinstance(val, dict):
        return []
    arr = val.get("ru") or val.get("en") or val.get("kk") or []
    if not isinstance(arr, list):
        return []
    return [demojibake(x) for x in arr if clean(x)]


def crop(text: str, n: int = 140) -> str:
    t = clean(text)
    return t if len(t) <= n else t[: n - 1].rstrip() + "…"


def qobj(
    qid: str,
    module_id: str,
    lesson_id: str,
    qtype: str,
    difficulty: str,
    question: str,
    options: list[str],
    correct: int,
    explanation: str,
    hint: str,
) -> dict:
    return {
        "questionId": qid,
        "moduleId": module_id,
        "lessonId": lesson_id,
        "type": qtype,
        "difficulty": difficulty,
        "question": clean(question),
        "options": [clean(x) for x in options],
        "correctIndex": correct,
        "correctAnswer": correct,
        "explanation": clean(explanation),
        "hint": clean(hint),
    }


def make_questions(mi: int, si: int, module: dict, lesson: dict) -> list[dict]:
    module_id = module["id"]
    lesson_id = lesson["id"]
    title = tr_ru(lesson, "title") or lesson_id
    summary = tr_ru(lesson, "summary")
    learn = tr_ru_list(lesson, "whatYouWillLearn")
    facts = tr_ru_list(lesson, "keyFacts")
    examples = tr_ru_list(lesson, "examples")

    base = []
    for chunk in [summary, *learn, *facts, *examples]:
        c = clean(chunk)
        if c and c not in base:
            base.append(c)
    while len(base) < 6:
        base.append("Следовать безопасной процедуре и снижать риск.")

    b1, b2, b3, b4, b5, b6 = [crop(x) for x in base[:6]]

    return [
        qobj(
            f"m{mi:02d}_s{si:02d}_q01",
            module_id,
            lesson_id,
            "multiple_choice",
            "easy",
            f"Как лучше всего описать ключевую идею подтемы «{title}»?",
            [b1, "Быстро выполнить действие без проверки.", "Игнорировать риск ради удобства.", "Отключить защиту для ускорения."],
            0,
            f"Ключевая идея подтемы отражена в материале: {b1}",
            "Вспомните основную мысль урока.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q02",
            module_id,
            lesson_id,
            "true_false",
            "easy",
            f"Верно ли, что в подтеме «{title}» важны проверка контекста и безопасные действия?",
            ["Верно", "Неверно"],
            0,
            "Верно. Подтема учит снижать риск за счет проверки и корректных действий.",
            "Ориентируйтесь на практический вывод урока.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q03",
            module_id,
            lesson_id,
            "multiple_choice",
            "easy",
            "Какой тезис относится к содержанию этой подтемы?",
            [b2, "Как обойти контроль безопасности.", "Как скрыть следы нарушения.", "Как отключить уведомления защиты."],
            0,
            f"Этот тезис взят из учебного материала подтемы: {b2}",
            "Сопоставьте вариант с тем, что разбиралось в уроке.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q04",
            module_id,
            lesson_id,
            "multiple_choice",
            "easy",
            "Какое действие в этой теме является базово правильным?",
            ["Сверять признаки риска перед действием.", "Действовать сразу без уточнений.", "Передавать доступ без проверки.", "Игнорировать правила при нехватке времени."],
            0,
            "Сначала нужно проверить риск и контекст, это базовая безопасная практика.",
            "Выберите вариант, который уменьшает риск.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q05",
            module_id,
            lesson_id,
            "multiple_choice",
            "easy",
            "Что из списка соответствует обучающему материалу подтемы?",
            ["Случайные действия без плана.", b3, "Отключение защитных мер.", "Игнорирование сигналов риска."],
            1,
            f"Верно, потому что этот пункт раскрывается в уроке: {b3}",
            "Ориентируйтесь на разделы «Что вы узнаете» и «Ключевые факты».",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q06",
            module_id,
            lesson_id,
            "true_false",
            "medium",
            "Верно ли, что сомнительные действия можно выполнять без дополнительной проверки?",
            ["Верно", "Неверно"],
            1,
            "Неверно. Если есть сомнение или риск, нужна дополнительная проверка.",
            "В этой теме приоритет — безопасность, а не спешка.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q07",
            module_id,
            lesson_id,
            "scenario",
            "medium",
            f"Сценарий: при выполнении задачи по теме «{title}» вы заметили подозрительный признак. Что сделать сначала?",
            [
                "Продолжить как обычно.",
                "Отключить проверку для скорости.",
                "Проверить признак по безопасной процедуре и только потом действовать.",
                "Сразу передать данные без подтверждения.",
            ],
            2,
            "Первый шаг — верификация по безопасной процедуре. Это снижает риск ошибочного действия.",
            "Подумайте, какой вариант добавляет контроль.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q08",
            module_id,
            lesson_id,
            "scenario",
            "hard",
            "Сценарий: коллега просит пропустить обязательную проверку ради скорости. Какое решение наиболее безопасно?",
            [
                "Согласиться, чтобы уложиться в срок.",
                "Зафиксировать риск и выполнить обязательную проверку.",
                "Сделать исключение без подтверждения.",
                "Отключить проверку только на этот раз.",
            ],
            1,
            "Даже при ограничении времени нужно фиксировать риск и выполнять обязательный контроль.",
            "Выберите вариант, где риск управляется, а не игнорируется.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q09",
            module_id,
            lesson_id,
            "multiple_choice",
            "hard",
            "Какое действие является ошибкой с точки зрения практик этой подтемы?",
            [
                "Следовать регламенту.",
                "Проверять контекст перед действием.",
                "Документировать сомнительные ситуации.",
                "Игнорировать признаки риска и обходить проверку.",
            ],
            3,
            "Игнорирование признаков риска и обход проверки противоречат безопасной практике.",
            "Найдите вариант, который повышает риск.",
        ),
        qobj(
            f"m{mi:02d}_s{si:02d}_q10",
            module_id,
            lesson_id,
            "multiple_choice",
            "medium",
            "Какой итог правильно отражает практическое применение подтемы?",
            [
                "Главное — скорость, а не проверка.",
                "Достаточно одной меры без анализа.",
                "Оценка риска, проверка контекста и действие по процедуре.",
                "Можно пропускать контроль в нестандартной ситуации.",
            ],
            2,
            "Подтема подводит к комбинированному подходу: оценить риск, проверить контекст и действовать по правилу.",
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
