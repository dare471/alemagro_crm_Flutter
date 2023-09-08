abstract class AddVisitState {}

class AddVisitInitial extends AddVisitState {}

class TypeVisitFetched extends AddVisitState {
  final List<dynamic> listItems;

  TypeVisitFetched(this.listItems);
}

class TypeMeetingFetched extends AddVisitState {
  final List<dynamic> listItemsMeeting;

  TypeMeetingFetched(this.listItemsMeeting);
}

class SearchClientFetched extends AddVisitState {
  final List<dynamic> listItems;

  SearchClientFetched(this.listItems);
}

class NavigateToAddVisitState extends AddVisitState {}

class AddVisitError extends AddVisitState {
  final String message;

  AddVisitError(this.message);
}
