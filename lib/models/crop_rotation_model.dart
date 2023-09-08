// crop_rotation_model.dart

class CropRotation {
  final int id;
  final String season;
  final List<Culture> cultures;

  CropRotation(
      {required this.id, required this.season, required this.cultures});

  factory CropRotation.fromJson(Map<String, dynamic> json) {
    return CropRotation(
      id: json['id'],
      season: json['season'],
      cultures:
          (json['cultures'] as List).map((i) => Culture.fromJson(i)).toList(),
    );
  }
}

class Culture {
  final String id;
  final String culture;
  final String area;

  Culture({required this.id, required this.culture, required this.area});

  factory Culture.fromJson(Map<String, dynamic> json) {
    return Culture(
      id: json['id'],
      culture: json['culture'],
      area: json['area'],
    );
  }
}
