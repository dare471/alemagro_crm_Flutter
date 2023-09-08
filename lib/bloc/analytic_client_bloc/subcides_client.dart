import 'dart:async';
import 'dart:convert';
import 'package:alem_application/models/subcides_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

part 'subcide_state.dart';
part 'subcides_event.dart';

class SubcidesListBloc extends Bloc<SubcidesEvent, SubcidesListState> {
  SubcidesListBloc() : super(SubcidesInitial());

  @override
  Stream<SubcidesListState> mapEventToState(SubcidesEvent event) async* {
    if (event is SubcidesFetched) {
      // SubcidesFetched должно быть событием из вашего BLoC
      try {
        List<SeasonData> subcidesData = await fetchMeetingsFromAPI();
        // print(subcidesData);
        yield SubcidesFetchedState(
            subcidesData); // Используйте ваше состояние здесь
      } catch (e) {
        yield SubcidesFetchFailed(e.toString());
      }
    }
  }

  Future<List<SeasonData>> fetchMeetingsFromAPI() async {
    const url = 'https://crm.alemagro.com:8080/api/client';
    final body = jsonEncode({
      "type": "client",
      "action": "getSubscidesList",
      "clientId": 2191,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      //print(response.body);
      return jsonResponse.map((json) => SeasonData.fromJson(json)).toList();
    } else {
      print("Failed to load meetings, status code: ${response.statusCode}");
      throw Exception(
          "Failed to load meetings, status code: ${response.statusCode}");
    }
  }
}
