import 'package:alem_application/bloc/upload/record_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: use_key_in_widget_constructors
class MyBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecorderCubit(),
      child: MyBottomBar(),
    );
  }
}

// ignore: must_be_immutable
class MyBottomBar extends StatelessWidget {
  int _selectedIndex = 1;

  void _onItemTapped(BuildContext context, int index) async {
    final cubit = context.read<RecorderCubit>();
    if (index == 2) {
      if (cubit.state.status == RecorderStatus.recording) {
        await cubit.stopRecording();
      } else {
        await cubit.initRecorder();
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (dialogContext) {
            return BlocProvider.value(
              value: BlocProvider.of<RecorderCubit>(context),
              child: BlocBuilder<RecorderCubit, RecorderState>(
                builder: (context, state) {
                  return AlertDialog(
                    title: const Text('Запись идет'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Запись идёт: ${state.recordingTime} секунды'),
                        const SizedBox(height: 20),
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          width: 50 + (state.recordingTime % 20).toDouble(),
                          height: 50 + (state.recordingTime % 20).toDouble(),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                  Size(150, 50)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xFF035AA6))),
                          onPressed: () async {
                            await cubit.stopRecording();
                            Navigator.pop(context);
                          },
                          child: const Text('Остановить и отправить'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      }
    } else if (index == 1) {
      await cubit.pickMultipleImages();
    } else if (index == 0) {
      await cubit.pickSingleImage();
    }
    _selectedIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecorderCubit, RecorderState>(
      builder: (context, state) {
        return BottomNavigationBar(
          selectedFontSize: 15,
          unselectedFontSize: 12,
          iconSize: 26.0,
          selectedIconTheme: IconThemeData(
            size: 32,
            color: Color.fromARGB(255, 14, 109, 192),
          ),
          unselectedIconTheme: IconThemeData(size: 28),
          backgroundColor: Colors.white,
          selectedItemColor: Color.fromARGB(255, 14, 109, 192),
          unselectedItemColor: Color.fromARGB(255, 95, 128, 157),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.camera, color: Color(0xFF035AA6)),
              label: 'Камера',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.perm_media_outlined, color: Color(0xFF035AA6)),
              label: 'Галерея',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mic_rounded, color: Color(0xFF035AA6)),
              label: 'Запись',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) => _onItemTapped(context, index),
        );
      },
    );
  }
}
