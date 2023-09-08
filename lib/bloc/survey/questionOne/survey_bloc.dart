import 'dart:async';
import 'package:alem_application/bloc/survey/answerQuestion/global_manager_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final GlobalManagerBloc globalManagerBloc;

  SurveyBloc({required this.globalManagerBloc}) : super(QuestionInitial());

  Map<int, String> selectedAnswers = {};

  List<int> getSelectedQuestionIds(Map<int, String> selectedAnswers) {
    return selectedAnswers.keys
        .where((key) => selectedAnswers[key] == true)
        .toList();
  }

  List<Map<String, dynamic>> array = [];

  @override
  Stream<SurveyState> mapEventToState(SurveyEvent event) async* {
    if (event is LoadQuestion) {
      yield QuestionLoading();

      // Здесь будет ваш POST запрос.
      final response = await http.post(
        Uri.parse('https://crm.alemagro.com:8080/api/manager/workspace'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "type": "meetingSurvey",
          "action": "getHandBookWorkDone",
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        yield QuestionLoaded(questions: jsonResponse);
      } else {
        yield SurveyError();
      }
    }
    // get the instance
    if (event is AnswerQuestion) {
      final currentState = state as QuestionLoaded;
      final selectedAnswers =
          Map<int, String>.from(currentState.selectedAnswers);

      if (event.answer == true) {
        selectedAnswers[event.questionId] = event.answer.toString();

        // print(selectedAnswers);
        globalManagerBloc.firstAddAnswer(event.questionId, event.name);
      } else {
        selectedAnswers.remove(event.questionId);
        globalManagerBloc.removeFirstAnswer(event.questionId);
        // array.removeWhere((map) => map["id"] == event.questionId);
      }

      bool canMoveToNextPage =
          selectedAnswers.values.any((value) => value == 'true');

      //print(canMoveToNextPage);
      yield QuestionLoaded(
        questions: currentState
            .questions, // используем текущие вопросы из текущего состояния
        selectedAnswers: selectedAnswers,
        canMoveToNextPage: canMoveToNextPage,
      );
    }
    var visitTypeId = await Hive.box<int>('visitTypeIdbox')
        .get('visitTypeId'); // Замените 'someKey' на нужный ключ

    if (state is QuestionLoaded) {
      final currentState = state as QuestionLoaded;
      // Словарь для хранения соответствий между visitTypeId и страницами
      Map<int, int> visitTypeIdMap = {
        64: 4,
        57: 5,
        54: 3,
      };

      Map<int, Map<bool, int>> pageMap = {
        4: {true: 3, false: 2},
        5: {true: 1, false: 3},
        3: {true: 3, false: 2},
      };

      int? mappedVisitTypeId = visitTypeIdMap[visitTypeId];

      if (mappedVisitTypeId != null) {
        bool containsVisitTypeId =
            currentState.selectedAnswers.containsKey(mappedVisitTypeId);
        print(containsVisitTypeId);

        int nextPage = pageMap[mappedVisitTypeId]![containsVisitTypeId] ?? 0;
        yield currentState.copyWith(currentPage: nextPage);
      }
    }
  }
}
