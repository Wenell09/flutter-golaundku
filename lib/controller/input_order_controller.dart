import 'package:flutter/material.dart';
import 'package:flutter_golaundku/models/discount_model.dart';
import 'package:flutter_golaundku/models/order_item.dart';
import 'package:flutter_golaundku/models/service_form_item.dart';
import 'package:flutter_golaundku/models/service_model.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class InputOrderController extends GetxController {
  final beratController = TextEditingController();
  var selectedCustomer = RxnString();
  var selectedKiloan = RxnString();
  var selectedPayment = RxnString();
  var selectedDiscount = Rxn<DiscountModel>();
  var berat = ''.obs;
  var catatan = ''.obs;
  var formItems = <ServiceFormItem>[ServiceFormItem()].obs;

  void selectCustomer(String? value) {
    selectedCustomer.value = value;
  }

  void selectKiloan(String? value) {
    selectedKiloan.value = value;
  }

  void selectPaymentMethod(String? value) {
    selectedPayment.value = value;
  }

  void inputBerat(String value) {
    berat.value = value;
  }

  void inputCatatan(String value) {
    catatan.value = value;
  }

  void selectDiscount(DiscountModel? discount) {
    selectedDiscount.value = discount;
  }

  void addFormItem() {
    formItems.add(ServiceFormItem());
  }

  void removeFormItem(int index) {
    formItems[index].qtyController.dispose();
    formItems.removeAt(index);
  }

  void updateService(int index, String? serviceId) {
    final item = formItems[index];
    item.selectedServiceId = serviceId;
    formItems[index] = item;
    formItems.refresh();
  }

  void updateQty(int index, String value) {
    formItems[index].qtyController.text = value;
    formItems.refresh();
  }

  void resetForm() {
    for (final item in formItems) {
      item.qtyController.dispose();
    }

    selectedCustomer.value = null;
    selectedKiloan.value = null;
    selectedPayment.value = null;
    selectedDiscount.value = null;
    berat.value = '';
    beratController.clear();
    catatan.value = '';
    formItems.value = [ServiceFormItem()];
  }

  List<OrderItem> buildOrderItems(List<ServiceModel> services) {
    final List<OrderItem> items = [];
    if (selectedKiloan.value != null && berat.value.isNotEmpty) {
      final service = services.firstWhere(
        (e) => e.serviceId == selectedKiloan.value,
      );
      final qtyKg = double.tryParse(berat.value) ?? 0;
      final qtyGram = (qtyKg * 1000).round();
      final subtotal = (qtyGram * service.price) ~/ 1000;
      items.add(
        OrderItem(
          orderItemId: Uuid().v4(),
          serviceId: service.serviceId,
          quantity: qtyKg,
          pricePerUnit: service.price,
          subtotal: subtotal,
          deliveryStatus: false,
        ),
      );
    }
    for (final item in formItems) {
      if (item.selectedServiceId == null) continue;
      final service = services.firstWhere(
        (e) => e.serviceId == item.selectedServiceId,
      );
      final qty = int.tryParse(item.qtyController.text) ?? 0;
      if (qty <= 0) continue;
      items.add(
        OrderItem(
          orderItemId: Uuid().v4(),
          serviceId: service.serviceId,
          quantity: qty.toDouble(),
          pricePerUnit: service.price,
          subtotal: qty * service.price,
          deliveryStatus: false,
        ),
      );
    }
    return items;
  }

  String? validateForm(List<ServiceModel> services) {
    if (selectedCustomer.value == null) {
      return "Pelanggan belum dipilih";
    }
    bool hasKiloan = false;
    bool hasSatuan = false;
    if (selectedKiloan.value != null && berat.value.isNotEmpty) {
      final service = services.firstWhere(
        (e) => e.serviceId == selectedKiloan.value,
      );
      final qty = double.tryParse(berat.value) ?? 0;
      if (qty < service.minWeight) {
        return "Minimal berat ${service.minWeight} Kg";
      }
      hasKiloan = true;
    }
    for (int i = 0; i < formItems.length; i++) {
      final item = formItems[i];
      final qtyText = item.qtyController.text.trim();
      final qty = int.tryParse(qtyText) ?? 0;
      if (item.selectedServiceId != null || qtyText.isNotEmpty) {
        if (item.selectedServiceId == null) {
          return "Pilih layanan satuan pada item ke-${i + 1}";
        }
        if (qty <= 0) {
          return "Jumlah pada item ke-${i + 1} harus lebih dari 0";
        }
        hasSatuan = true;
      }
    }
    if (!hasKiloan && !hasSatuan) {
      return "Minimal pilih layanan kiloan atau satuan";
    }
    if (selectedPayment.value == null) {
      return "Metode pembayaran belum dipilih";
    }
    return null;
  }

  @override
  void onClose() {
    beratController.dispose();
    super.onClose();
  }
}
