import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class GlobalManagerBloc extends Cubit<Map<String, dynamic>> {
  GlobalManagerBloc()
      : super({
          "workDone": [],
          "fieldInspection": [],
          "difficulties": {},
          "recomendation": []
        });

  void firstAddAnswer(int questionId, String name) {
    var newArray = List<Map<String, dynamic>>.from(state["workDone"] as List);
    newArray.add({"id": questionId, "name": name});

    var newState = Map<String, dynamic>.from(state);
    newState["workDone"] = newArray;
    //print(state);
    emit(newState);
  }

  void removeFirstAnswer(int questionId) {
    var newArray = List<Map<String, dynamic>>.from(state["workDone"] as List);
    newArray.removeWhere((map) => map["id"] == questionId);
    var newState = Map<String, dynamic>.from(state);
    newState["workDone"] = newArray;
    // print(state);
    emit(newState);
  }

  void addCulture(List<Map<String, dynamic>> newCultures) {
    List<Map<String, dynamic>> newCulturesArray;

    if (state["fieldInspection"] == null ||
        (state["fieldInspection"] as List).isEmpty) {
      newCulturesArray = [];
    } else {
      newCulturesArray =
          List<Map<String, dynamic>>.from(state["fieldInspection"] as List);
    }

    newCulturesArray.addAll(newCultures);

    var newState = Map<String, dynamic>.from(state);
    newState["fieldInspection"] = newCulturesArray;
    print(state);
    emit(newState);
  }

  void removeCulture(int cultureId) {
    var newCulturesArray = List<Map<String, dynamic>>.from(
        state["fieldInspection"] as List); // Изменен ключ на "fieldInspection"
    newCulturesArray.removeWhere((item) => item['id'] == cultureId);

    var newState = Map<String, dynamic>.from(state);
    newState["fieldInspection"] =
        newCulturesArray; // Изменен ключ на "fieldInspection"

    emit(newState);
  }

  //
  void addDifficulties(List<Map<String, dynamic>> newDifficulties) {
    //  print(newDifficulties);
    state["difficulties"] = newDifficulties;
    print(state);
  }

  void removeDifficulties(int cultureId) {
    var newCulturesArray = List<Map<String, dynamic>>.from(
        state["fieldInspection"] as List); // Изменен ключ на "fieldInspection"
    newCulturesArray.removeWhere((item) => item['id'] == cultureId);

    var newState = Map<String, dynamic>.from(state);
    newState["fieldInspection"] =
        newCulturesArray; // Изменен ключ на "fieldInspection"

    emit(newState);
  }

  void addRecomendation(Set<int> newDifficulties) {
    // Преобразуем Set<int> в Map<String, dynamic>
    Map<String, dynamic> oldRecommendation = {};
    int index = 1; // Или начать с 0, если необходимо
    for (int difficulty in newDifficulties) {
      oldRecommendation[index.toString()] = difficulty;
      index++;
    }

    // Применяем функцию трансформации
    Map<String, dynamic> transformedRecommendation =
        transformRecommendation(oldRecommendation);
    // Добавляем в состояние
    state["recomendation"] = transformedRecommendation;
    print(state);
  }

  Map<String, dynamic> transformRecommendation(
      Map<String, dynamic> oldRecommendation) {
    return {
      'recommendation': {
        'visit': {
          'name': 'Была ли агроконсультация ?',
          'answer': oldRecommendation['1'] ?? 0,
          'description': ''
        },
        'product': {
          'name': 'Были ли рекомендованы товары?',
          'answer': oldRecommendation['2'] ?? 0,
          //  'hardStages': 1,
          'description': ''
        },
        'arrangement': {
          'name': 'Были ли договоренности с клиентом',
          'answer': oldRecommendation['3'] ?? 0,
          'description': ''
        },
      }
    };
  }

  void removeRecomendation(String recomendationid) {
    // Проверим, существует ли 'recomendation' в состоянии
    if (state.containsKey("recomendation")) {
      Map<String, dynamic> recomendation = state["recomendation"];
      if (recomendation.containsKey(recomendationid)) {
        recomendation
            .remove(recomendationid); // Удаляем ключ и связанное с ним значение
      }
    }
    print(state);
    emit(state);
  }

  void sendApi() {
    final Map<String, dynamic> data = {
      "type": "plannedMeeting",
      "action": "storeMeetingResult",
      "visitId": Hive.box<int>('visitIdBox').get('visitId'),
      "result": state // ... и так далее
    };
    // Вызываете функцию sendPostRequest
    sendPostRequest(data);
  }

  Future<void> sendPostRequest(Map<String, dynamic> data) async {
    final String url = "https://crm.alemagro.com:8080/api/planned/mobile";

    final headers = {
      "Content-Type": "application/json",
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Успешный запрос
        print("Success: ${response.body}");
      } else {
        // Если сервер отвечает с кодом статуса, отличным от 2xx, бросаем ошибку
        print("Failed: ${response.body}");
      }
    } catch (e) {
      // Обработка ошибки сети
      print("Network error: $e");
    }
  }
}
