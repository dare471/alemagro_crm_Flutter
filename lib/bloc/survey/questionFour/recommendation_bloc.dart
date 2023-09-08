import 'dart:convert';
import 'package:alem_application/bloc/survey/answerQuestion/global_manager_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'recommendation_event.dart';
import 'recommendation_state.dart';
import 'package:alem_application/models/complication.dart'; // Импортируйте вашу модель Recommendation

class RecommendationBloc
    extends Bloc<RecommendationEvent, RecommendationState> {
  RecommendationBloc({required this.globalManagerBloc})
      : super(RecommendationInitial());
  Set<int> selectedRecommendationIds = {};
  final GlobalManagerBloc globalManagerBloc;

  @override
  Stream<RecommendationState> mapEventToState(
      RecommendationEvent event) async* {
    if (event is FetchRecommendations) {
      yield RecommendationLoading();
      try {
        final response = await http.post(
          Uri.parse('https://crm.alemagro.com:8080/api/manager/workspace'),
          body: jsonEncode({
            "type": "meetingSurvey",
            "action": "getHandBookMeetingRecommendations"
          }),
          headers: {"Content-Type": "application/json"},
        );

        if (response.statusCode == 200) {
          final List<dynamic> recommendationJson = json.decode(response.body);
          final recommendations = recommendationJson
              .map((json) => Complication.fromJson(json))
              .toList();
          yield RecommendationLoaded(
              recommendations, selectedRecommendationIds);
        } else {
          yield RecommendationError("Error fetching data");
        }
      } catch (e) {
        yield RecommendationError(e.toString());
      }
    }

    if (event is ToggleRecommendationSelection) {
      if (selectedRecommendationIds.contains(event.id)) {
        selectedRecommendationIds.remove(event.id);
        globalManagerBloc.removeRecomendation(event.id.toString());
      } else {
        selectedRecommendationIds.add(event.id);
        globalManagerBloc.addRecomendation(selectedRecommendationIds);
        print(selectedRecommendationIds);
      }

      if (state is RecommendationLoaded) {
        yield RecommendationLoaded(
            (state as RecommendationLoaded).recommendations,
            selectedRecommendationIds);
      }
    }
  }
}
