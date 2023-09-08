//survey_bloc
import 'dart:async';
import 'dart:convert';
import 'package:alem_application/bloc/survey/answerQuestion/global_manager_bloc.dart';
import 'package:alem_application/views/calendar/widget/survey/QuestionTwo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyTwoBloc extends Bloc<SurveyTwoEvent, SurveyTwoState> {
  final GlobalManagerBloc globalManagerBloc;

  SurveyTwoBloc({required this.globalManagerBloc}) : super(SurveyTwoInitial());

  Set<int> selectedComplicationIds = {};
  List<SurveyData> surveyDataList = []; // Это ваш "массив"
  @override
  Stream<SurveyTwoState> mapEventToState(SurveyTwoEvent event) async* {
    if (event is LoadTwoQuestions) {
      yield SurveyLoading();

      final response = await http.post(
        Uri.parse('https://crm.alemagro.com:8080/api/manager/workspace'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "type": "meetingSurvey",
          "action": "getHandBookFieldInsp",
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        yield SurveyLoaded(surveyData: jsonResponse);
      } else {
        yield SurveyError();
      }
    }
    if (event is AnswerQuestion) {
      surveyDataList.add(event.surveyData); // Добавляем новые данные в "массив"
      List<Map<String, dynamic>> convertedList =
          surveyDataList.map((surveyData) => surveyData.toJson()).toList();
      for (var surveyData in surveyDataList) {
        globalManagerBloc.addCulture([surveyData.toJson()]);
      }
    }
  }
}
