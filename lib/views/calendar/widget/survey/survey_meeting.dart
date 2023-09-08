import 'package:alem_application/bloc/survey/answerQuestion/global_manager_bloc.dart';
import 'package:alem_application/bloc/survey/questionFour/recommendation_bloc.dart';
import 'package:alem_application/bloc/survey/questionFour/recommendation_event.dart';
import 'package:alem_application/bloc/survey/questionOne/survey_bloc.dart';
import 'package:alem_application/bloc/survey/questionThree/complicationBloc.dart';
import 'package:alem_application/bloc/survey/questionThree/complicationEvent.dart';
import 'package:alem_application/bloc/survey/questionTwo/survey_bloc.dart';
import 'package:alem_application/bloc/upload/record_bloc.dart';
import 'package:alem_application/views/calendar/widget/bottomNavigationBar/main_widget.dart';
import 'package:alem_application/views/calendar/widget/survey/QuestionFour.dart';
import 'package:alem_application/views/calendar/widget/survey/QuestionOne.dart';
import 'package:alem_application/views/calendar/widget/survey/QuestionThree.dart';
import 'package:alem_application/views/calendar/widget/survey/QuestionTwo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class SurveyScreen extends StatefulWidget {
  final int visitId;
  final int visitTypeId;

  @override
  SurveyScreen({required this.visitId, required this.visitTypeId});
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final PageController _pageController = PageController();
  final ValueNotifier<bool> canMoveToNextPage = ValueNotifier<bool>(false);
  String appBarTitle = 'Проделанная работа';
  Box<int>? visitIdBox;
  Box<int>? visitTypeIdBox;

  @override
  void initState() {
    super.initState();
    _openBox();
    _pageController.addListener(() {
      int currentPage = _pageController.page!.round();
      setState(() {
        switch (currentPage) {
          case 0:
            appBarTitle = 'Проделанная работа';
            break;
          case 1:
            appBarTitle = 'Осмотр полей';
            break;
          case 2:
            appBarTitle = 'Какие проблемы возникли при заключение договора ? ';
            break;
          default:
            appBarTitle = 'Рекомендации';
        }
      });
    });
  }

  Future<void> _openBox() async {
    if (!Hive.isBoxOpen('visitIdBox')) {
      visitIdBox = await Hive.openBox<int>('visitIdBox');
      visitTypeIdBox = await Hive.openBox<int>('visitTypeIdBox');
    } else {
      visitIdBox = Hive.box<int>('visitIdBox');
      visitTypeIdBox = await Hive.openBox<int>('visitTypeIdBox');
    }
    visitIdBox!.put('visitId', widget.visitId);
    visitTypeIdBox!.put('visitTypeId', widget.visitTypeId);
  }

  @override
  void dispose() {
    if (Hive.isBoxOpen('visitIdBox')) {
      visitIdBox?.close();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GlobalManagerBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: Color.fromARGB(255, 0, 113, 199),
        ),
        body: ValueListenableBuilder(
          valueListenable: canMoveToNextPage,
          builder: (context, canMove, child) {
            return PageView(
              controller: _pageController,
              physics: canMove
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              children: [
                BlocProvider(
                  create: (context) {
                    final globalManagerBloc =
                        BlocProvider.of<GlobalManagerBloc>(context);
                    return SurveyBloc(globalManagerBloc: globalManagerBloc)
                      ..add(LoadQuestion());
                  },
                  child: QuestionOne(_pageController),
                ),
                BlocProvider(
                  create: (context) {
                    final globalManagerBloc =
                        BlocProvider.of<GlobalManagerBloc>(context);
                    return SurveyTwoBloc(globalManagerBloc: globalManagerBloc)
                      ..add(LoadTwoQuestions());
                  },
                  child: QuestionTwo(
                    _pageController,
                  ),
                ),
                BlocProvider(
                  create: (context) {
                    final globalManagerBloc =
                        BlocProvider.of<GlobalManagerBloc>(context);
                    return ComplicationBloc(
                        globalManagerBloc: globalManagerBloc)
                      ..add(FetchComplications());
                  },
                  child: ComplicationScreen(_pageController),
                ),
                BlocProvider(
                  create: (context) {
                    final globalManagerBloc =
                        BlocProvider.of<GlobalManagerBloc>(context);
                    return RecommendationBloc(
                        globalManagerBloc: globalManagerBloc)
                      ..add(FetchRecommendations());
                  },
                  child: RecommendationList(_pageController),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocProvider(
          create: (context) => RecorderCubit(),
          child: MyBottomNavigationBar(),
        ),
      ),
    );
  }
}
