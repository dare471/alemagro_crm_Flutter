import 'package:alem_application/bloc/search/search_bloc.dart';
import 'package:alem_application/bloc/search/search_event.dart';
import 'package:alem_application/bloc/search/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyClient extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyClientBloc(),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(labelText: 'Введите Наименование КХ'),
            onChanged: (value) {
              context.read<MyClientBloc>().add(SearchClientEvent(value));
            },
          ),
          BlocBuilder<MyClientBloc, MyClientState>(
            builder: (context, state) {
              if (state is MyClientLoading) {
                return CircularProgressIndicator();
              }

              if (state is MyClientLoaded) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.clients.length,
                  itemBuilder: (context, index) {
                    final client = state.clients[index];
                    return Card(
                      child: ListTile(
                        title: Text(client['clientName']),
                        subtitle: Text(client['clientIin']),
                      ),
                    );
                  },
                );
              }

              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
