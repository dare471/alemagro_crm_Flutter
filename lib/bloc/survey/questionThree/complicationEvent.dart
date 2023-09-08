import 'package:alem_application/models/complication.dart';

abstract class ComplicationEvent {}

class FetchComplications extends ComplicationEvent {}

abstract class ComplicationState {}

class ComplicationInitial extends ComplicationState {}

class ComplicationLoading extends ComplicationState {}

class ComplicationError extends ComplicationState {
  final String message;

  ComplicationError(this.message);
}

class ToggleComplicationSelection extends ComplicationEvent {
  final int id;
  final String name;

  ToggleComplicationSelection(this.id, this.name);
}

class ComplicationLoaded extends ComplicationState {
  final List<Complication> complications;
  final Map<int, String> selectedComplications;

  ComplicationLoaded(this.complications, this.selectedComplications);
}
