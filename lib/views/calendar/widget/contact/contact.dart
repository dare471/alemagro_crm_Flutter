import 'package:alem_application/bloc/contact/contact_add_bloc.dart';
import 'package:alem_application/bloc/contact/contact_bloc.dart';
import 'package:alem_application/bloc/event/contact_event.dart';
import 'package:alem_application/bloc/state/contact_state.dart';
import 'package:alem_application/views/calendar/widget/contact/contact_add.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final ContactBloc _contactBloc = ContactBloc();

  @override
  void initState() {
    super.initState();
    _contactBloc.add(GetContact(2191));
  }

  Future<void> _launchUrl(number) async {
    launch("${number}");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _contactBloc,
      child: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          if (state is ContactLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactLoaded) {
            return Column(children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.contacts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      elevation: 5.0,
                      color: Color.fromARGB(255, 0, 113, 199),
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: const EdgeInsets.all(
                            25.0), // Вы можете изменить значение отступа
                        child: DefaultTextStyle(
                          style: TextStyle(color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ФИО: ${state.contacts[index].name}"),
                                  Text(
                                      "Должность: ${state.contacts[index].position}"),
                                  Text(
                                      "Телефон: ${state.contacts[index].phNumber}"),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  _launchUrl(state.contacts[index].phNumber);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.call),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 0, 113, 199)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => ContactAddBloc(),
                        child: AddContactPage(),
                      ), // Здесь должен быть ваш экран, который использует FileSliverAppBar
                    ),
                  );
                },
                child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.add), Text("Добавить участника")]),
              )
            ]);
          } else if (state is ContactError) {
            return Text("Error: ${state.message}");
          } else {
            return Text("Unknown state");
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _contactBloc.close();
    super.dispose();
  }
}
