import 'quiz_question.dart';

class Lesson {
  final String id;
  final String title;
  final String level;
  final String section;
  final int order;
  final String explanation;
  final String realWorldUsage;
  final String codeExample;
  final List<String> commonMistakes;
  final String miniExercise;
  final List<String> interviewQuestions;
  final String summary;
  final List<QuizQuestion> quiz;

  const Lesson({
    required this.id,
    required this.title,
    required this.level,
    required this.section,
    required this.order,
    required this.explanation,
    required this.realWorldUsage,
    required this.codeExample,
    required this.commonMistakes,
    required this.miniExercise,
    required this.interviewQuestions,
    required this.summary,
    required this.quiz,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      level: json['level'] as String? ?? 'Beginner',
      section: json['section'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      explanation: json['explanation'] as String? ?? '',
      realWorldUsage: json['real_world_usage'] as String? ?? '',
      codeExample: json['code_example'] as String? ?? '',
      commonMistakes: List<String>.from(
          (json['common_mistakes'] as List?) ?? []),
      miniExercise: json['mini_exercise'] as String? ?? '',
      interviewQuestions: List<String>.from(
          (json['interview_questions'] as List?) ?? []),
      summary: json['summary'] as String? ?? '',
      quiz: ((json['quiz'] as List?) ?? [])
          .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}
