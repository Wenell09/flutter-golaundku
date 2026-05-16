import 'dart:async';

import 'package:flutter_golaundku/models/service_model.dart';
import 'package:flutter_golaundku/repository/service_repository.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController {
  final ServiceRepository serviceRepository;

  ServiceController(this.serviceRepository);

  StreamSubscription<List<ServiceModel>>? _subscription;

  final isLoading = false.obs;
  final streamError = ''.obs;
  final actionError = ''.obs;
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
      streamError.value = '';
      await _subscription?.cancel();
      _subscription = serviceRepository.streamServices().listen(
        (data) {
          allServices.assignAll(data);
          serviceData.assignAll(data);
          streamError.value = '';
          isLoading.value = false;
        },
        onError: (error) {
          streamError.value = error.toString();
          isLoading.value = false;
        },
      );
    } catch (e) {
      streamError.value = "Gagal memuat data layanan";
      isLoading.value = false;
    }
  }

  Future<bool> createService(Map<String, dynamic> data) async {
    try {
      actionError.value = '';
      await serviceRepository.addService(data);
      return true;
    } catch (e) {
      actionError.value = "Gagal menambahkan layanan!";
      return false;
    }
  }

  Future<bool> updateService(Map<String, dynamic> data) async {
    try {
      actionError.value = '';
      await serviceRepository.updateService(data);
      return true;
    } catch (e) {
      actionError.value = "Gagal mengupdate layanan!";
      return false;
    }
  }

  Future<bool> deleteService(String serviceId) async {
    try {
      actionError.value = '';
      await serviceRepository.deleteService(serviceId);
      return true;
    } catch (e) {
      actionError.value = "Gagal menghapus layanan!";
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
