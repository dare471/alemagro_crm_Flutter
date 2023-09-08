// contact_event.dart
abstract class ContactEvent {}

class GetContact extends ContactEvent {
  final int clientId;

  GetContact(this.clientId);
}
