class FileModel {
  final String? id;
  final String? filePath;
  final String? author;
  final String? createDate;
  final String? client;
  final String? type;
  final String? typeMedia;

  FileModel(
      {required this.id,
      required this.filePath,
      required this.author,
      required this.createDate,
      required this.client,
      required this.type,
      required this.typeMedia});

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'],
      filePath: json['filePath'],
      author: json['author'],
      createDate: json['createDate'],
      client: json['client'],
      type: json['type'],
      typeMedia: json['typeMedia'],
    );
  }
}
