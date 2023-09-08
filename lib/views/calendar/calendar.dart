import 'package:alem_application/bloc/calendar_bloc/add_visit_bloc/add_visit_bloc.dart';
import 'package:alem_application/bloc/calendar_bloc/add_visit_bloc/add_visit_event.dart';
import 'package:alem_application/bloc/calendar_bloc/add_visit_bloc/add_visit_state.dart';
import 'package:alem_application/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:alem_application/bloc/calendar_bloc/detail_bloc.dart';
import 'package:alem_application/models/calendar.dart';
import 'package:alem_application/views/calendar/widget/add_visit.dart';
import 'package:alem_application/views/calendar/widget/calendar_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Meeting> selectedEvents = [];

  void _addVisit() {
    context.read<AddVisitBloc>().add(NavigateToAddVisit());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state is MeetingsFetched) {
          Map<DateTime, List<Meeting>> events = {};

          for (var meeting in state.meetings) {
            final date = DateTime.utc(
                meeting.date.year, meeting.date.month, meeting.date.day);
            events.putIfAbsent(date, () => []).add(meeting);
          }
          selectedEvents = events[_selectedDay] ?? [];

          return BlocListener<AddVisitBloc, AddVisitState>(
            listener: (context, addVisitState) {
              if (addVisitState is NavigateToAddVisitState) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddVisit(),
                ));
              }
            },
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xFF035AA6),
                hoverElevation: 50,
                onPressed: () => _addVisit(),
                child: Icon(Icons.add),
              ),
              body: Column(
                children: [
                  TableCalendar(
                    weekNumbersVisible: true,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    locale: 'ru_RU',
                    rangeSelectionMode: RangeSelectionMode.toggledOn,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Просмотр месяц',
                      CalendarFormat.twoWeeks: 'Просмотр 2 недель',
                      CalendarFormat.week: 'Просмотр недельный'
                    },
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: true,
                      titleCentered: true,
                    ),
                    calendarStyle: CalendarStyle(
                      markerSize: 10,
                      markerDecoration: BoxDecoration(shape: BoxShape.circle),
                      todayDecoration: BoxDecoration(
                          color: Color(0xFFD9933D).withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 10, color: Colors.white.withOpacity(0.1))),
                      selectedDecoration: BoxDecoration(
                        color: Color(0xFF035AA6).withOpacity(
                            0.9), // Здесь установлен цвет выбранного дня
                        shape: BoxShape.circle,
                      ),
                      weekendDecoration: BoxDecoration(
                        color: Color.fromARGB(62, 118, 184, 241).withOpacity(
                            0.3), // Здесь установлен цвет выбранного дня
                        shape: BoxShape.circle,
                      ),
                    ),
                    firstDay: DateTime.utc(2023, 1, 1),
                    lastDay: DateTime.utc(2023, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    eventLoader: (day) {
                      return events[
                              DateTime.utc(day.year, day.month, day.day)] ??
                          [];
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (events.isNotEmpty) {
                          return const Positioned(
                            top: 25,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.arrow_drop_up_outlined,
                                  color: Color.fromARGB(255, 52, 149, 50),
                                  size: 40,
                                ),
                                // Container(
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.only(
                                //         topLeft: Radius.elliptical(27, 27),
                                //         topRight: Radius.elliptical(27, 22),
                                //         bottomLeft: Radius.elliptical(27, 27),
                                //         bottomRight: Radius.elliptical(27, 27)),
                                //     shape: BoxShape.rectangle,
                                //     color: Color.fromARGB(255, 52, 149, 50)
                                //         .withOpacity(1),
                                //   ),
                                //   width: 30,
                                //   height: 6,
                                // ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: const Color(0xFF035AA6)),
                    child: Column(
                      children: [
                        Text(
                          'Встречи на ${DateFormat('MMMMd', 'ru_RU').format(_selectedDay)}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.circle,
                        color: Color(0xFF6B936D),
                      ),
                      Text(
                        'Завершенная встреча',
                        style: TextStyle(color: Colors.black),
                      ),
                      Icon(
                        Icons.circle,
                        color: Colors.red[700],
                      ),
                      Text(
                        'Незавершенная встреча',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3.0),
                  BlocProvider(
                    create: (context) => CardBloc(context),
                    child: CalendarCard(
                      selectedEvents: selectedEvents,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
