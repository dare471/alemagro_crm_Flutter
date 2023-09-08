import 'dart:convert';
import 'package:alem_application/models/client_search_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientEvent {
  final String query;
  ClientEvent(this.query);
}

abstract class ClientState {}

class ClientLoading extends ClientState {}

class ClientLoaded extends ClientState {
  final List<Client> clients;
  ClientLoaded(this.clients);
}

class ClientError extends ClientState {
  final String message;
  ClientError(this.message);
}

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  ClientBloc()
      : super(ClientLoading()); // Изначальное состояние теперь ClientLoading

  @override
  Stream<ClientState> mapEventToState(ClientEvent event) async* {
    yield ClientLoading();
    if (event.query.isNotEmpty) {
      final response = await http.post(
        Uri.parse('https://crm.alemagro.com:8080/api/manager/workspace'),
        body: jsonEncode({
          "type": "searchClient",
          "clientName": event.query, // используем query из события
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<Client> clients = (jsonDecode(response.body) as List)
            .map((clientJson) => Client.fromJson(clientJson))
            .toList();
        print(clients.toList());
        yield ClientLoaded(clients);
      } else {
        yield ClientError("Some error message");
      }
    }
  }
}
