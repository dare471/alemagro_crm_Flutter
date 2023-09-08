import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// Events
abstract class ContactEvent {}

class AddContact extends ContactEvent {
  final Map<String, dynamic> contactInfo;

  AddContact(this.contactInfo);
}

// States
abstract class ContactAddState {}

class ContactInitial extends ContactAddState {}

class ContactAddLoading extends ContactAddState {}

class ContactAdded extends ContactAddState {}

class ContactAddError extends ContactAddState {}

// BLoC
class ContactAddBloc extends Bloc<ContactEvent, ContactAddState> {
  final String baseUrl = 'https://crm.alemagro.com:8080';

  ContactAddBloc() : super(ContactInitial());

  @override
  Stream<ContactAddState> mapEventToState(ContactEvent event) async* {
    if (event is AddContact) {
      yield ContactAddLoading();
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/api/client'),
          body: jsonEncode(event.contactInfo),
          headers: {"Content-Type": "application/json"},
        );

        if (response.statusCode == 200) {
          yield ContactAdded();
        } else {
          yield ContactAddLoading();
        }
      } catch (e) {
        yield ContactAddError();
      }
    }
  }
}
