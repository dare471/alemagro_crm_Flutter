import 'package:alem_application/bloc/survey/answerQuestion/global_manager_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alem_application/bloc/survey/questionTwo/survey_bloc.dart';

class QuestionTwo extends StatefulWidget {
  final PageController pageController;

  QuestionTwo(this.pageController);

  @override
  _QuestionTwoState createState() => _QuestionTwoState();
}

class SurveyData {
  final int? cultureID;
  final String? cultureName;
  final int? stageID;
  final String? stageName;
  final List<Map<String, dynamic>> problemData;

  SurveyData({
    this.cultureID,
    this.cultureName,
    this.stageID,
    this.stageName,
    required this.problemData,
  });

  // ignore: override_on_non_overriding_member
  @override
  Map<String, dynamic> toJson() {
    return {
      'culture': {
        'id': cultureID,
        'name': cultureName,
      },
      'stagesViewCulture': {
        'id': stageID,
        'name': stageName,
      },
      'idetificationProblem': problemData
          .toList(), // предполагается, что problemData уже в нужном формате
    };
  }
}

class _QuestionTwoState extends State<QuestionTwo> {
  int? selectedCultureIndex;
  late final PageController _pageController;
  int? selectedStageIndexes;
  Set<int> selectedProblemIndexes = Set();
  List<SurveyData> collectedData = [];
  List<dynamic>? cultureData;
  List<dynamic>? stageData;
  List<dynamic>? problemData;
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = widget.pageController;
  }

  void onSave() {
    if (cultureData != null && stageData != null && problemData != null) {
      // Теперь Dart знает, что эти переменные не null, и доступ к ним через [] будет безопасным
      var newData = SurveyData(
        cultureID: cultureData![selectedCultureIndex!]['id'],
        cultureName: cultureData![selectedCultureIndex!]['name'],
        stageID: stageData![selectedStageIndexes!]['id'],
        stageName: stageData![selectedStageIndexes!]['name'],
        problemData: selectedProblemIndexes.map((index) {
          return {
            'id': problemData![index]['id'],
            'name': problemData![index]['name'],
          };
        }).toList(),
      );

      collectedData.add(newData);

      SurveyTwoBloc surveyBloc = BlocProvider.of<SurveyTwoBloc>(context);
      surveyBloc.add(AnswerQuestion(newData)); // Отправляем событие в Bloc

      // resetSelectedIndexes();
    } else {
      // Обработайте случай, когда данные еще не загружены
      print("Data is not yet loaded");
    }
  }

  void resetSelectedIndexes() {
    setState(() {
      selectedCultureIndex = null;
      selectedStageIndexes = null;
      selectedProblemIndexes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveyTwoBloc(
          globalManagerBloc: BlocProvider.of<GlobalManagerBloc>(context))
        ..add(LoadTwoQuestions()),
      child: Scaffold(
        body: BlocBuilder<SurveyTwoBloc, SurveyTwoState>(
          builder: (context, state) => buildBody(context, state),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context, SurveyTwoState state) {
    if (state is SurveyLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is SurveyLoaded) {
      return buildLoadedSurvey(state);
    }
    return Center(child: Text('An error occurred'));
  }

  Widget buildLoadedSurvey(SurveyLoaded state) {
    final surveyData = state.surveyData;
    const List<String> list = <String>['One', 'Two', 'Three', 'Four'];
    String dropdownValue = list.first;

    cultureData = filterByCategory(surveyData, 'Выбор культуры');
    stageData = filterByCategory(surveyData, 'Этапы осмотра полей по културе');
    problemData = filterByCategory(surveyData, 'Обнаружение проблемы');
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                padding: EdgeInsets.fromLTRB(30, 10, 30, 5),
                child: DropdownMenu<String>(
                  menuHeight: 200,
                  initialSelection: list.first,
                  onSelected: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries:
                      list.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
              ),
              cultureData != null
                  ? buildHorizontalList(
                      'Выбор культуры', cultureData!, selectedCultureIndex)
                  : SizedBox.shrink(),
              stageData != null
                  ? buildHorizontalList('Этапы осмотра полей по културе',
                      stageData!, selectedStageIndexes)
                  : SizedBox.shrink(),
              problemData != null
                  ? buildHorizontalList('Обнаружение проблемы', problemData!,
                      selectedProblemIndexes)
                  : SizedBox.shrink(),
              buildActionButtons()
            ],
          ),
        ),
      ],
    );
  }

  List<dynamic> filterByCategory(List<dynamic> data, String category) {
    return data.where((item) => item['category'] == category).toList();
  }

  Widget buildActionButtons() {
    if (selectedCultureIndex == null || selectedStageIndexes == null)
      return SizedBox.shrink();

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildActionButton('Добавить \n культуру', onSave),
          const SizedBox(width: 16),
          buildActionButton('Далее', () {
            onSave();
            _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }),
        ],
      ),
    );
  }

  ElevatedButton buildActionButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        fixedSize: MaterialStateProperty.all(const Size(120, 60)),
      ),
      onPressed: onPressed,
      child: Text(title, style: TextStyle(fontSize: 15)),
    );
  }

  Widget buildHorizontalList(
      String title, List<dynamic> data, dynamic selectedIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ),
        Container(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              bool isSelected = false;
              if (selectedIndex is int) {
                isSelected = selectedIndex == index;
              } else if (selectedIndex is Set<int>) {
                isSelected = selectedIndex.contains(index);
              }

              return InkWell(
                onTap: () {
                  setState(() {
                    if (title == 'Выбор культуры') {
                      selectedCultureIndex = index;
                    } else if (title == 'Этапы осмотра полей по културе') {
                      selectedStageIndexes = index;
                    } else if (title == 'Обнаружение проблемы') {
                      if (selectedProblemIndexes.contains(index)) {
                        selectedProblemIndexes.remove(index);
                      } else {
                        selectedProblemIndexes.add(index);
                      }
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            isSelected ? Colors.blue : Colors.transparent,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(item['url']),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(item['name']),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
