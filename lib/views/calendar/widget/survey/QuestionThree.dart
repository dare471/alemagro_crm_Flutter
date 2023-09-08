import 'package:alem_application/bloc/survey/answerQuestion/global_manager_bloc.dart';
import 'package:alem_application/bloc/survey/questionThree/complicationBloc.dart';
import 'package:alem_application/bloc/survey/questionThree/complicationEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplicationScreen extends StatefulWidget {
  final PageController pageController;
  ComplicationScreen(this.pageController);
  _ComplicationScreenState createState() => _ComplicationScreenState();
}

class _ComplicationScreenState extends State<ComplicationScreen> {
  late final PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = widget.pageController; // Инициализация
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComplicationBloc(
          globalManagerBloc: BlocProvider.of<GlobalManagerBloc>(context))
        ..add(FetchComplications()),
      child: Scaffold(
        body: BlocBuilder<ComplicationBloc, ComplicationState>(
          builder: (context, state) {
            if (state is ComplicationLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ComplicationLoaded) {
              return Column(children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.complications.length,
                    itemBuilder: (context, index) {
                      final complication = state.complications[index];
                      final isSelected = state.selectedComplications
                          .containsKey(complication.id);

                      return Theme(
                        data: ThemeData(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        child: CheckboxListTile(
                          title: Text(complication.name),
                          value: isSelected,
                          onChanged: (_) {
                            context.read<ComplicationBloc>().add(
                                ToggleComplicationSelection(
                                    complication.id, complication.name));
                          },
                        ),
                      );
                    },
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Добавлено для центрирования кнопок
                    children: [
                      const SizedBox(width: 16),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          fixedSize: MaterialStateProperty.all(
                            const Size(120, 60),
                          ),
                        ),
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text(
                          'Далее',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                )
              ]);
            }

            if (state is ComplicationError) {
              return Center(child: Text(state.message));
            }

            return Center(child: Text("Unexpected error"));
          },
        ),
      ),
    );
  }
}
