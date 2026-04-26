import 'package:bloc/bloc.dart';
import 'package:flutter_golaundku/models/customer_model.dart';
import 'package:flutter_golaundku/repository/customer_repository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;
  CustomerBloc(this.customerRepository) : super(CustomerInitial()) {
    List<CustomerModel> allCustomer = [];
    on<GetCustomer>((event, emit) async {
      emit(CustomerLoading());
      try {
        final customerData = await customerRepository.getCustomer();
        allCustomer = customerData;
        emit(CustomerLoaded(customerData: allCustomer));
      } catch (e) {
        emit(CustomerError());
      }
    });

    on<AddCustomer>((event, emit) async {
      emit(CustomerLoading());
      try {
        await customerRepository.addCustomer(event.data);
        emit(CustomerAddSuccess());
        add(GetCustomer());
      } catch (e) {
        emit(CustomerError());
      }
    });

    on<UpdateCustomer>((event, emit) async {
      emit(CustomerLoading());
      try {
        await customerRepository.updateCustomer(event.data);
        emit(CustomerUpdateSuccess());
        add(GetCustomer());
      } catch (e) {
        emit(CustomerError());
      }
    });

    on<DeleteCustomer>((event, emit) async {
      emit(CustomerLoading());
      try {
        await customerRepository.deleteCustomer(event.customerId);
        emit(CustomerDeleteSuccess());
        add(GetCustomer());
      } catch (e) {
        emit(CustomerError());
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
}
