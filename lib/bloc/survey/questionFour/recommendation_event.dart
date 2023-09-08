abstract class RecommendationEvent {}

class FetchRecommendations extends RecommendationEvent {}

class ToggleRecommendationSelection extends RecommendationEvent {
  final int id;

  ToggleRecommendationSelection({required this.id});
}
