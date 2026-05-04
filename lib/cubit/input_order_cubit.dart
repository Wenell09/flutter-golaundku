import 'package:bloc/bloc.dart';
import 'package:flutter_golaundku/models/discount_model.dart';
import 'package:flutter_golaundku/models/order_item.dart';
import 'package:flutter_golaundku/models/service_form_item.dart';
import 'package:flutter_golaundku/models/service_model.dart';
import 'package:uuid/uuid.dart';

part 'input_order_state.dart';

class InputOrderCubit extends Cubit<InputOrderState> {
  InputOrderCubit() : super(InputOrderState(formItems: [ServiceFormItem()]));

  List<OrderItem> buildOrderItems(List<ServiceModel> services) {
    final state = this.state;
    final List<OrderItem> items = [];
    if (state.selectedKiloan != null && state.berat.isNotEmpty) {
      final service = services.firstWhere(
        (e) => e.serviceId == state.selectedKiloan,
      );
      final qtyKg = double.tryParse(state.berat) ?? 0;
      //  ubah ke gram (integer)
      final qtyGram = (qtyKg * 1000).round();
      // hitung tanpa float
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
    for (final item in state.formItems) {
      if (item.selectedServiceId == null) continue;
      final service = services.firstWhere(
        (e) => e.serviceId == item.selectedServiceId,
      );
      final qty = int.tryParse(item.qtyController.text) ?? 0;
      if (qty == 0) continue;
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

  String? validateForm(InputOrderState state, List<ServiceModel> services) {
    if (state.selectedCustomer == null) {
      return "Pelanggan belum dipilih";
    }
    if (state.selectedPayment == null) {
      return "Metode pembayaran belum dipilih";
    }
    bool isKiloanValid = false;
    if (state.selectedKiloan != null && state.berat.isNotEmpty) {
      final service = services.firstWhere(
        (e) => e.serviceId == state.selectedKiloan,
      );
      final qty = double.tryParse(state.berat) ?? 0;
      if (qty < service.minWeight) {
        return "Minimal berat ${service.minWeight} Kg";
      }
      isKiloanValid = true;
    }
    bool isSatuanValid = false;
    for (int i = 0; i < state.formItems.length; i++) {
      final item = state.formItems[i];
      final qtyText = item.qtyController.text.trim();
      final qty = int.tryParse(qtyText) ?? 0;
      if (item.selectedServiceId != null || qtyText.isNotEmpty) {
        if (item.selectedServiceId == null) {
          return "Pilih layanan satuan pada item ke-${i + 1}";
        }
        if (qtyText.isEmpty || qty <= 0) {
          return "Qty pada item ke-${i + 1} harus lebih dari 0";
        }
        isSatuanValid = true;
      }
    }
    if (!isKiloanValid && !isSatuanValid) {
      return "Minimal pilih layanan kiloan atau satuan";
    }
    return null;
  }

  void selectCustomer(String? value) {
    emit(state.copyWith(selectedCustomer: value));
  }

  void selectKiloan(String? value) {
    emit(state.copyWith(selectedKiloan: value));
  }

  void selectPaymentMethod(String? value) {
    emit(state.copyWith(selectedPayment: value));
  }

  void inputBerat(String value) {
    emit(state.copyWith(berat: value));
  }

  void selectDiscount(DiscountModel? discount) {
    emit(state.copyWith(selectedDiscount: discount));
  }

  void addFormItem() {
    final updated = List<ServiceFormItem>.from(state.formItems)
      ..add(ServiceFormItem());
    emit(state.copyWith(formItems: updated));
  }

  void removeFormItem(int index) {
    final updated = List<ServiceFormItem>.from(state.formItems);
    updated[index].qtyController.dispose();
    updated.removeAt(index);
    emit(state.copyWith(formItems: updated));
  }

  void updateService(int index, String? serviceId) {
    final updated = List<ServiceFormItem>.from(state.formItems);
    updated[index].selectedServiceId = serviceId;
    emit(state.copyWith(formItems: updated));
  }

  void updateQty(int index, String value) {
    final updated = List<ServiceFormItem>.from(state.formItems);
    updated[index].qtyController.text = value;
    emit(state.copyWith(formItems: updated));
  }

  void resetForm() {
    for (final item in state.formItems) {
      item.qtyController.dispose();
    }
    emit(
      InputOrderState(
        selectedCustomer: null,
        selectedKiloan: null,
        selectedPayment: null,
        selectedDiscount: null,
        berat: '',
        formItems: [ServiceFormItem()],
      ),
    );
  }
}
