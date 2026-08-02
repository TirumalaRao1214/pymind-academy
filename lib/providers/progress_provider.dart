import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/progress.dart';
import '../services/progress_service.dart';

final progressServiceProvider = Provider<ProgressService>(
  (_) => ProgressService(),
);

final progressProvider =
    StateNotifierProvider<ProgressNotifier, AsyncValue<AppProgress>>((ref) {
  return ProgressNotifier(ref.read(progressServiceProvider));
});

class ProgressNotifier
    extends StateNotifier<AsyncValue<AppProgress>> {
  final ProgressService _service;

  ProgressNotifier(this._service) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      await _service.updateStreak();
      final progress = await _service.loadProgress();
      state = AsyncValue.data(progress);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markComplete(String lessonId) async {
    await _service.markLessonComplete(lessonId);
    await _reload();
  }

  Future<void> saveQuizScore(
      String lessonId, int score, int total) async {
    await _service.saveQuizScore(lessonId, score, total);
    await _reload();
  }

  Future<void> toggleBookmark(String lessonId) async {
    await _service.toggleBookmark(lessonId);
    await _reload();
  }

  Future<void> setLastLesson(String lessonId, String sectionId) async {
    await _service.setLastLesson(lessonId, sectionId);
    await _reload();
  }

  Future<void> _reload() async {
    try {
      final progress = await _service.loadProgress();
      state = AsyncValue.data(progress);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clearProgress() async {
    await _service.clearAll();
    await _reload();
  }
}
