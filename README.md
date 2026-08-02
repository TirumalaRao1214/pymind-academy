# PyMind Academy 🐍

> **Offline-first Flutter Android app — Learn Python from Basics to Agentic AI**

A fully static, offline-first educational app with no backend, no database, and no internet required. All 50+ lessons, quizzes, projects, and roadmap content are bundled as local JSON assets inside the APK.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| **10 Learning Sections** | Python Basics → Control Flow → Functions → Data Structures → OOP → File Handling → APIs → Automation → NumPy/Pandas/ML → AI & Agentic AI |
| **50+ Lessons** | Each with explanation, real-world usage, code examples, common mistakes, mini exercises, interview questions, and summary |
| **Quiz System** | MCQs with instant feedback, explanations, score tracking |
| **Code Playground** | 6 interactive examples with copy-to-clipboard |
| **Projects** | 9 projects (Beginner → Intermediate → Advanced) with step-by-step guides |
| **AI/ML Roadmap** | Visual 7-node learning path from Python Basics to Agentic AI |
| **Bookmarks** | Save favorite lessons locally |
| **Search** | Full-text search across all 50+ lessons |
| **Progress Tracking** | Per-lesson completion, streak counter, progress bars |
| **Stats Screen** | Completion charts, streak badge |
| **Dark / Light Theme** | Toggle in the top bar |
| **Offline-first** | Zero internet required after install |

---

## 🚀 Quick Start

### Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Flutter SDK | ≥ 3.10.0 | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) |
| Dart SDK | ≥ 3.1.0 | Bundled with Flutter |
| Android Studio | ≥ 2023.1 | [developer.android.com/studio](https://developer.android.com/studio) |
| Android SDK | API 21+ | Via Android Studio SDK Manager |
| Java | 17 (JDK) | Bundled with Android Studio |

### 1. Install Flutter (Windows)

```powershell
# Option A — winget
winget install Google.Flutter

# Option B — Manual
# 1. Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
# 2. Extract to C:\flutter
# 3. Add C:\flutter\bin to your PATH environment variable
# 4. Restart terminal, verify:
flutter --version
flutter doctor
```

### 2. Clone / open the project

```powershell
cd C:\Users\GoliTirumalaRao\.bob\playground\pymind_academy
flutter pub get
```

### 3. Run on emulator or device

```powershell
# List available devices
flutter devices

# Run on Android emulator (start emulator first from Android Studio)
flutter run

# Run on connected Android phone (enable Developer Options + USB Debugging)
flutter run -d <device-id>
```

### 4. Build release APK

```powershell
# Debug APK (faster, larger)
flutter build apk --debug

# Release APK (optimised, smaller)
flutter build apk --release

# Split APKs per ABI (smallest install size)
flutter build apk --split-per-abi --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### 5. Install APK on device

```powershell
# Via adb
adb install build/app/outputs/flutter-apk/app-release.apk

# Or copy the APK to phone and open it (enable "Install unknown apps")
```

---

## 📁 Project Structure

```
pymind_academy/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── app.dart                     # MaterialApp.router + ProviderScope
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart      # Color palette
│   │   │   └── app_text_styles.dart # Typography
│   │   ├── router/
│   │   │   └── app_router.dart      # GoRouter — all named routes
│   │   └── theme/
│   │       └── app_theme.dart       # Dark + Light ThemeData
│   ├── models/
│   │   ├── lesson.dart              # Lesson data model
│   │   ├── quiz_question.dart       # Quiz MCQ model
│   │   ├── section.dart             # Section metadata model
│   │   └── progress.dart            # Progress & AppProgress models
│   ├── services/
│   │   ├── content_loader.dart      # Loads JSON from assets via rootBundle
│   │   └── progress_service.dart    # shared_preferences CRUD
│   ├── providers/
│   │   ├── lessons_provider.dart    # Riverpod FutureProviders for content
│   │   ├── quiz_provider.dart       # QuizNotifier + QuizState
│   │   ├── progress_provider.dart   # ProgressNotifier (shared_prefs)
│   │   ├── theme_provider.dart      # Theme toggle StateNotifier
│   │   └── quotes_provider.dart     # Re-exports quotesProvider
│   └── screens/
│       ├── main_shell.dart          # Bottom NavigationBar shell
│       ├── home/
│       │   ├── home_screen.dart
│       │   └── widgets/
│       │       ├── daily_quote_card.dart
│       │       ├── continue_learning_card.dart
│       │       ├── progress_summary_card.dart
│       │       └── category_grid.dart
│       ├── lessons/
│       │   ├── section_list_screen.dart
│       │   ├── lesson_list_screen.dart
│       │   ├── lesson_detail_screen.dart
│       │   └── widgets/
│       │       ├── code_block_widget.dart
│       │       └── lesson_section_tile.dart
│       ├── quiz/
│       │   ├── quiz_screen.dart
│       │   └── quiz_result_screen.dart
│       ├── bookmarks/
│       │   └── bookmarks_screen.dart
│       ├── search/
│       │   └── search_screen.dart
│       ├── playground/
│       │   └── code_playground_screen.dart
│       ├── projects/
│       │   └── projects_screen.dart
│       ├── roadmap/
│       │   └── roadmap_screen.dart
│       └── stats/
│           └── stats_screen.dart
│
├── assets/
│   ├── lessons/
│   │   ├── 01_python_basics/        # 5 lessons + section.json
│   │   ├── 02_control_flow/         # 5 lessons + section.json
│   │   ├── 03_functions/            # 5 lessons + section.json
│   │   ├── 04_data_structures/      # 5 lessons + section.json
│   │   ├── 05_oop/                  # 5 lessons + section.json
│   │   ├── 06_file_handling/        # 4 lessons + section.json
│   │   ├── 07_apis/                 # 4 lessons + section.json
│   │   ├── 08_automation/           # 4 lessons + section.json
│   │   ├── 09_numpy_pandas_ml/      # 5 lessons + section.json
│   │   └── 10_ai_agentic/           # 5 lessons + section.json
│   ├── quizzes/                     # (embedded in lesson JSON)
│   ├── projects/
│   │   └── projects.json            # 9 projects (Beginner/Intermediate/Advanced)
│   ├── roadmap/
│   │   └── roadmap.json             # 7-node AI/ML learning path
│   ├── quotes/
│   │   └── quotes.json              # 35 motivational quotes
│   └── images/                      # (add icons/illustrations here)
│
├── android/
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       └── kotlin/com/pymind/pymind_academy/MainActivity.kt
│   ├── build.gradle
│   ├── settings.gradle
│   └── gradle.properties
│
└── pubspec.yaml
```

---

## 📄 Content JSON Schema

### Lesson (`assets/lessons/{section}/{n}_lesson.json`)

```json
{
  "id": "unique_lesson_id",
  "title": "Lesson Title",
  "level": "Beginner | Intermediate | Advanced",
  "section": "section_id",
  "order": 1,
  "explanation": "Markdown text explaining the concept",
  "real_world_usage": "How this is used in production",
  "code_example": "# Python code string",
  "common_mistakes": ["Mistake 1", "Mistake 2"],
  "mini_exercise": "Practice task description",
  "interview_questions": ["Question 1?", "Question 2?"],
  "summary": "Markdown summary text",
  "quiz": [
    {
      "question": "Question text?",
      "options": ["A", "B", "C", "D"],
      "correct_index": 0,
      "explanation": "Why A is correct"
    }
  ]
}
```

### Section (`assets/lessons/{folder}/section.json`)

```json
{
  "id": "section_id",
  "title": "Section Title",
  "icon": "icon_name",
  "color": "#HEX",
  "description": "Short description",
  "lesson_count": 5,
  "order": 1
}
```

---

## 🛠️ Tech Stack

| Component | Package | Version |
|-----------|---------|---------|
| Framework | Flutter | ≥ 3.10 |
| State Management | flutter_riverpod | ^2.5.1 |
| Navigation | go_router | ^13.2.0 |
| Local Storage | shared_preferences | ^2.2.3 |
| Markdown Rendering | flutter_markdown | ^0.7.3 |
| Fonts | google_fonts | ^6.2.1 |
| Progress Charts | fl_chart | ^0.68.0 |
| Share | share_plus | ^9.0.0 |
| PDF Export | pdf + printing | ^3.11.0 + ^5.13.0 |

---

## ➕ Adding Content

### Add a new lesson

1. Create `assets/lessons/{section_folder}/{n}_lesson.json`
2. Follow the JSON schema above
3. Update `lesson_count` in `section.json`
4. No code changes needed — `ContentLoader` picks it up automatically

### Add a new section

1. Add the folder to `assets/lessons/` with `section.json` + lesson files
2. Add the folder path to `pubspec.yaml` under `flutter.assets`
3. Add the folder name to `_sectionFolders` list in [`content_loader.dart`](lib/services/content_loader.dart)

---

## 🔧 flutter doctor Checklist

Run `flutter doctor` and fix any issues before building:

```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain - develop for Android devices
[✓] Android Studio (version 2023.x)
[✓] Connected device (1 available)
[✓] Network resources
```

Common fixes:
- `flutter doctor --android-licenses` — accept all Android SDK licenses
- Add `ANDROID_HOME=C:\Android\Sdk` to environment variables
- Ensure `JAVA_HOME` points to JDK 17

---

## 📱 Minimum Requirements

- Android 5.0 (API 21) or higher
- ~50 MB storage (no runtime downloads)
- No internet connection required

---

## 🏗️ Architecture Decisions

| Decision | Choice | Reason |
|----------|--------|--------|
| State management | Riverpod | Compile-safe, excellent async support |
| Navigation | go_router | Declarative, deep-link ready |
| Storage | shared_preferences | Lightweight, zero-setup |
| Content | JSON in assets/ | Fully offline, version-controlled |
| Code playground | Display-only | No security risk, no native dependencies |
| Backend | None | Fully static offline-first |

---

## 📝 License

MIT License — free for personal and educational use.

---

*Built with Flutter • Powered by knowledge • No internet required*
