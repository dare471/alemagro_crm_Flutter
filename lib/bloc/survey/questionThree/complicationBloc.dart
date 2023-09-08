import 'dart:convert';
import 'package:alem_application/bloc/survey/answerQuestion/global_manager_bloc.dart';
import 'package:alem_application/bloc/survey/questionThree/complicationEvent.dart';
import 'package:alem_application/models/complication.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplicationBloc extends Bloc<ComplicationEvent, ComplicationState> {
  Map<int, String> selectedComplications = {};
  final GlobalManagerBloc globalManagerBloc;
  ComplicationBloc({required this.globalManagerBloc})
      : super(ComplicationInitial());
  @override
  Stream<ComplicationState> mapEventToState(ComplicationEvent event) async* {
    if (event is FetchComplications) {
      yield ComplicationLoading();
      try {
        final response = await http.post(
          Uri.parse('https://crm.alemagro.com:8080/api/manager/workspace'),
          body: jsonEncode({
            "type": "meetingSurvey",
            "action": "getHandBookContractComplications"
          }),
          headers: {"Content-Type": "application/json"},
        );

        if (response.statusCode == 200) {
          final List<dynamic> complicationJson = json.decode(response.body);
          final complications = complicationJson
              .map((json) => Complication.fromJson(json))
              .toList();
          yield ComplicationLoaded(complications, selectedComplications);
        } else {
          yield ComplicationError("Error fetching data");
        }
      } catch (e) {
        yield ComplicationError(e.toString());
      }
    }

    if (event is ToggleComplicationSelection) {
      if (selectedComplications.containsKey(event.id)) {
        //    print(selectedComplications);
        selectedComplications.remove(event.id);
      } else {
        selectedComplications[event.id] = event.name;
      }

      if (state is ComplicationLoaded) {
        yield ComplicationLoaded(
            (state as ComplicationLoaded).complications, selectedComplications);
      }

      // Преобразование в JSON
      List<Map<String, dynamic>> hardStages =
          selectedComplications.entries.map((entry) {
        return {'id': entry.key, 'name': entry.value};
      }).toList();
      String jsonHardStages = jsonEncode({'hardStages': hardStages});
      //    print(jsonHardStages);
      globalManagerBloc.addDifficulties(hardStages);
    }
  }
}
