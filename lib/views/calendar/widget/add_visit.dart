import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddVisit extends StatefulWidget {
  @override
  _AddVisitState createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController meeetingPlaceController = TextEditingController();
  final TextEditingController typVisitController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  List<dynamic> listItems = [];
  List<dynamic> listItemsMeeting = [];
  String? selectedValue;
  String? selectedMeeting;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDataMeeting();
  }

  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
  }

  fetchData() async {
    final response = await http.post(
      Uri.parse('https://crm.alemagro.com:8080/api/workspace/mobile'),
      body: jsonEncode({
        "type": "handBook",
        "action": "getHandbook",
        "target": "sprTypeVisit"
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        listItems = data;
      });
    }
  }

  fetchDataMeeting() async {
    final response = await http.post(
      Uri.parse('https://crm.alemagro.com:8080/api/workspace/mobile'),
      body: jsonEncode({
        "type": "handBook",
        "action": "getHandbook",
        "target": "sprTypeMeeting"
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var datam = jsonDecode(response.body);
      setState(() {
        listItemsMeeting = datam;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Color.fromARGB(255, 115, 184, 237),
              shadowColor: const Color.fromARGB(255, 48, 145, 218),
              pinned: true,
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Создание встречи',
                  textAlign: TextAlign.center,
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/add_visit.png',
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
                      controller: typVisitController,
                      decoration: const InputDecoration(
                        labelText: 'БИН/Наименование',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Выберите цель встречи',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Выберите место встречи',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () => _selectDate(context), // Call Function Here
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dateController,
                          decoration: InputDecoration(
                            labelText: 'Дата встречи',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
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
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
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
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
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
  }
}
