part of 'survey_bloc.dart';

abstract class SurveyTwoState extends Equatable {
  const SurveyTwoState();

  @override
  List<Object> get props => [];
}

class SurveyTwoInitial extends SurveyTwoState {
  @override
  List<Object> get props => [];
}

class SurveyLoading extends SurveyTwoState {}

class SurveyLoaded extends SurveyTwoState {
  final List<dynamic> surveyData;
  const SurveyLoaded({required this.surveyData});

  @override
  List<Object> get props => [surveyData];
}

class SurveyError extends SurveyTwoState {}
