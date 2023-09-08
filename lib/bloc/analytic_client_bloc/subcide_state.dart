// calendar_state.dart
part of 'subcides_client.dart';

abstract class SubcidesListState extends Equatable {
  @override
  List<Object> get props => [];
}

class SubcidesInitial extends SubcidesListState {}

class SubcidesFetchedState extends SubcidesListState {
  final List<SeasonData> subcidesData;

  SubcidesFetchedState(this.subcidesData);
}

class SubcidesFetchFailed extends SubcidesListState {
  final String error;

  SubcidesFetchFailed(this.error);
}
