import 'package:alem_application/bloc/analytic_client_bloc/subcides_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alem_application/models/subcides_model.dart';

class SubcidesList extends StatefulWidget {
  @override
  _SubcidesListState createState() => _SubcidesListState();
}

class _SubcidesListState extends State<SubcidesList> {
  @override
  void initState() {
    super.initState();
    context.read<SubcidesListBloc>().add(SubcidesFetched());
  }

  final divider = const Divider(
    height: 10,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcidesListBloc, SubcidesListState>(
      builder: (context, state) {
        if (state is SubcidesFetchedState) {
          return buildListView(state.subcidesData);
        } else if (state is SubcidesFetchFailed) {
          return Text('Failed to load: ${state.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildListView(List<SeasonData>? seasons) {
    if (seasons == null || seasons.isEmpty) {
      return Center(child: Text('No seasons available'));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 0, 113, 199),
            shadowColor: const Color.fromARGB(255, 0, 113, 199),
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 160.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Субсидий'),
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return buildSeasonExpansionTile(seasons[index]);
              },
              childCount: seasons.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSeasonExpansionTile(SeasonData season) {
    return ExpansionTile(
      title: Text(season.season),
      children: season.categories.map(buildCategoryExpansionTile).toList(),
    );
  }

  Widget buildCategoryExpansionTile(Category category) {
    return ExpansionTile(
      title: Text(category.category),
      children: category.contracts.map(buildContractCard).toList(),
    );
  }

  Widget buildContractCard(Contract contract) {
    return Card(
      margin: const EdgeInsets.all(5),
      elevation: 4,
      color: const Color.fromARGB(255, 0, 113, 199),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Наименование закупщика: ${contract.clientName}"),
              divider,
              Text("Регион: ${contract.region}"),
              divider,
              Text("Поставщик: ${contract.providerName}"),
              divider,
              Text("Продукция: ${contract.productName}"),
              divider,
              Text("Площадь применения: ${contract.usageArea}"),
            ],
          ),
        ),
      ),
    );
  }
}
