import 'package:alem_application/bloc/file_client/file_client_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: use_key_in_widget_constructors
class FileSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          _buildSliverGrid(), // Замените _buildSliverList на _buildSliverGrid
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text('Файлы'),
        background: _buildBackground(),
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/media-file.png',
          fit: BoxFit.scaleDown,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverGrid() {
    return BlocBuilder<FileBloc, FileState>(
      builder: (context, state) {
        if (state is FileLoading) {
          return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        } else if (state is FileLoaded) {
          return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _buildGridItem(context, state, index);
              },
              childCount: state.files.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // количество столбцов
            ),
          );
        } else {
          return const SliverToBoxAdapter(
              child: Center(child: Text('Error loading files')));
        }
      },
    );
  }

  Widget _buildGridItem(BuildContext context, FileState state, int index) {
    if (state is FileLoaded) {
      String filePath =
          'https://crm.alemagro.com:8080${state.files[index].filePath ?? ''}'; // URL может быть другим
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                filePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                state.files[index].createDate ?? 'Unknown',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
