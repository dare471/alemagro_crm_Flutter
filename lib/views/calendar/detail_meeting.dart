import 'package:alem_application/bloc/calendar_bloc/detail_bloc.dart'; // Предположим, что CardBloc импортирован из этого файла
import 'package:alem_application/bloc/calendar_bloc/icon_cubit.dart';
import 'package:alem_application/bloc/upload/record_bloc.dart';
import 'package:alem_application/models/detail_meeting.dart';
import 'package:alem_application/views/calendar/widget/analytic/catalog.dart';
import 'package:alem_application/views/calendar/widget/bottomNavigationBar/main_widget.dart';
import 'package:alem_application/views/calendar/widget/fields_client.dart';
import 'package:alem_application/views/calendar/widget/file_client.dart';
import 'package:alem_application/views/calendar/widget/survey/GeneratePdf.dart';
import 'package:alem_application/views/calendar/widget/survey/survey_meeting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widget/contact/contact.dart';

class DataDisplay extends StatelessWidget {
  final Data data;
  final TextStyle commonTextStyle = const TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.normal,
  );
  // ignore: use_key_in_widget_constructors
  const DataDisplay({required this.data});

  Widget buildCardSection(
      String title, String statusVisit, List<Widget> children) {
    return Card(
      color: const Color(0xFF035AA6),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15), // Здесь можете указать нужный радиус
      ),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Эта строка устанавливает минимальную высоту
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children
                .map((widget) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: DefaultTextStyle.merge(
                        style: commonTextStyle,
                        child: widget,
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlayPauseCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(data.clientName),
          backgroundColor: Color(0xFF035AA6),
          actions: [
            if (data.statusVisit ==
                false) // Проверьте условие, при котором кнопка должна отображаться
              BlocBuilder<PlayPauseCubit, PlayPauseState>(
                builder: (context, state) {
                  return IconButton(
                    icon: Icon(
                      state.isPaused
                          ? Icons.play_circle_outline_outlined
                          : Icons.stop_circle_outlined,
                      size: 35,
                    ),
                    onPressed: () {
                      context.read<PlayPauseCubit>().togglePlayPause(data
                          .visitId); // data.visitId или другой идентификатор визита
                    },
                  );
                },
              ),
          ],
        ),
        body: BlocListener<PlayPauseCubit, PlayPauseState>(
          listener: (context, state) {
            if (state.isPaused && state.pauseTime != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SurveyScreen(
                          visitId: data.visitId,
                          visitTypeId: data.visitTypeId,
                        )),
              );
            }
          },
          child: BlocBuilder<CardBloc, CardState>(
            builder: (context, state) {
              if (state is DataFetched) {
                Data data = state.data;
                return RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<CardBloc>()
                        .add(CardClicked(id: data.visitId, navigate: false));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: [
                        data.statusVisit
                            ? Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFF6B936D),
                                ),
                                child: const Text(
                                  'Данная встреча завершена.',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ) // или замените на другой виджет, который должен отображаться, если условие не выполняется
                                )
                            : Container(),
                        buildCardSection(
                          "Информация о клиенте",
                          "${data.statusVisit}",
                          [
                            //  Text('Client ID: ${data.clientId}'),
                            const Divider(height: 4, color: Colors.white),
                            Text(
                              data.clientName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text('БИН/ИИН: ${data.clientIin}'),
                            Text('Категория: ${data.clientCategory}'),
                            Text(
                                'Ответственный менеджер: ${data.managerName ?? 'Не заполнено'}'),
                            const Divider(
                              color: Colors.white,
                              height: 10,
                            ),
                            Text('Адрес: ${data.address}'),
                            //   Text('Contact Info: ${data.contactInf.join(", ")}'),
                          ],
                        ),
                        DefaultTabController(
                          length: 5,
                          child: Column(
                            children: [
                              const TabBar(
                                isScrollable: true,
                                labelColor: Colors.blue,
                                automaticIndicatorColorAdjustment: true,
                                indicatorColor: Colors.blue,
                                tabs: [
                                  Tab(text: 'Детали'),
                                  Tab(text: 'Участники'),
                                  Tab(text: 'Аналитика'),
                                  Tab(text: 'Файлы'),
                                  Tab(text: 'Сельхоз поля'),
                                ],
                              ),
                              SizedBox(
                                height:
                                    350, // Установите высоту, которая вам подходит
                                child: TabBarView(
                                  children: [
                                    buildCardSection(
                                      "Детали клиента",
                                      '',
                                      [
                                        const Divider(
                                          height: 10,
                                          color: Colors.white,
                                        ),
                                        //Text('Visit Type ID: ${data.clientId}'),
                                        Text('Цель: ${data.vistiTypeName}'),
                                        // Text(
                                        //     'Meeting Type ID: ${data.meetingTypeId}'),
                                        Text(
                                            'Место встречи: ${data.meetingTypeName ?? 'Запись отсутствует'}'),
                                        // Text(
                                        //     'Plot Name: ${data.plotName ?? 'N/A'}'),
                                        Text(
                                            'Статус: ${data.statusVisit ? 'Не завершен' : 'Завершен'}'),
                                        Text(
                                            'Сумма контрактов: ${data.summContract}'),
                                        Text(
                                            'Сумма субсидий: ${data.subscidesSum}'),
                                      ],
                                    ),
                                    Contact(),
                                    Column(children: [
                                      CatalogAnalytic(),
                                    ]),
                                    FileClient(),
                                    FieldsClient()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        bottomNavigationBar: BlocProvider(
          create: (context) => RecorderCubit(),
          child: MyBottomNavigationBar(),
        ),
      ),
    );
  }
}
