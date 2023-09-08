class Complication {
  final int id;
  final String name;

  Complication({required this.id, required this.name});

  factory Complication.fromJson(Map<String, dynamic> json) {
    return Complication(
      id: json['id'],
      name: json['name'],
    );
  }
}
