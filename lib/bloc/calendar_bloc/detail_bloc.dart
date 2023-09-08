import 'package:alem_application/models/detail_meeting.dart';
import 'package:alem_application/views/calendar/detail_meeting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class CardEvent {}

class CardClicked extends CardEvent {
  final int id;
  bool navigate;
  CardClicked({required this.id, required this.navigate});
}

// Необходимо определить абстрактное состояние CardState
abstract class CardState {}

class InitialState extends CardState {} // Начальное состояние

// Добавляем новое состояние для представления успешного получения данных
class DataFetched extends CardState {
  final Data data; // Здесь Data вместо DetailMeeting

  DataFetched({required this.data});
}

class NavigateToDataDisplay extends CardEvent {
  final Data data;

  NavigateToDataDisplay({required this.data});
}

class CardBloc extends Bloc<CardEvent, CardState> {
  final BuildContext context; // Добавляем поле для контекста

  CardBloc(this.context) : super(InitialState());

  void navigateToDataDisplay(Data data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value:
              this, // Используем поле this для передачи текущего объекта Bloc
          child: DataDisplay(
            data: data,
          ),
        ),
      ),
    );
  }

  Future<void> navigateToDataDisplayWithProgress(Data data) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //    CircularProgressIndicator(),
              SizedBox(height: 16.0),
              Divider(
                height: 10,
                color: Colors.blue,
              ),
              Text(
                "Загружаем встречу...",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );

    // Используйте неблокирующую задержку для имитации загрузки данных
    await Future.delayed(Duration(seconds: 1));

    Navigator.pop(context); // Закрываем диалоговое окно

    navigateToDataDisplay(data); // Переход к DataDisplay
  }

  @override
  Stream<CardState> mapEventToState(CardEvent event) async* {
    if (event is CardClicked) {
      try {
        final response = await http.post(
          Uri.parse('https://crm.alemagro.com:8080/api/planned/mobile'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'type': 'plannedMeeting',
            'action': 'getMeetingDetail',
            'visitId': event.id,
          }),
        );
        if (response.statusCode == 200) {
          final DetailMeeting apiResponse =
              DetailMeeting.fromJson(json.decode(response.body));
          yield DataFetched(data: apiResponse.data);

          if (event.navigate == true) {
            navigateToDataDisplay(apiResponse.data);
          } else {
            print("refresh indicator succes");
          } // Здесь не вызываем navigateToDataDisplay, только обновляем состояние
        } else {
          print("failed http query");
        }
      } catch (e) {
        print("An error occurred: $e");
      }
    }
    if (event is NavigateToDataDisplay) {
      navigateToDataDisplay(event.data);
    }
  }
}
