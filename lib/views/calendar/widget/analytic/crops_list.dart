import 'package:alem_application/bloc/analytic_client_bloc/CropRotation_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Импортируйте ваш BLoC

class CropRotationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color.fromARGB(255, 0, 113, 199),
            shadowColor: Colors.blue[500],
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Аналитика по сезонам - Севооборота',
                textAlign: TextAlign.center,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Изображение
                  Image.asset(
                    'assets/analytics.png',
                    fit: BoxFit.contain,
                  ),
                  // Градиент (или любой другой эффект)
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
              ),
            ),
          ),
          BlocBuilder<CropRotationBloc, CropRotationState>(
            builder: (context, state) {
              if (state.status == CropRotationStatus.failure) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('Failed to load data'),
                  ),
                );
              }

              if (state.status == CropRotationStatus.initial) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state.status == CropRotationStatus.success) {
                final cropRotations = state.cropRotations;
                if (cropRotations.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text('Данные отсуствтуют'),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final cropRotation = cropRotations[index];
                      return ExpansionTile(
                        title: Text('Сезон: ${cropRotation.season}'),
                        children: cropRotation.cultures.map((culture) {
                          return ListTile(
                            title: Text('Культура: ${culture.culture}'),
                            subtitle: Text('Площадь: ${culture.area}'),
                          );
                        }).toList(),
                      );
                    },
                    childCount: cropRotations.length,
                  ),
                );
              }
              return SliverFillRemaining(
                child: Center(
                  child: Text('Unknown State'),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
