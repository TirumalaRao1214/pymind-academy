import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lesson.dart';
import '../models/section.dart';
import '../services/content_loader.dart';

final contentLoaderProvider = Provider<ContentLoader>(
  (_) => ContentLoader(),
);

final sectionsProvider = FutureProvider<List<Section>>((ref) {
  return ref.read(contentLoaderProvider).loadSections();
});

final lessonsForSectionProvider =
    FutureProvider.family<List<Lesson>, String>((ref, sectionId) {
  return ref.read(contentLoaderProvider).loadLessonsForSection(sectionId);
});

final lessonProvider =
    FutureProvider.family<Lesson?, (String, String)>((ref, args) {
  return ref.read(contentLoaderProvider).loadLesson(args.$1, args.$2);
});

final allLessonsProvider = FutureProvider<List<Lesson>>((ref) {
  return ref.read(contentLoaderProvider).loadAllLessons();
});

final quotesProvider = FutureProvider<List<String>>((ref) {
  return ref.read(contentLoaderProvider).loadQuotes();
});

final roadmapProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.read(contentLoaderProvider).loadRoadmap();
});

final projectsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.read(contentLoaderProvider).loadProjects();
});

// Search filter state
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredLessonsProvider = Provider<AsyncValue<List<Lesson>>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final all = ref.watch(allLessonsProvider);
  return all.whenData((lessons) {
    if (query.isEmpty) return lessons;
    return lessons.where((l) {
      return l.title.toLowerCase().contains(query) ||
          l.explanation.toLowerCase().contains(query) ||
          l.section.toLowerCase().contains(query);
    }).toList();
  });
});
