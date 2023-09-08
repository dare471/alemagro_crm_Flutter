abstract class AddVisitEvent {}

class FetchTypeVisit extends AddVisitEvent {}

class FetchTypeMeeting extends AddVisitEvent {}

class FetchSearchClient extends AddVisitEvent {
  final String query;

  FetchSearchClient(this.query);
}

class NavigateToAddVisit extends AddVisitEvent {}
