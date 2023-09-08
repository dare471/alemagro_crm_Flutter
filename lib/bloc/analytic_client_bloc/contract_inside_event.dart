part of 'contract_inside_bloc.dart';

abstract class ContractInsideEvent extends Equatable {
  const ContractInsideEvent();

  @override
  List<Object> get props => [];
}

class ContractInsideFetched extends ContractInsideEvent {}
