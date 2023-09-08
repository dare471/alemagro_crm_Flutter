class Client {
  final String clientId;
  final String clientName;
  final String clientIin;

  Client(
      {required this.clientId,
      required this.clientName,
      required this.clientIin});

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      clientId: json['clientId'],
      clientName: json['clientName'],
      clientIin: json['clientIin'],
    );
  }
}
