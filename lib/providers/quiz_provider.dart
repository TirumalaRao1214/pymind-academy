import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz_question.dart';

enum QuizAnswerState { unanswered, correct, wrong }

class QuizState {
  final List<QuizQuestion> questions;
  final int currentIndex;
  final Map<int, int> selectedAnswers; // questionIndex -> selectedOptionIndex
  final bool showFeedback;
  final bool finished;

  const QuizState({
    required this.questions,
    this.currentIndex = 0,
    this.selectedAnswers = const {},
    this.showFeedback = false,
    this.finished = false,
  });

  QuizQuestion? get currentQuestion =>
      questions.isNotEmpty ? questions[currentIndex] : null;

  bool get isLastQuestion => currentIndex >= questions.length - 1;

  int get score => selectedAnswers.entries.where((e) {
        final q = questions[e.key];
        return e.value == q.correctIndex;
      }).length;

  int get answeredCount => selectedAnswers.length;

  QuizAnswerState answerState(int questionIndex) {
    final selected = selectedAnswers[questionIndex];
    if (selected == null) return QuizAnswerState.unanswered;
    return selected == questions[questionIndex].correctIndex
        ? QuizAnswerState.correct
        : QuizAnswerState.wrong;
  }

  QuizState copyWith({
    int? currentIndex,
    Map<int, int>? selectedAnswers,
    bool? showFeedback,
    bool? finished,
  }) {
    return QuizState(
      questions: questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      showFeedback: showFeedback ?? this.showFeedback,
      finished: finished ?? this.finished,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier(List<QuizQuestion> questions)
      : super(QuizState(questions: questions));

  void selectAnswer(int optionIndex) {
    if (state.showFeedback) return; // already answered
    final updated = Map<int, int>.from(state.selectedAnswers);
    updated[state.currentIndex] = optionIndex;
    state = state.copyWith(
      selectedAnswers: updated,
      showFeedback: true,
    );
  }

  void nextQuestion() {
    if (state.isLastQuestion) {
      state = state.copyWith(finished: true);
    } else {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        showFeedback: false,
      );
    }
  }

  void restart() {
    state = QuizState(questions: state.questions);
  }
}

final quizNotifierProvider =
    StateNotifierProvider.family<QuizNotifier, QuizState, List<QuizQuestion>>(
  (ref, questions) => QuizNotifier(questions),
);
