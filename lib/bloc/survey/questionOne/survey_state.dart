part of 'survey_bloc.dart';

abstract class SurveyState extends Equatable {
  const SurveyState();

  @override
  List<Object> get props => [];
}

class QuestionInitial extends SurveyState {}

class QuestionLoading extends SurveyState {}

class QuestionLoaded extends SurveyState {
  final int currentPage; // Добавляем новое поле для текущей страницы
  final List<dynamic> questions;
  final Map<int, String> selectedAnswers;
  final bool canMoveToNextPage;

  const QuestionLoaded({
    this.currentPage = 1, // задаем значение по умолчанию
    required this.questions,
    this.selectedAnswers = const {},
    this.canMoveToNextPage = false,
  });

  @override
  List<Object> get props =>
      [currentPage, questions, selectedAnswers, canMoveToNextPage];

  QuestionLoaded copyWith({
    int? currentPage,
    List<dynamic>? questions,
    Map<int, String>? selectedAnswers,
    bool? canMoveToNextPage,
  }) {
    return QuestionLoaded(
      currentPage: currentPage ?? this.currentPage,
      questions: questions ?? this.questions,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      canMoveToNextPage: canMoveToNextPage ?? this.canMoveToNextPage,
    );
  }
}

class SurveyError extends SurveyState {}
