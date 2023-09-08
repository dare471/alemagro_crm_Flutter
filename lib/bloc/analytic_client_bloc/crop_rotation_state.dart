// crop_rotation_state.dart

part of 'CropRotation_client.dart';

enum CropRotationStatus { initial, success, failure }

class CropRotationState extends Equatable {
  final List<CropRotation> cropRotations;
  final CropRotationStatus status;

  const CropRotationState({
    this.cropRotations = const <CropRotation>[],
    this.status = CropRotationStatus.initial,
  });

  @override
  List<Object> get props => [cropRotations, status];
}
