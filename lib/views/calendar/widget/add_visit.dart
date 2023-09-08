import 'package:alem_application/bloc/calendar_bloc/add_visit_bloc/add_visit_bloc.dart';
import 'package:alem_application/bloc/calendar_bloc/add_visit_bloc/add_visit_event.dart';
import 'package:alem_application/bloc/calendar_bloc/add_visit_bloc/add_visit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddVisit extends StatefulWidget {
  @override
  _AddVisitState createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController meeetingPlaceController = TextEditingController();
  final TextEditingController typVisitController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: Locale("ru"),
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF035AA6), // Цвет активных элементов
            colorScheme:
                ColorScheme.light(primary: Color(0xFF035AA6)), // Цвет заголовка
            buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary), // Кнопка "OK/CANCEL"
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
  }

  @override
  void initState() {
    super.initState();
    // Запрашиваем данные для типов визитов и типов встреч
    context.read<AddVisitBloc>().add(FetchTypeVisit());
    context.read<AddVisitBloc>().add(FetchTypeMeeting());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddVisitBloc, AddVisitState>(
      builder: (context, state) {
        List<dynamic> listItems = [];
        List<dynamic> listItemsMeeting = [];
        String? selectedValue;
        String? selectedMeeting;
        DateTime selectedDate = DateTime.now();

        if (state is TypeVisitFetched) {
          listItems = state.listItems;
        }
        if (state is TypeMeetingFetched) {
          listItemsMeeting = state.listItemsMeeting;
        }

        return Material(
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Color(0xFF035AA6),
                  shadowColor: const Color(0xFF035AA6),
                  pinned: true,
                  expandedHeight: 300.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: SizedBox(
                      height: 25,
                      child: Text(
                        'Создать встречу',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/add_visit_wh.png',
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Введите Наименование КХ',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                          onChanged: (String query) {
                            context
                                .read<AddVisitBloc>()
                                .add(FetchSearchClient(query));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Выберите цель встречи',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                          icon: Icon(Icons.arrow_downward),
                          elevation: 16,
                          items: listItems.map((dynamic item) {
                            return DropdownMenuItem<String>(
                              value: item['id'].toString(),
                              child: Text(item['name']),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue;
                            });
                          },
                          value: selectedValue,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Выберите место встречи',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                          ),
                          icon: Icon(Icons.arrow_downward),
                          elevation: 16,
                          items: listItemsMeeting.map((dynamic item) {
                            return DropdownMenuItem<String>(
                              value: item['id'].toString(),
                              child: Text(item['name']),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMeeting = newValue;
                            });
                          },
                          value: selectedMeeting,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () =>
                              _selectDate(context), // Call Function Here
                          child: AbsorbPointer(
                            child: TextField(
                              controller: dateController,
                              decoration: InputDecoration(
                                labelText: 'Дата встречи',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80.0, vertical: 15.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF035AA6)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)))),
                            onPressed: () {},
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.add_circle_outline_sharp),
                                Icon(Icons.person),
                                Text('Выбрать участника',
                                    style: TextStyle(fontSize: 19))
                              ],
                            ),
                          )),
                      Divider(
                        height: 10,
                        color: Colors.blue,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          width: 100, // Укажите желаемую ширину
                          height: 50, // Укажите желаемую высоту
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF035AA6)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)))),
                            onPressed: () {
                              // TODO: Submit Data
                            },
                            child: Text("Сохранить встречу",
                                style: TextStyle(fontSize: 19)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
