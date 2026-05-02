import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_golaundku/models/customer_model.dart';
import 'package:flutter_golaundku/repository/customer_repository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;
  StreamSubscription<List<CustomerModel>>? _subscription;
  List<CustomerModel> allCustomer = [];
  CustomerBloc(this.customerRepository) : super(CustomerInitial()) {
    on<StartCustomerStream>((event, emit) async {
      emit(CustomerLoading());
      await _subscription?.cancel();
      _subscription = customerRepository.streamCustomers().listen(
        (data) {
          add(GetCustomer(data: data));
        },
        onError: (error) {
          add(ErrorCustomerStream(message: error.toString()));
        },
      );
    });

    on<GetCustomer>((event, emit) {
      allCustomer = event.data;
      emit(CustomerLoaded(customerData: allCustomer));
    });

    on<AddCustomer>((event, emit) async {
      try {
        await customerRepository.addCustomer(event.data);
        emit(CustomerAddSuccess());
      } catch (e) {
        emit(CustomerActionError(message: "Gagal menambahkan customer!"));
      }
    });

    on<UpdateCustomer>((event, emit) async {
      try {
        await customerRepository.updateCustomer(event.data);
        emit(CustomerUpdateSuccess());
      } catch (e) {
        emit(CustomerActionError(message: "Gagal mengupdate customer!"));
      }
    });

    on<DeleteCustomer>((event, emit) async {
      try {
        await customerRepository.deleteCustomer(event.customerId);
        emit(CustomerDeleteSuccess());
      } catch (e) {
        emit(CustomerActionError(message: "Gagal menghapus customer!"));
      }
    });

    on<SearchCustomer>((event, emit) {
      final keyword = event.keyword.toLowerCase().trim();
      if (keyword.isEmpty) {
        emit(CustomerLoaded(customerData: allCustomer));
        return;
      }
      final filtered = allCustomer.where((service) {
        return service.name.toLowerCase().contains(keyword);
      }).toList();
      emit(CustomerLoaded(customerData: filtered));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
