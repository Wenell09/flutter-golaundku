import 'dart:async';

import 'package:flutter_golaundku/models/service_model.dart';
import 'package:flutter_golaundku/repository/service_repository.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController {
  final ServiceRepository serviceRepository;
  ServiceController(this.serviceRepository);
  StreamSubscription<List<ServiceModel>>? _subscription;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final allServices = <ServiceModel>[].obs;
  final serviceData = <ServiceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    streamServices();
  }

  Future<void> streamServices() async {
    try {
      isLoading.value = true;
      await _subscription?.cancel();
      _subscription = serviceRepository.streamServices().listen(
        (data) {
          allServices.assignAll(data);
          serviceData.assignAll(data);
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

  Future<bool> createService(Map<String, dynamic> data) async {
    try {
      await serviceRepository.addService(data);
      return true;
    } catch (e) {
      errorMessage.value = "gagal menambahkan layanan!";
      return false;
    }
  }

  Future<bool> updateService(Map<String, dynamic> data) async {
    try {
      await serviceRepository.updateService(data);
      return true;
    } catch (e) {
      errorMessage.value = "gagal mengupdate layanan!";
      return false;
    }
  }

  Future<bool> deleteService(String serviceId) async {
    try {
      await serviceRepository.deleteService(serviceId);
      return true;
    } catch (e) {
      errorMessage.value = "gagal menghapus layanan!";
      return false;
    }
  }

  void searchService(String keyword) {
    final query = keyword.toLowerCase().trim();
    if (query.isEmpty) {
      serviceData.assignAll(allServices);
      return;
    }

    final filtered = allServices.where((service) {
      return service.name.toLowerCase().contains(query);
    }).toList();
    serviceData.assignAll(filtered);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
