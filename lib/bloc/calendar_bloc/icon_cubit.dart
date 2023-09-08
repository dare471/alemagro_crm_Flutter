import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

enum IconState { play, pause }

class PlayPauseCubit extends Cubit<PlayPauseState> {
  PlayPauseCubit() : super(PlayPauseState());

  Future<void> _sendPostRequest(String action, int visitId) async {
    final String apiUrl = "https://crm.alemagro.com:8080/api/planned/mobile";

    final Map<String, dynamic> body = {
      "type": "plannedMeeting",
      "action": action,
      "visitId": visitId,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("Success: ${response.body}");
    } else {
      print("Failed: ${response.body}");
    }
  }

  void togglePlayPause(int visitId) async {
    final DateTime currentTime = DateTime.now();

    if (state.isPaused) {
      await _sendPostRequest("setStartVisit", visitId);
      emit(state.copyWith(
        isPaused: false,
        playTime: currentTime,
      ));
    } else {
      await _sendPostRequest("setFinishVisit", visitId);
      emit(state.copyWith(
        isPaused: true,
        pauseTime: currentTime,
      ));
    }
  }
}

class PlayPauseState {
  final bool isPaused;
  final DateTime? playTime;
  final DateTime? pauseTime;

  PlayPauseState({
    this.isPaused = true,
    this.playTime,
    this.pauseTime,
  });

  PlayPauseState copyWith({
    bool? isPaused,
    DateTime? playTime,
    DateTime? pauseTime,
  }) {
    return PlayPauseState(
      isPaused: isPaused ?? this.isPaused,
      playTime: playTime ?? this.playTime,
      pauseTime: pauseTime ?? this.pauseTime,
    );
  }
}
