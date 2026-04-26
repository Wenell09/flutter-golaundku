import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/customer/customer_bloc.dart';

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
        widget.customerId.isEmpty ? "Tambah Customer" : "Update Customer",
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInput(inputName, "Nama Customer"),
            _buildInput(inputPhone, "No Telepon", isNumber: true),
            _buildInput(inputAddress, "Alamat"),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        FilledButton(
          onPressed: () {
            if (widget.customerId.isEmpty || widget.customerId == "") {
              final data = {
                "name": inputName.text,
                "phone": inputPhone.text,
                "address": inputAddress.text,
              };
              context.read<CustomerBloc>().add(AddCustomer(data: data));
            } else {
              final data = {
                "customer_id": widget.customerId,
                "name": inputName.text,
                "phone": inputPhone.text,
                "address": inputAddress.text,
              };
              context.read<CustomerBloc>().add(UpdateCustomer(data: data));
            }
            Navigator.pop(context);
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
