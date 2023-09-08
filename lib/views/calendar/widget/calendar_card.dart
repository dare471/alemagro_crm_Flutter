import 'package:alem_application/bloc/calendar_bloc/detail_bloc.dart';
import 'package:alem_application/models/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Не забудьте импортировать эту библиотеку

class CalendarCard extends StatefulWidget {
  final List<Meeting> selectedEvents;

  CalendarCard({required this.selectedEvents});

  @override
  _CalendarCardState createState() => _CalendarCardState();
}

class _CalendarCardState extends State<CalendarCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.selectedEvents.isEmpty // Проверка на пустой список
          ? const Center(
              child: Text(
                "В данный день отсутствуют встречи",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w200),
              ),
            )
          : ListView.builder(
              itemCount: widget.selectedEvents.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // print(widget.selectedEvents[index].id);
                    context.read<CardBloc>().add(
                          CardClicked(
                              id: widget.selectedEvents[index].id,
                              navigate: true),
                        );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20.0), // Задаем скругленные углы здесь
                    ),
                    elevation: 5.0,
                    color: widget.selectedEvents[index].statusVisit
                        ? Color(0xFF6B936D)
                        : Colors.red[700],
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: buildCardContent(widget.selectedEvents[index]),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Column buildCardContent(Meeting event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildEventText(event.clientName, 18.0, FontWeight.bold),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildEventText(event.targetDescription, 14.0, FontWeight.normal),
            buildEventText(
              DateFormat('yMMMd', 'ru_RU').format(event.date),
              14.0,
              FontWeight.normal,
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        const Divider(height: 10, color: Colors.white),
        const SizedBox(height: 4.0),
        buildEventText(event.clientAddress, 14.0, FontWeight.bold),
      ],
    );
  }

  Text buildEventText(String text, double fontSize, FontWeight fontWeight) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
