import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../screens/main_shell.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/lessons/section_list_screen.dart';
import '../../screens/lessons/lesson_list_screen.dart';
import '../../screens/lessons/lesson_detail_screen.dart';
import '../../screens/quiz/quiz_screen.dart';
import '../../screens/quiz/quiz_result_screen.dart';
import '../../screens/bookmarks/bookmarks_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/playground/code_playground_screen.dart';
import '../../screens/projects/projects_screen.dart';
import '../../screens/roadmap/roadmap_screen.dart';
import '../../screens/stats/stats_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/learn',
            name: 'learn',
            builder: (context, state) => const SectionListScreen(),
            routes: [
              GoRoute(
                path: ':sectionId',
                name: 'lessonList',
                builder: (context, state) => LessonListScreen(
                  sectionId: state.pathParameters['sectionId']!,
                ),
                routes: [
                  GoRoute(
                    path: ':lessonId',
                    name: 'lessonDetail',
                    builder: (context, state) => LessonDetailScreen(
                      sectionId: state.pathParameters['sectionId']!,
                      lessonId: state.pathParameters['lessonId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/quiz/:lessonId',
            name: 'quiz',
            builder: (context, state) => QuizScreen(
              lessonId: state.pathParameters['lessonId']!,
            ),
          ),
          GoRoute(
            path: '/quiz-result',
            name: 'quizResult',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              return QuizResultScreen(
                score: extra['score'] as int,
                total: extra['total'] as int,
                lessonId: extra['lessonId'] as String,
                lessonTitle: extra['lessonTitle'] as String,
              );
            },
          ),
          GoRoute(
            path: '/bookmarks',
            name: 'bookmarks',
            builder: (context, state) => const BookmarksScreen(),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/playground',
            name: 'playground',
            builder: (context, state) => const CodePlaygroundScreen(),
          ),
          GoRoute(
            path: '/projects',
            name: 'projects',
            builder: (context, state) => const ProjectsScreen(),
          ),
          GoRoute(
            path: '/roadmap',
            name: 'roadmap',
            builder: (context, state) => const RoadmapScreen(),
          ),
          GoRoute(
            path: '/stats',
            name: 'stats',
            builder: (context, state) => const StatsScreen(),
          ),
        ],
      ),
    ],
  );
});
