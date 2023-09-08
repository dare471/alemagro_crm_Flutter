import 'package:alem_application/bloc/contact/contact_add_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddContactPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final sizedBox = SizedBox(height: 10);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 0, 113, 199),
            shadowColor: const Color.fromARGB(255, 48, 145, 218),
            pinned: true,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Добавить контакт',
                textAlign: TextAlign.center,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/new_person.png',
                    fit: BoxFit.scaleDown,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        sizedBox,
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                              labelText: 'Имя',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        ),
                        sizedBox,
                        TextFormField(
                          controller: positionController,
                          decoration: const InputDecoration(
                              labelText: 'Должность',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        ),
                        sizedBox,
                        TextFormField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                              labelText: 'Номер телефона',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        ),
                        sizedBox,
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        ),
                        sizedBox,
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(29.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<ContactAddBloc>(context).add(
                                AddContact({
                                  "type": "client",
                                  "action": "setContacts",
                                  "clientId": 2132, // или другой ID
                                  "contactId": 1, // или другой ID
                                  "position": positionController.text,
                                  "name": nameController.text,
                                  "phoneNumber": phoneNumberController.text,
                                  "email": emailController.text,
                                }),
                              );
                            }
                          },
                          child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add),
                                Text('Добавить контакт')
                              ]),
                        ),
                        BlocBuilder<ContactAddBloc, ContactAddState>(
                          builder: (context, state) {
                            if (state is ContactAddLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is ContactAdded) {
                              return const Text('Контакт добавлен');
                            } else if (state is ContactAddError) {
                              return const Text('Произошла ошибка');
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
