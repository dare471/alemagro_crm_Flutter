part of 'contract_inside_bloc.dart';

enum ContractInsideStatus { initial, success, failure }

class ContractInsideState extends Equatable {
  final List<SeasonData>
      seasonData; // Изменено с contracts на seasonData для соответствия модели
  final ContractInsideStatus status;

  const ContractInsideState({
    this.seasonData = const [],
    this.status = ContractInsideStatus.initial,
  });

  @override
  List<Object> get props => [seasonData, status];
}
