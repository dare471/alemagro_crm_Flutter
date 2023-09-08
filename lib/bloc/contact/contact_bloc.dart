import 'dart:convert';
import 'package:alem_application/bloc/event/contact_event.dart';
import 'package:alem_application/bloc/state/contact_state.dart';
import 'package:alem_application/models/contact_model.dart' as contactModel;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactInitial());

  @override
  Stream<ContactState> mapEventToState(ContactEvent event) async* {
    if (event is GetContact) {
      yield ContactLoading();

      final response = await http.post(
        Uri.parse("https://crm.alemagro.com:8080/api/client"),
        headers: {
          "Content-Type": "application/json"
        }, // если сервер требует этот заголовок
        body: jsonEncode({
          "type": "client",
          "action": "getContact",
          "clientId": event.clientId,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final contacts = jsonResponse
            .map((dynamic item) => contactModel.Contact.fromJson(item))
            .toList();

        yield ContactLoaded(contacts);
      } else {
        yield ContactError("Failed to load contacts");
      }
    }
  }
}
