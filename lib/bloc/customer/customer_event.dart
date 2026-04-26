part of 'customer_bloc.dart';

class CustomerEvent {}

class GetCustomer extends CustomerEvent {}

class AddCustomer extends CustomerEvent {
  final Map<String, dynamic> data;
  AddCustomer({required this.data});
}

class UpdateCustomer extends CustomerEvent {
  final Map<String, dynamic> data;
  UpdateCustomer({required this.data});
}

class DeleteCustomer extends CustomerEvent {
  final String customerId;
  DeleteCustomer({required this.customerId});
}

class SearchCustomer extends CustomerEvent {
  final String keyword;
  SearchCustomer({required this.keyword});
}
