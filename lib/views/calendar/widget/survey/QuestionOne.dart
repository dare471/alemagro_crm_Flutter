import 'package:alem_application/bloc/survey/questionOne/survey_bloc.dart';
import 'package:alem_application/views/calendar/widget/survey/QuestionTwo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionOne extends StatelessWidget {
  final PageController _pageController;

  QuestionOne(this._pageController);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurveyBloc, SurveyState>(
      builder: (context, state) {
        if (state is QuestionLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is QuestionLoaded) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.questions.length,
                  itemBuilder: (context, index) {
                    return Theme(
                      data: ThemeData(
                        checkboxTheme: CheckboxThemeData(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      child: CheckboxListTile(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        visualDensity:
                            const VisualDensity(horizontal: 2.0, vertical: 2.0),
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        title: Text(state.questions[index]['name']),
                        value: state.selectedAnswers
                            .containsKey(state.questions[index]['id']),
                        onChanged: (bool? value) {
                          context.read<SurveyBloc>().add(
                                AnswerQuestion(
                                    questionId: state.questions[index]['id'],
                                    answer: value,
                                    name: state.questions[index]['name']),
                              );
                        },
                      ),
                    );
                  },
                ),
              ),
              if (state.canMoveToNextPage)
                Container(
                  padding: EdgeInsets.all(40),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      fixedSize: MaterialStateProperty.all<Size>(
                        Size(160, 50),
                      ),
                    ),
                    onPressed: () {
                      _pageController.jumpToPage(state
                          .currentPage); // Ваш новый виджет для второй страницы
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Далее",
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(
                          Icons.touch_app,
                          size: 27,
                        )
                      ],
                    ),
                  ),
                )
            ],
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text("Произошла неизвестная ошибка"),
            ),
          );
        }
      },
    );
  }
}
