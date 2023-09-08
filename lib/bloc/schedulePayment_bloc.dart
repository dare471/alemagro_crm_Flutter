import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

abstract class SchedulePaymentState {}

class ScheduledPaymentState extends SchedulePaymentState {
  final dynamic data; // Используйте динамический тип данных

  ScheduledPaymentState(this.data);
}

class ScheduledPaymentErrorState extends SchedulePaymentState {
  final String error;

  ScheduledPaymentErrorState(this.error);
}

abstract class SchedulePaymentEvent {}

class CheckSchedulePaymentEvent extends SchedulePaymentEvent {}

class SchedulePaymentBloc
    extends Bloc<SchedulePaymentEvent, SchedulePaymentState> {
  late final Box _schedulePaymentData;

  SchedulePaymentBloc() : super(ScheduledPaymentState([])) {
    _schedulePaymentData = Hive.box('schedulePaymentBox');
  }

  @override
  Stream<SchedulePaymentState> mapEventToState(
      SchedulePaymentEvent event) async* {
    if (event is CheckSchedulePaymentEvent) {
      try {
        final response = await http.post(
          Uri.parse('https://crm.alemagro.com:8080/api/user/setting'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'settings': 'getLastPlanPayment', 'userId': 1174}),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          _schedulePaymentData.put('data', data);
          yield ScheduledPaymentState(data);
        } else {
          yield ScheduledPaymentErrorState('Ошибка авторизации');
        }
      } catch (e) {
        yield ScheduledPaymentErrorState(e.toString());
      }
    }
  }
}
