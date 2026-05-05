part of 'input_order_cubit.dart';

class InputOrderState {
  final String? selectedCustomer;
  final String? selectedKiloan;
  final String? selectedPayment;
  final DiscountModel? selectedDiscount;
  final String berat;
  final List<ServiceFormItem> formItems;
  final String catatan;

  InputOrderState({
    this.selectedCustomer,
    this.selectedKiloan,
    this.selectedPayment,
    this.selectedDiscount,
    this.berat = '',
    this.formItems = const [],
    this.catatan = '',
  });

  InputOrderState copyWith({
    String? selectedCustomer,
    String? selectedKiloan,
    String? selectedPayment,
    DiscountModel? selectedDiscount,
    String? berat,
    List<ServiceFormItem>? formItems,
    String? catatan,
  }) {
    return InputOrderState(
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
      selectedKiloan: selectedKiloan ?? this.selectedKiloan,
      selectedPayment: selectedPayment ?? this.selectedPayment,
      selectedDiscount: selectedDiscount ?? this.selectedDiscount,
      berat: berat ?? this.berat,
      formItems: formItems ?? this.formItems,
      catatan: catatan ?? this.catatan,
    );
  }
}
