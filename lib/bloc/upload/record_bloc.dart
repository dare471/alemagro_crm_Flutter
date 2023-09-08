import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'dart:async';

enum RecorderStatus { idle, recording }

class RecorderState {
  final RecorderStatus status;
  final int recordingTime;
  final List<Asset>? multiImages;
  final XFile? singleImage;

  RecorderState({
    required this.status,
    required this.recordingTime,
    this.multiImages,
    this.singleImage,
  });
}

class RecorderCubit extends Cubit<RecorderState> {
  final Record record = Record();
  Timer? _timer;

  RecorderCubit()
      : super(RecorderState(status: RecorderStatus.idle, recordingTime: 0));

  Future<void> initRecorder() async {
    var appDocDir = await getApplicationDocumentsDirectory();
    String path = '${appDocDir.path}/${DateTime.now()}.m4a';
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      emit(RecorderState(
          status: RecorderStatus.recording,
          recordingTime: state.recordingTime + 1));
    });
    if (await record.hasPermission()) {
      await record.start(
        path: path,
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );

      emit(RecorderState(
          status: RecorderStatus.recording,
          recordingTime: state.recordingTime,
          multiImages: state.multiImages,
          singleImage: state.singleImage));

      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        emit(RecorderState(
            status: RecorderStatus.recording,
            recordingTime: state.recordingTime + 1,
            multiImages: state.multiImages,
            singleImage: state.singleImage));
      });
    }
  }

  void showDialogTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      emit(RecorderState(
          status: RecorderStatus.recording,
          recordingTime: state.recordingTime + 2));
    });
  }

  Future<void> stopRecording() async {
    await record.stop();
    _timer?.cancel();
    emit(RecorderState(
        status: RecorderStatus.idle,
        recordingTime: 0,
        multiImages: state.multiImages,
        singleImage: state.singleImage));
  }

  Future<void> pickSingleImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      emit(RecorderState(
          status: state.status,
          recordingTime: state.recordingTime,
          multiImages: state.multiImages,
          singleImage: XFile(pickedFile.path)));
    }
  }

  Future<void> pickMultipleImages() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(maxImages: 3);
    } catch (e) {
      print(e);
    }

    if (!resultList.isEmpty) {
      emit(RecorderState(
          status: state.status,
          recordingTime: state.recordingTime,
          multiImages: resultList,
          singleImage: state.singleImage));
    }
  }

  void reset() {
    _timer?.cancel();
    emit(RecorderState(
        status: RecorderStatus.idle,
        recordingTime: 0,
        multiImages: state.multiImages,
        singleImage: state.singleImage));
  }
}
