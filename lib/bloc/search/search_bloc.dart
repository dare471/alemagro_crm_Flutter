import 'dart:convert';
import 'package:alem_application/bloc/search/search_event.dart';
import 'package:alem_application/bloc/search/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class MyClientBloc extends Bloc<MyClientEvent, MyClientState> {
  MyClientBloc() : super(MyClientInitial());

  @override
  Stream<MyClientState> mapEventToState(MyClientEvent event) async* {
    if (event is SearchClientEvent) {
      yield MyClientLoading();

      final response = await http.post(
        Uri.parse('https://crm.alemagro.com:8080/api/manager/workspace'),
        body: jsonEncode({'type': 'searchClient', 'clientName': event.query}),
      );

      if (response.statusCode == 200) {
        final List clients = jsonDecode(response.body);
        yield MyClientLoaded(
            clients.map((e) => e as Map<String, dynamic>).toList());
      } else {
        yield MyClientError("An error occurred while fetching data");
      }
    }
  }
}
