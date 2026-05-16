import 'dart:async';

import 'package:flutter_golaundku/models/customer_model.dart';
import 'package:flutter_golaundku/repository/customer_repository.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  final CustomerRepository customerRepository;
  CustomerController(this.customerRepository);
  StreamSubscription<List<CustomerModel>>? _subscription;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final allCustomer = <CustomerModel>[].obs;
  final customerData = <CustomerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    streamCustomers();
  }

  Future<void> streamCustomers() async {
    try {
      isLoading.value = true;
      await _subscription?.cancel();
      _subscription = customerRepository.streamCustomers().listen(
        (data) {
          allCustomer.assignAll(data);
          customerData.assignAll(data);
          isLoading.value = false;
        },
        onError: (error) {
          errorMessage.value = error.toString();
          isLoading.value = false;
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  Future<bool> createCustomer(Map<String, dynamic> data) async {
    try {
      await customerRepository.addCustomer(data);
      return true;
    } catch (e) {
      errorMessage.value = "Gagal menambahkan customer!";
      return false;
    }
  }

  Future<bool> updateCustomer(Map<String, dynamic> data) async {
    try {
      await customerRepository.updateCustomer(data);
      return true;
    } catch (e) {
      errorMessage.value = "Gagal mengupdate customer!";
      return false;
    }
  }

  Future<bool> deleteCustomer(String customerId) async {
    try {
      await customerRepository.deleteCustomer(customerId);
      return true;
    } catch (e) {
      errorMessage.value = "Gagal menghapus customer!";
      return false;
    }
  }

  void searchCustomer(String keyword) {
    final query = keyword.toLowerCase().trim();
    if (query.isEmpty) {
      customerData.assignAll(allCustomer);
      return;
    }
    final filtered = allCustomer.where((data) {
      return data.name.toLowerCase().contains(query);
    }).toList();
    customerData.assignAll(filtered);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
