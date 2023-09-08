// calendar_event.dart
part of 'subcides_client.dart';

abstract class SubcidesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubcidesFetched extends SubcidesEvent {}
