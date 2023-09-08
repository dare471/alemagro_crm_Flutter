class Contact {
  final int id;
  final String position;
  final String name;
  final String phNumber;
  final String email;
  final int authorId;
  final bool actual;
  final String description;
  final bool mainContact;

  Contact({
    required this.id,
    required this.position,
    required this.name,
    required this.phNumber,
    required this.email,
    required this.authorId,
    required this.actual,
    required this.description,
    required this.mainContact,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      position: json['position'],
      name: json['name'],
      phNumber: json['phNumber'],
      email: json['email'],
      authorId: json['authorId'],
      actual: json['actual'],
      description: json['description'],
      mainContact: json['mainContact'],
    );
  }
}
