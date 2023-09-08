import 'package:alem_application/bloc/search/search_bloc.dart';
import 'package:alem_application/models/client_search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyClient extends StatefulWidget {
  @override
  _MyClientState createState() => _MyClientState();
}

class _MyClientState extends State<MyClient> {
  late ClientBloc _clientBloc;

  @override
  void initState() {
    super.initState();
    _clientBloc = BlocProvider.of<ClientBloc>(context);
    _clientBloc.add(ClientEvent('ТОО'));
  }

  @override
  void dispose() {
    super.dispose();
  }

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              BlocProvider.of<ClientBloc>(context)
                  .add(ClientEvent(controller.text));
            },
            controller: controller,
            decoration: InputDecoration(
                label: Text('Введите наименовение КХ'),
                hintText: 'Например: ТОО ...'),
            // ...
          ),
          Expanded(
            child: BlocBuilder<ClientBloc, ClientState>(
              builder: (context, state) {
                if (state is ClientLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ClientLoaded) {
                  return ListView.builder(
                    itemCount: state.clients.length,
                    itemBuilder: (context, index) {
                      final client = state.clients[index];
                      return ListTile(
                        title: Text("${client.clientName}"),
                        subtitle: Text('БИН: ${client.clientIin}'),
                      );
                    },
                  );
                } else if (state is ClientError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(child: Text("Unknown state"));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
