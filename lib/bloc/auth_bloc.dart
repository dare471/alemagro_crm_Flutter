// auth_bloc.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

// Событие
abstract class AuthState {}

class InitialAuthState extends AuthState {}

class AuthenticatedState extends AuthState {
  final Map<dynamic, dynamic> data;

  AuthenticatedState(this.data);
}

class ResetAuthEvent extends AuthEvent {}

class AlreadyAuthenticatedState extends AuthState {
  final Map<dynamic, dynamic> data;

  AlreadyAuthenticatedState(this.data);
}

class UnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState(this.error);
}

// Событие
abstract class AuthEvent {}

class UpdateLastOpenedEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class CheckAuthenticationEvent extends AuthEvent {}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> with WidgetsBindingObserver {
  late final Box _tokenBox;
  Timer? _authCheckTimer;

  AuthBloc() : super(InitialAuthState()) {
    _tokenBox = Hive.box('authBox');
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    _authCheckTimer?.cancel();
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is ResetAuthEvent) {
      await _tokenBox.clear();
      yield UnauthenticatedState();
    } else if (event is CheckAuthenticationEvent) {
      var data = _tokenBox.get('data');
      DateTime? lastOpened = _tokenBox.get('lastOpened');

      if (lastOpened == null ||
          DateTime.now().difference(lastOpened) > Duration(seconds: 1400) ||
          data == null) {
        await _tokenBox.clear();
        yield UnauthenticatedState();
      } else {
        yield AlreadyAuthenticatedState(data);
      }
      _tokenBox.put('lastOpened', DateTime.now());
    } else if (event is UpdateLastOpenedEvent) {
      _tokenBox.put('lastOpened', DateTime.now());
    } else if (event is LoginEvent) {
      try {
        final response = await http.post(
          Uri.parse('https://crm.alemagro.com:8080/api/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': event.email, 'password': event.password}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          _tokenBox.put('data', data);
          yield AuthenticatedState(data);
        } else {
          yield AuthErrorState('Ошибка авторизации');
        }
      } catch (e) {
        yield AuthErrorState(e.toString());
      }
    }
  }
}
