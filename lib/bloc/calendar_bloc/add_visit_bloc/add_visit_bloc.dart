import 'dart:convert';
import 'package:alem_application/views/calendar/widget/add_visit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_visit_event.dart';
import 'add_visit_state.dart';

class AddVisitBloc extends Bloc<AddVisitEvent, AddVisitState> {
  AddVisitBloc() : super(AddVisitInitial());

  Future<List<dynamic>> fetchDataMeeting() async {
    final response = await http.post(
      Uri.parse('https://crm.alemagro.com:8080/api/workspace/mobile'),
      body: jsonEncode({
        "type": "handBook",
        "action": "getHandbook",
        "target": "sprTypeMeeting"
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<List<dynamic>> fetchDataVisit() async {
    final response = await http.post(
      Uri.parse('https://crm.alemagro.com:8080/api/workspace/mobile'),
      body: jsonEncode({
        "type": "handBook",
        "action": "getHandbook",
        "target":
            "sprTypeVisit" // Отличие может быть здесь, если это другой тип данных
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch data for visit types');
    }
  }

  Future<List<dynamic>> fetchSearchClient(query) async {
    final response = await http.post(
      Uri.parse('https://crm.alemagro.com:8080/api/workspace/mobile'),
      body: jsonEncode({"type": "searchClient", "clientName": query.name}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch name for search');
    }
  }

  @override
  Stream<AddVisitState> mapEventToState(AddVisitEvent event) async* {
    if (event is FetchTypeVisit) {
      try {
        List<dynamic> data = await fetchDataVisit();
        yield TypeVisitFetched(data);
      } catch (e) {
        yield AddVisitError(e.toString());
      }
    } else if (event is FetchTypeMeeting) {
      try {
        List<dynamic> data = await fetchDataMeeting();
        yield TypeMeetingFetched(data);
      } catch (e) {
        yield AddVisitError(e.toString());
      }
    } else if (event is FetchSearchClient) {
      try {
        List<dynamic> data = await fetchSearchClient(event.query);
        yield SearchClientFetched(data);
      } catch (e) {
        yield AddVisitError(e.toString());
      }
    }
    if (event is NavigateToAddVisit) {
      yield NavigateToAddVisitState();
    }
  }
}
