import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/customer_controller.dart';
import 'package:get/get.dart';

class InputCustomerDialogWidget extends StatefulWidget {
  final String customerId;
  final String textName, textPhone, textAddress;
  const InputCustomerDialogWidget({
    super.key,
    this.customerId = "",
    this.textName = "",
    this.textPhone = "",
    this.textAddress = "",
  });

  @override
  State<InputCustomerDialogWidget> createState() =>
      _InputCustomerDialogWidgetState();
}

class _InputCustomerDialogWidgetState extends State<InputCustomerDialogWidget> {
  late TextEditingController inputName;
  late TextEditingController inputPhone;
  late TextEditingController inputAddress;
  @override
  void initState() {
    inputName = TextEditingController(text: widget.textName);
    inputPhone = TextEditingController(text: widget.textPhone);
    inputAddress = TextEditingController(text: widget.textAddress);
    super.initState();
  }

  @override
  void dispose() {
    inputName.dispose();
    inputPhone.dispose();
    inputAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.customerId.isEmpty ? "Tambah Pelanggan" : "Update Pelanggan",
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInput(inputName, "Nama Pelanggan"),
            _buildInput(inputPhone, "No Telepon", isNumber: true),
            _buildInput(inputAddress, "Alamat"),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
        FilledButton(
          onPressed: () async {
            final customerController = Get.find<CustomerController>();
            bool success = false;
            if (widget.customerId.isEmpty) {
              final data = {
                "name": inputName.text,
                "phone": inputPhone.text,
                "address": inputAddress.text,
              };
              success = await customerController.createCustomer(data);
            } else {
              final data = {
                "customer_id": widget.customerId,
                "name": inputName.text,
                "phone": inputPhone.text,
                "address": inputAddress.text,
              };
              success = await customerController.updateCustomer(data);
            }
            Get.back();
            if (success) {
              showSnackBarWidget(
                context,
                widget.customerId.isEmpty
                    ? "Berhasil menambahkan pelanggan!"
                    : "Berhasil update pelanggan!",
                Theme.of(context).colorScheme.primary,
              );
            }
            // ERROR
            else {
              showSnackBarWidget(
                context,
                customerController.actionError.value,
                Theme.of(context).colorScheme.error,
              );
            }
          },

          child: const Text("Simpan"),
        ),
      ],
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

void showSnackBarWidget(BuildContext context, String text, Color colors) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: colors,
      duration: Duration(seconds: 1),
      content: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    ),
  );
}
