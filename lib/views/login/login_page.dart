import 'package:alem_application/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String logoUrl = "assets/logo.png";
  final String backgroundUrl = "assets/background-auth.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with Parallax effect
          Positioned.fill(
            child: Image.asset(
              backgroundUrl,
              fit: BoxFit.cover,
            ),
          ),
          // Adding a color filter to darken the background image
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          // Centered login form
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Login Form
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(228, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(90),
                          bottomRight: Radius.circular(90)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Image.asset(
                              'assets/logo.png',
                              width: 200,
                              height: 50,
                            )
                            // Image.network(
                            //   logoUrl,
                            //   width: 200,
                            //   height: 50,
                            // ),
                            ),
                        Transform.translate(
                          offset: Offset(0, 10),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'example@alemagro.com',
                              labelStyle: TextStyle(color: Color(0xFF00599C)),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(height: 16),
                        Transform.translate(
                          offset: Offset(0, -10),
                          child: TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Пароль',
                              labelStyle: TextStyle(color: Color(0xFF00599C)),
                            ),
                            obscureText: true,
                          ),
                        ),
                        SizedBox(height: 32),
                        BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is AuthenticatedState) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            } else if (state is AuthErrorState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.error)),
                              );
                            }
                          },
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF1D65A6),
                                  ),
                                  icon: Icon(Icons.face),
                                  label: Text('Face ID'),
                                  onPressed: () {
                                    // Здесь ваш код для авторизации через Face ID
                                  },
                                ),
                                SizedBox(width: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF1D65A6),
                                  ),
                                  child: Text('Войти'),
                                  onPressed: () {
                                    context.read<AuthBloc>().add(
                                          LoginEvent(_emailController.text,
                                              _passwordController.text),
                                        );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
