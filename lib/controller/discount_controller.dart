import 'dart:async';

import 'package:flutter_golaundku/models/discount_model.dart';
import 'package:flutter_golaundku/repository/discount_repository.dart';
import 'package:get/get.dart';

class DiscountController extends GetxController {
  final DiscountRepository discountRepository;
  DiscountController(this.discountRepository);
  StreamSubscription<List<DiscountModel>>? _subscription;
  final isLoading = false.obs;
  final streamError = ''.obs;
  final actionError = ''.obs;
  final discountData = <DiscountModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    streamDiscounts();
  }

  Future<void> streamDiscounts() async {
    try {
      isLoading.value = true;
      streamError.value = '';
      await _subscription?.cancel();
      _subscription = discountRepository.streamDiscounts().listen(
        (data) {
          discountData.assignAll(data);
          isLoading.value = false;
        },
        onError: (error) {
          streamError.value = error.toString();
          isLoading.value = false;
        },
      );
    } catch (e) {
      streamError.value = e.toString();
      isLoading.value = false;
    }
  }

  Future<bool> createDiscount(Map<String, dynamic> data) async {
    try {
      actionError.value = '';
      await discountRepository.addDiscount(data);
      return true;
    } catch (e) {
      actionError.value = "Gagal menambahkan diskon!";
      return false;
    }
  }

  Future<bool> updateDiscount(Map<String, dynamic> data) async {
    try {
      actionError.value = '';
      await discountRepository.updateDiscount(data);
      return true;
    } catch (e) {
      actionError.value = "Gagal mengupdate diskon!";
      return false;
    }
  }

  Future<bool> deleteDiscount(String discountId) async {
    try {
      actionError.value = '';
      await discountRepository.deleteDiscount(discountId);
      return true;
    } catch (e) {
      actionError.value = "Gagal menghapus diskon!";
      return false;
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
