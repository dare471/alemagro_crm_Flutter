import 'package:alem_application/bloc/calendar_bloc/add_visit_bloc/add_visit_bloc.dart';
import 'package:alem_application/bloc/survey/answerQuestion/global_manager_bloc.dart';
import 'package:alem_application/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bloc/auth_bloc.dart';
import 'views/login/login_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('authBox');
  await Hive.openBox<int>('visitIdBox');
  await Hive.openBox('clientDataBox');
  final authBloc = AuthBloc();
  final GlobalManagerBloc globalManagerBloc = GlobalManagerBloc();

  initializeDateFormatting('ru_RU', null).then((_) => runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => globalManagerBloc),
            BlocProvider<AddVisitBloc>(
                create: (BuildContext context) => AddVisitBloc()),
            BlocProvider(
                create: (context) => authBloc..add(CheckAuthenticationEvent())),
          ],
          child: MyApp(),
        ),
      ));
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ru', ''),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Авторизация',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AlreadyAuthenticatedState ||
              state is AuthenticatedState) {
            return HomePage();
          } else if (state is UnauthenticatedState || state is AuthErrorState) {
            return LoginPage();
          } else {
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 40,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    "Oops! Вы не авторизованы",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    "Упс, OOOPS, ОЙ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      // Действие для повторной попытки, если необходимо
                    },
                    child: const Text(
                      "Retry",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
