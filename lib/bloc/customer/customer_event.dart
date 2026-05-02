part of 'customer_bloc.dart';

class CustomerEvent {}

class StartCustomerStream extends CustomerEvent {}

class CustomerStreamError extends CustomerEvent {
  final String message;
  CustomerStreamError(this.message);
}

class GetCustomer extends CustomerEvent {
  final List<CustomerModel> data;
  GetCustomer(this.data);
}

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
