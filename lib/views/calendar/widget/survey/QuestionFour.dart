import 'package:alem_application/bloc/survey/answerQuestion/global_manager_bloc.dart';
import 'package:alem_application/bloc/survey/questionFour/recommendation_bloc.dart';
import 'package:alem_application/bloc/survey/questionFour/recommendation_event.dart';
import 'package:alem_application/bloc/survey/questionFour/recommendation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecommendationList extends StatelessWidget {
  final PageController pageController;

  const RecommendationList(this.pageController);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecommendationBloc(
          globalManagerBloc: BlocProvider.of<GlobalManagerBloc>(context))
        ..add(FetchRecommendations()),
      child: Scaffold(
        body: BlocBuilder<RecommendationBloc, RecommendationState>(
          builder: (context, state) {
            if (state is RecommendationLoading) {
              return CircularProgressIndicator();
            }
            if (state is RecommendationError) {
              return Text('Error: ${state.message}');
            }
            if (state is RecommendationLoaded) {
              return ListView(
                children: [
                  ...state.recommendations.map((complication) {
                    return SwitchListTile(
                      title: Text(complication.name),
                      value: state.selectedRecommendationIds
                          .contains(complication.id),
                      onChanged: (bool value) {
                        context.read<RecommendationBloc>().add(
                            ToggleRecommendationSelection(id: complication.id));
                      },
                    );
                  }).toList(),
                  // ignore: unnecessary_null_comparison
                  if (state.selectedRecommendationIds != null)
                    Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          fixedSize: MaterialStateProperty.all(
                            const Size(120, 60),
                          ),
                        ),
                        onPressed: () async {
                          context.read<GlobalManagerBloc>().sendApi();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Завершить',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
