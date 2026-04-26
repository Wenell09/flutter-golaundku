part of 'customer_bloc.dart';

class CustomerState {}

final class CustomerInitial extends CustomerState {}

final class CustomerLoading extends CustomerState {}

final class CustomerLoaded extends CustomerState {
  final List<CustomerModel> customerData;
  CustomerLoaded({required this.customerData});
}

final class CustomerAddSuccess extends CustomerState {}

final class CustomerUpdateSuccess extends CustomerState {}

final class CustomerDeleteSuccess extends CustomerState {}

final class CustomerError extends CustomerState {}
