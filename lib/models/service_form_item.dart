import 'package:flutter/material.dart';

class ServiceFormItem {
  String? selectedServiceId;
  final TextEditingController qtyController = TextEditingController();
}

List<ServiceFormItem> formItems = [ServiceFormItem()];
