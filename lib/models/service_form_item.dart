import 'package:flutter/material.dart';

class ServiceFormItem {
  String? selectedServiceId;
  final TextEditingController qtyController = TextEditingController();

  @override
  String toString() {
    return 'ServiceFormItem(serviceId: $selectedServiceId, qty: ${qtyController.text})';
  }
}

List<ServiceFormItem> formItems = [ServiceFormItem()];
