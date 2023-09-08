import 'package:alem_application/bloc/file_client/file_client_bloc.dart';
import 'package:alem_application/views/calendar/widget/catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileClient extends StatefulWidget {
  _FileClientState createState() => _FileClientState();
}

class _FileClientState extends State<FileClient> {
  final sizeEl = const SizedBox(
    width: 10,
  );
  final elevB = ButtonStyle(
      fixedSize: MaterialStateProperty.all(const Size(400, 60)),
      backgroundColor:
          MaterialStateProperty.all<Color>(Color.fromARGB(255, 0, 113, 199)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ));
  final sizeB = const SizedBox(height: 10);
  void showCard(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
            create: (context) =>
                FileBloc(apiClient: FileApiClient())..add(FetchFiles()),
            child:
                FileSliverAppBar()), // Здесь должен быть ваш экран, который использует FileSliverAppBar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.down,
            children: [
              sizeB,
              ElevatedButton(
                style: elevB,
                onPressed: () => showCard('Видео'),
                child: Row(
                  children: [
                    const Icon(Icons.video_camera_back),
                    sizeEl,
                    const Text(
                      'Видео',
                    )
                  ],
                ),
              ),
              sizeB,
              ElevatedButton(
                style: elevB,
                onPressed: () => showCard('Фотографии'),
                child: Row(
                  children: [
                    const Icon(Icons.photo),
                    sizeEl,
                    const Text(
                      'Фотографии',
                    )
                  ],
                ),
              ),
              sizeB,
              ElevatedButton(
                style: elevB,
                onPressed: () => showCard('Аудио'),
                child: Row(
                  children: [
                    const Icon(Icons.music_note),
                    sizeEl,
                    const Text(
                      'Аудио',
                    )
                  ],
                ),
              ),
              sizeB,
              ElevatedButton(
                style: elevB,
                onPressed: () => showCard('Файлы'),
                child: Row(
                  children: [
                    const Icon(Icons.document_scanner_outlined),
                    sizeEl,
                    const Text(
                      'Файлы',
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
