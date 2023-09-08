part of 'survey_bloc.dart';

abstract class SurveyEvent extends Equatable {
  const SurveyEvent();

  @override
  List<Object> get props => [];
}

class LoadQuestion extends SurveyEvent {}

class AnswerQuestion extends SurveyEvent {
  final int questionId;
  final dynamic answer;
  final String name;

  const AnswerQuestion(
      {required this.questionId, required this.answer, required this.name});

  @override
  List<Object> get props => [
        {questionId, answer, name}
      ];
}

class MoveToNextPage extends SurveyEvent {}
