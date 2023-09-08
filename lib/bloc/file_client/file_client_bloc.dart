import 'package:alem_application/models/file_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Events
abstract class FileEvent {}

class FetchFiles extends FileEvent {}

// States
abstract class FileState {}

class FileLoading extends FileState {}

class FileLoaded extends FileState {
  final List<FileModel> files;

  FileLoaded({required this.files});
}

class FileError extends FileState {}

class FileApiClient {
  final String baseUrl = 'https://crm.alemagro.com:8080';
  Future<List<FileModel>> fetchFiles() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/manager/workspace'),
      body: jsonEncode({"type": "getFileVisit", "clientId": 34633}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => FileModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load files');
    }
  }
}

// BLoC
class FileBloc extends Bloc<FileEvent, FileState> {
  final FileApiClient apiClient;

  FileBloc({required this.apiClient}) : super(FileLoading());

  @override
  Stream<FileState> mapEventToState(FileEvent event) async* {
    if (event is FetchFiles) {
      yield FileLoading();
      try {
        final files = await apiClient.fetchFiles();
        yield FileLoaded(files: files);
      } catch (e) {
        print("Error occurred: $e");
        yield FileError();
      }
    }
  }
}
