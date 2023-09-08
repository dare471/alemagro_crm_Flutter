import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alem_application/bloc/schedulePayment_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SchedulePaymentPage extends StatefulWidget {
  @override
  _SchedulePaymentPageState createState() => _SchedulePaymentPageState();
}

class _SchedulePaymentPageState extends State<SchedulePaymentPage> {
  Future<void> initializeHive() async {
    await Hive.initFlutter();
    await Hive.openBox('schedulePaymentBox');
  }

  bool isSortedAscending = true;
  bool isSorting = false;

  Future<void> sortPayments(dynamic cachedData) async {
    setState(() {
      isSorting = true; // Устанавливаем флаг сортировки в true
    });

    // Имитация задержки (например, вы можете выполнить сетевой запрос)
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      cachedData.sort((a, b) {
        DateTime dateA = DateTime.parse(a["dateOnSchedule"]);
        DateTime dateB = DateTime.parse(b["dateOnSchedule"]);
        return isSortedAscending
            ? dateA.compareTo(dateB)
            : dateB.compareTo(dateA);
      });
      isSortedAscending = !isSortedAscending;
      isSorting = false; // Сбрасываем флаг сортировки
    });
  }

  Color? determineCardColor(String dateOnScheduleStr) {
    DateTime dateOnSchedule = DateTime.parse(dateOnScheduleStr);
    DateTime currentDate = DateTime.now();
    int difference = dateOnSchedule.difference(currentDate).inDays;

    if (difference <= 3) {
      return Color(0xFFD9933D);
    } else if (difference >= 4 && difference <= 5) {
      return Color(0xFFD9933D);
    } else {
      return Color(0xFF6B936D);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeHive(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text("Ошибка инициализации Hive: ${snapshot.error}"));
        }

        return ValueListenableBuilder(
          valueListenable: Hive.box('schedulePaymentBox').listenable(),
          builder: (context, Box box, _) {
            dynamic cachedData = box.get('data');

            if (cachedData == null) {
              BlocProvider.of<SchedulePaymentBloc>(context)
                  .add(CheckSchedulePaymentEvent());
              return Center(child: CircularProgressIndicator());
            }

            return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 14, 109, 192),
                onPressed: () => sortPayments(cachedData),
                child: Icon(Icons.sort_by_alpha),
              ),
              body: isSorting
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Отображаем индикатор, если идет сортировка
                  : BlocBuilder<SchedulePaymentBloc, SchedulePaymentState>(
                      builder: (context, state) {
                        if (cachedData != null) {
                          return _buildPaymentList(cachedData);
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentList(dynamic cachedData) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          "Оплаты клиентов",
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w300),
          textAlign: TextAlign.start,
        ),
        const Divider(
          height: 10,
          color: Color.fromARGB(255, 0, 113, 199),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cachedData.length,
            itemBuilder: (context, index) {
              final payment = cachedData[index];
              Color? cardColor = determineCardColor(payment["dateOnSchedule"]);
              return Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                elevation: 5.0,
                color: cardColor,
                margin: EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16), // задаём цвет текста
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Договор: ${payment["docNumber"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Divider(
                          height: 20,
                          color: Colors.white,
                          thickness: 0.9,
                        ),
                        const SizedBox(height: 5),
                        Text("Клиент: ${payment["client"]}"),
                        const SizedBox(height: 10),
                        Text(
                            "Статус оплаты: ${payment["payment"] ?? "Не Оплачен"}"),
                        const SizedBox(height: 10),
                        Divider(
                          height: 20,
                          thickness: 0.9,
                          color: Colors.white,
                        ),
                        Row(
                          children: [
                            Text(
                              "Дата оплаты по графику:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${payment["dateOnSchedule"]}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Должен оплатить:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text("${payment["sheduledAmount"]}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                          ],
                        )
                        // ... и так далее для остальных полей
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
