import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/lesson.dart';
import '../models/section.dart';

class ContentLoader {
  static final ContentLoader _instance = ContentLoader._internal();
  factory ContentLoader() => _instance;
  ContentLoader._internal();

  // Cache
  List<Section>? _sectionsCache;
  final Map<String, List<Lesson>> _lessonsCache = {};

  static const List<String> _sectionFolders = [
    '01_python_basics',
    '02_control_flow',
    '03_functions',
    '04_data_structures',
    '05_oop',
    '06_file_handling',
    '07_apis',
    '08_automation',
    '09_numpy_pandas_ml',
    '10_ai_agentic',
  ];

  Future<List<Section>> loadSections() async {
    if (_sectionsCache != null) return _sectionsCache!;
    final sections = <Section>[];
    for (final folder in _sectionFolders) {
      try {
        final raw = await rootBundle
            .loadString('assets/lessons/$folder/section.json');
        final json = jsonDecode(raw) as Map<String, dynamic>;
        sections.add(Section.fromJson(json));
      } catch (e) {
        // skip missing section files gracefully
      }
    }
    sections.sort((a, b) => a.order.compareTo(b.order));
    _sectionsCache = sections;
    return sections;
  }

  Future<List<Lesson>> loadLessonsForSection(String sectionId) async {
    if (_lessonsCache.containsKey(sectionId)) {
      return _lessonsCache[sectionId]!;
    }
    // Match folder by stripping the "NN_" numeric prefix
    final folder = _sectionFolders.firstWhere(
      (f) => f.contains(sectionId),
      orElse: () => sectionId,
    );
    final lessons = <Lesson>[];
    // Try loading numbered lesson files 01 through 20
    for (int i = 1; i <= 20; i++) {
      final fileName = i.toString().padLeft(2, '0');
      try {
        final raw = await rootBundle
            .loadString('assets/lessons/$folder/${fileName}_lesson.json');
        final json = jsonDecode(raw) as Map<String, dynamic>;
        lessons.add(Lesson.fromJson(json));
      } catch (_) {
        // No more lesson files
        break;
      }
    }
    lessons.sort((a, b) => a.order.compareTo(b.order));
    _lessonsCache[sectionId] = lessons;
    return lessons;
  }

  Future<Lesson?> loadLesson(String sectionId, String lessonId) async {
    final lessons = await loadLessonsForSection(sectionId);
    try {
      return lessons.firstWhere((l) => l.id == lessonId);
    } catch (_) {
      return null;
    }
  }

  Future<List<Lesson>> loadAllLessons() async {
    final allLessons = <Lesson>[];
    final sections = await loadSections();
    for (final section in sections) {
      final lessons = await loadLessonsForSection(section.id);
      allLessons.addAll(lessons);
    }
    return allLessons;
  }

  Future<List<String>> loadQuotes() async {
    try {
      final raw = await rootBundle.loadString('assets/quotes/quotes.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return List<String>.from(json['quotes'] as List);
    } catch (_) {
      return ['Keep coding. Keep growing.'];
    }
  }

  Future<List<Map<String, dynamic>>> loadRoadmap() async {
    try {
      final raw = await rootBundle.loadString('assets/roadmap/roadmap.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(json['nodes'] as List);
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> loadProjects() async {
    try {
      final raw = await rootBundle.loadString('assets/projects/projects.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(json['projects'] as List);
    } catch (_) {
      return [];
    }
  }

  void clearCache() {
    _sectionsCache = null;
    _lessonsCache.clear();
  }
}
