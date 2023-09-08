import 'dart:async';
import 'dart:convert';
import 'package:alem_application/models/contract_inside_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart'; // Подставьте правильный путь

part 'contract_inside_event.dart';
part 'contract_inside_state.dart';

class ContractInsideBloc
    extends Bloc<ContractInsideEvent, ContractInsideState> {
  ContractInsideBloc() : super(const ContractInsideState());

  @override
  Stream<ContractInsideState> mapEventToState(
      ContractInsideEvent event) async* {
    if (event is ContractInsideFetched) {
      yield await _fetchContracts();
    }
  }

  Future<ContractInsideState> _fetchContracts() async {
    try {
      final response = await http.post(
        Uri.parse('https://crm.alemagro.com:8080/api/client'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {"type": "client", "action": "getContract", "clientId": 2191}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final List<SeasonData> contracts =
            jsonResponse.map((json) => SeasonData.fromJson(json)).toList();
        return ContractInsideState(
          seasonData: contracts,
          status: ContractInsideStatus.success,
        );
      } else {
        return ContractInsideState(status: ContractInsideStatus.failure);
      }
    } catch (_) {
      return ContractInsideState(status: ContractInsideStatus.failure);
    }
  }
}
