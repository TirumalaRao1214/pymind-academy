class LessonProgress {
  final String lessonId;
  final bool completed;
  final int bestQuizScore;
  final int totalQuizQuestions;
  final DateTime? lastAccessedAt;

  const LessonProgress({
    required this.lessonId,
    this.completed = false,
    this.bestQuizScore = 0,
    this.totalQuizQuestions = 0,
    this.lastAccessedAt,
  });

  LessonProgress copyWith({
    bool? completed,
    int? bestQuizScore,
    int? totalQuizQuestions,
    DateTime? lastAccessedAt,
  }) {
    return LessonProgress(
      lessonId: lessonId,
      completed: completed ?? this.completed,
      bestQuizScore: bestQuizScore ?? this.bestQuizScore,
      totalQuizQuestions: totalQuizQuestions ?? this.totalQuizQuestions,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
    );
  }
}

class AppProgress {
  final Map<String, LessonProgress> lessons;
  final Set<String> bookmarks;
  final int streak;
  final DateTime? lastActiveDate;
  final String? lastLessonId;
  final String? lastSectionId;

  const AppProgress({
    this.lessons = const {},
    this.bookmarks = const {},
    this.streak = 0,
    this.lastActiveDate,
    this.lastLessonId,
    this.lastSectionId,
  });

  int get completedCount => lessons.values.where((l) => l.completed).length;

  bool isCompleted(String lessonId) =>
      lessons[lessonId]?.completed ?? false;

  bool isBookmarked(String lessonId) => bookmarks.contains(lessonId);

  int bestScore(String lessonId) =>
      lessons[lessonId]?.bestQuizScore ?? 0;

  int totalQuestions(String lessonId) =>
      lessons[lessonId]?.totalQuizQuestions ?? 0;

  AppProgress copyWith({
    Map<String, LessonProgress>? lessons,
    Set<String>? bookmarks,
    int? streak,
    DateTime? lastActiveDate,
    String? lastLessonId,
    String? lastSectionId,
  }) {
    return AppProgress(
      lessons: lessons ?? this.lessons,
      bookmarks: bookmarks ?? this.bookmarks,
      streak: streak ?? this.streak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      lastLessonId: lastLessonId ?? this.lastLessonId,
      lastSectionId: lastSectionId ?? this.lastSectionId,
    );
  }
}
