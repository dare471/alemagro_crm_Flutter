part of 'survey_bloc.dart';

abstract class SurveyTwoEvent extends Equatable {
  const SurveyTwoEvent();

  @override
  List<Object> get props => [];
}

class LoadTwoQuestions extends SurveyTwoEvent {}

class AnswerQuestion extends SurveyTwoEvent {
  final SurveyData surveyData;

  const AnswerQuestion(this.surveyData);

  @override
  List<Object> get props => [];
}
