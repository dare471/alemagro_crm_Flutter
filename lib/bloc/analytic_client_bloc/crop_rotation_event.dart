// crop_rotation_event.dart
part of 'CropRotation_client.dart';

abstract class CropRotationEvent extends Equatable {
  const CropRotationEvent();

  @override
  List<Object> get props => [];
}

class CropRotationFetched extends CropRotationEvent {}
