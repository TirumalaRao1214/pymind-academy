import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/progress.dart';

class ProgressService {
  static const String _completedKey    = 'completed_lessons';
  static const String _bookmarksKey    = 'bookmarks';
  static const String _quizScoresKey   = 'quiz_scores';
  static const String _quizTotalsKey   = 'quiz_totals';
  static const String _streakKey       = 'streak';
  static const String _lastActiveKey   = 'last_active_date';
  static const String _lastLessonKey   = 'last_lesson_id';
  static const String _lastSectionKey  = 'last_section_id';

  Future<AppProgress> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final completedJson = prefs.getString(_completedKey) ?? '[]';
    final completedList = List<String>.from(jsonDecode(completedJson) as List);

    final bookmarksJson = prefs.getString(_bookmarksKey) ?? '[]';
    final bookmarksList = List<String>.from(jsonDecode(bookmarksJson) as List);

    final scoresJson = prefs.getString(_quizScoresKey) ?? '{}';
    final scoresMap = Map<String, int>.from(
      (jsonDecode(scoresJson) as Map).map(
        (k, v) => MapEntry(k as String, v as int),
      ),
    );

    final totalsJson = prefs.getString(_quizTotalsKey) ?? '{}';
    final totalsMap = Map<String, int>.from(
      (jsonDecode(totalsJson) as Map).map(
        (k, v) => MapEntry(k as String, v as int),
      ),
    );

    final streak = prefs.getInt(_streakKey) ?? 0;
    final lastActiveDateStr = prefs.getString(_lastActiveKey);
    final lastLessonId  = prefs.getString(_lastLessonKey);
    final lastSectionId = prefs.getString(_lastSectionKey);

    final lessons = <String, LessonProgress>{};
    for (final id in {...completedList, ...scoresMap.keys}) {
      lessons[id] = LessonProgress(
        lessonId: id,
        completed: completedList.contains(id),
        bestQuizScore: scoresMap[id] ?? 0,
        totalQuizQuestions: totalsMap[id] ?? 0,
      );
    }

    return AppProgress(
      lessons: lessons,
      bookmarks: bookmarksList.toSet(),
      streak: streak,
      lastActiveDate: lastActiveDateStr != null
          ? DateTime.tryParse(lastActiveDateStr)
          : null,
      lastLessonId: lastLessonId,
      lastSectionId: lastSectionId,
    );
  }

  Future<void> markLessonComplete(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_completedKey) ?? '[]';
    final list = List<String>.from(jsonDecode(json) as List);
    if (!list.contains(lessonId)) {
      list.add(lessonId);
      await prefs.setString(_completedKey, jsonEncode(list));
    }
  }

  Future<void> saveQuizScore(
      String lessonId, int score, int total) async {
    final prefs = await SharedPreferences.getInstance();

    final scoresJson = prefs.getString(_quizScoresKey) ?? '{}';
    final scoresMap = Map<String, dynamic>.from(jsonDecode(scoresJson) as Map);
    final current = scoresMap[lessonId] as int? ?? 0;
    if (score > current) {
      scoresMap[lessonId] = score;
      await prefs.setString(_quizScoresKey, jsonEncode(scoresMap));
    }

    final totalsJson = prefs.getString(_quizTotalsKey) ?? '{}';
    final totalsMap = Map<String, dynamic>.from(jsonDecode(totalsJson) as Map);
    totalsMap[lessonId] = total;
    await prefs.setString(_quizTotalsKey, jsonEncode(totalsMap));
  }

  Future<void> toggleBookmark(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_bookmarksKey) ?? '[]';
    final list = List<String>.from(jsonDecode(json) as List);
    if (list.contains(lessonId)) {
      list.remove(lessonId);
    } else {
      list.add(lessonId);
    }
    await prefs.setString(_bookmarksKey, jsonEncode(list));
  }

  Future<void> setLastLesson(
      String lessonId, String sectionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLessonKey, lessonId);
    await prefs.setString(_lastSectionKey, sectionId);
  }

  Future<void> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';
    final lastActiveStr = prefs.getString(_lastActiveKey);

    if (lastActiveStr == todayStr) return; // already counted today

    int streak = prefs.getInt(_streakKey) ?? 0;

    if (lastActiveStr != null) {
      final lastActive = DateTime.tryParse(lastActiveStr);
      if (lastActive != null) {
        final diff = today.difference(lastActive).inDays;
        if (diff == 1) {
          streak += 1; // consecutive day
        } else if (diff > 1) {
          streak = 1; // reset
        }
      } else {
        streak = 1;
      }
    } else {
      streak = 1; // first time
    }

    await prefs.setInt(_streakKey, streak);
    await prefs.setString(_lastActiveKey, todayStr);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
