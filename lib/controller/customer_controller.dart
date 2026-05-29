import 'dart:async';

import 'package:flutter_golaundku/models/customer_model.dart';
import 'package:flutter_golaundku/repository/customer_repository.dart';
import 'package:get/get.dart';

class CustomerController extends GetxController {
  final CustomerRepository customerRepository;
  CustomerController(this.customerRepository);

  StreamSubscription<List<CustomerModel>>? _subscription;

  final isLoading = false.obs;
  final streamError = ''.obs;
  final actionError = ''.obs;

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
      streamError.value = '';
      await _subscription?.cancel();
      _subscription = customerRepository.streamCustomers().listen(
        (data) {
          allCustomer.assignAll(data);
          customerData.assignAll(data);
          streamError.value = '';
          isLoading.value = false;
        },
        onError: (error) {
          streamError.value = error.toString();
          isLoading.value = false;
        },
      );
    } catch (e) {
      streamError.value = "Gagal memuat data pelanggan";
      isLoading.value = false;
    }
  }

  Future<bool> createCustomer(Map<String, dynamic> data) async {
    try {
      actionError.value = '';
      await customerRepository.addCustomer(data);
      return true;
    } catch (e) {
      actionError.value = "Gagal menambahkan pelanggan!";
      return false;
    }
  }

  Future<bool> updateCustomer(Map<String, dynamic> data) async {
    try {
      actionError.value = '';
      await customerRepository.updateCustomer(data);
      return true;
    } catch (e) {
      actionError.value = "Gagal mengupdate pelanggan!";
      return false;
    }
  }

  Future<bool> deleteCustomer(String customerId) async {
    try {
      actionError.value = '';
      await customerRepository.deleteCustomer(customerId);
      return true;
    } catch (e) {
      actionError.value = "Gagal menghapus pelanggan!";
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
