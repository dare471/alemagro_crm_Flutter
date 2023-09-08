import 'package:alem_application/models/complication.dart';

abstract class RecommendationState {}

class RecommendationInitial extends RecommendationState {}

class RecommendationLoading extends RecommendationState {}

class RecommendationError extends RecommendationState {
  final String message;

  RecommendationError(this.message);
}

class RecommendationLoaded extends RecommendationState {
  final List<Complication> recommendations;
  final Set<int> selectedRecommendationIds;

  RecommendationLoaded(this.recommendations, this.selectedRecommendationIds);
}
