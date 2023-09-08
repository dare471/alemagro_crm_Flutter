import 'package:alem_application/bloc/analytic_client_bloc/contract_inside_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Подставьте правильный путь

// ignore: use_key_in_widget_constructors
class ContractInsideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 0, 113, 199),
            shadowColor: const Color.fromARGB(255, 48, 145, 218),
            pinned: true,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Аналитика по договорам',
                textAlign: TextAlign.center,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/analytics.png',
                    fit: BoxFit.contain,
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
              ),
            ),
          ),
          BlocBuilder<ContractInsideBloc, ContractInsideState>(
            builder: (context, state) {
              if (state.status == ContractInsideStatus.failure) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('Failed to load data'),
                  ),
                );
              }
              if (state.status == ContractInsideStatus.initial) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state.status == ContractInsideStatus.success) {
                final seasonDataList = state
                    .seasonData; // Предположим, что у вас тут список типа SeasonData

                if (seasonDataList.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text('Данные отсутствуют'),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final seasonData = seasonDataList[index];
                      return ExpansionTile(
                        title: Text(seasonData.season),
                        children: seasonData.categories.map((category) {
                          return ExpansionTile(
                            title: Text('Категория: ${category.category}'),
                            children: category.contracts.map((contract) {
                              return ListTile(
                                title:
                                    Text('Продукция: ${contract.productName}'),
                                subtitle: Text('Сумма: ${contract.avgPrice}'),
                                // Добавьте здесь другие поля контракта, если нужно
                              );
                            }).toList(),
                          );
                        }).toList(),
                      );
                    },
                    childCount: seasonDataList.length,
                  ),
                );
              }
              return const SliverFillRemaining(
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
