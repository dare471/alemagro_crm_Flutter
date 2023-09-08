import 'dart:ui';

import 'package:alem_application/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:alem_application/models/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart'; // Не забудьте импортировать эту библиотеку

class MainInfoUser extends StatefulWidget {
  _mainInfoUser createState() => _mainInfoUser();
}

class _mainInfoUser extends State<MainInfoUser> {
  final authData = Hive.box('authBox').get('data');
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Color(0xFF035AA6),
              elevation: 4.2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DefaultTextStyle(
                  style: TextStyle(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .stretch, // чтобы дочерние элементы тянулись на всю доступную ширину
                    children: [
                      Text("Добро пожаловать!"),
                      Text(authData['user']['name'].toString(),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(authData['user']['email'].toString(),
                          style: TextStyle(fontSize: 16)),
                      // Text('+1234567890', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(3),
              child: Column(
                children: [
                  const Divider(height: 10, thickness: 1),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Показатели",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  // Metrics Block
                  Card(
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          MetricItem(
                              title: "100", value: "Выполнено", blocId: 1),
                          MetricItem(title: "200", value: "План", blocId: 2),
                          MetricItem(
                              title: "50%", value: "Прогресс", blocId: 3),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(height: 10, thickness: 1),
                  const SizedBox(height: 10),
                  // To-Do List
                  BlocBuilder<CalendarBloc, CalendarState>(
                      builder: (context, state) {
                    if (state is MeetingsFetched) {
                      return Column(
                        children: [
                          const Text(
                            "Ваши визиты",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Card(
                            elevation: 10,
                            shadowColor: Color.fromARGB(176, 3, 90, 166),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListView.builder(
                              shrinkWrap:
                                  true, // чтобы ListView имел определенную высоту
                              itemCount: state.meetings
                                  .length, // Количество элементов в списке
                              itemBuilder: (context, index) {
                                Meeting meeting = state.meetings[
                                    index]; // Получаем объект Meeting из списка
                                return ListTile(
                                  title: Text(meeting
                                      .clientName), // Используем свойства объекта Meeting
                                  subtitle: Text(DateFormat('yMMMd', 'ru_RU')
                                      .format(meeting.date)),
                                  leading: Icon(
                                    Icons.date_range,
                                    size: 32,
                                    color: Color(0xFF035AA6),
                                  ),
                                  trailing: meeting.statusVisit
                                      ? Icon(Icons.check_circle,
                                          color: Color(0xFF5D8E77))
                                      : Icon(Icons.remove_circle_outlined,
                                          color: Colors.red[700]),
                                );
                              },
                            ),
                          )
                        ],
                      );
                    } else if (state is MeetingsFetchFailed) {
                      return Text(state.error);
                    } else {
                      // ignore: avoid_unnecessary_containers
                      return Container(
                          padding: EdgeInsets.all(10),
                          child:
                              const Center(child: CircularProgressIndicator()));
                    }
                    // return const Center(child: CircularProgressIndicator());
                  }),
                ],
              ),
            ),

            //Блюр о скором релизе
            // BackdropFilter(
            //   filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            //   child:
            // Container(
            //   color: Colors
            //       .transparent, // Это нужно, чтобы увидеть размытый эффект
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Divider(
            //         color: Colors.grey,
            //         height: 20,
            //         thickness: 1,
            //       ),
            //       Container(
            //         child: Text(
            //           "Данный раздел станет доступен скоро",
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontWeight: FontWeight.w500,
            //               fontSize: 18),
            //         ),
            //         padding: EdgeInsets.all(20),
            //         decoration: BoxDecoration(
            //             color: Color(0xFFD9933D),
            //             borderRadius: BorderRadius.circular(20)),
            //       )
            //     ],
            //   ),
            // ),
            //  ),
          ],
        ),
      ),
    );
  }
}

class MetricItem extends StatelessWidget {
  final String title;
  final String value;
  final int blocId;

  MetricItem({required this.title, required this.value, required this.blocId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            backgroundColor: blocId == 1
                ? Color(0xFFD9933D)
                : (blocId == 2 ? Color(0xFFF2C879) : Color(0xFF035AA6)),
            radius: 50,
            child: Text(title,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))),
        const SizedBox(
          height: 10,
        ),
        Text(value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
