import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:alem_application/models/crop_rotation_model.dart';

part 'crop_rotation_event.dart';
part 'crop_rotation_state.dart';

class CropRotationBloc extends Bloc<CropRotationEvent, CropRotationState> {
  CropRotationBloc() : super(const CropRotationState());

  @override
  Stream<CropRotationState> mapEventToState(CropRotationEvent event) async* {
    if (event is CropRotationFetched) {
      yield await _fetchCropRotations();
    }
  }

  Future<CropRotationState> _fetchCropRotations() async {
    final url = 'https://crm.alemagro.com:8080/api/client';
    final body = jsonEncode({
      "type": "client",
      "action": "getCropRotation",
      "clientId": 4478,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final List<CropRotation> cropRotations =
            jsonResponse.map((json) => CropRotation.fromJson(json)).toList();
        return CropRotationState(
          cropRotations: cropRotations,
          status: CropRotationStatus.success,
        );
      } else {
        print(response.body);
        return CropRotationState(status: CropRotationStatus.failure);
      }
    } catch (_) {
      return CropRotationState(status: CropRotationStatus.failure);
    }
  }
}
