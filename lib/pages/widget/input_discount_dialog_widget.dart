import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_golaundku/controller/discount_controller.dart';
import 'package:get/get.dart';

class InputDiscountDialogWidget extends StatefulWidget {
  final String discountId;
  final String textName, textType, textValue;
  final bool isActive;
  const InputDiscountDialogWidget({
    super.key,
    this.discountId = "",
    this.textName = "",
    this.textType = "",
    this.textValue = "",
    this.isActive = false,
  });

  @override
  State<InputDiscountDialogWidget> createState() =>
      _InputDiscountDialogWidgetState();
}

class _InputDiscountDialogWidgetState extends State<InputDiscountDialogWidget> {
  late TextEditingController inputName;
  late TextEditingController inputValue;
  late bool selectedActive;
  String? selectedType;

  @override
  void initState() {
    inputName = TextEditingController(text: widget.textName);
    inputValue = TextEditingController(text: widget.textValue);
    selectedActive = widget.isActive;
    selectedType = widget.textType.isNotEmpty ? widget.textType : null;
    super.initState();
  }

  @override
  void dispose() {
    inputName.dispose();
    inputValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.discountId.isEmpty ? "Tambah Discount" : "Edit Discount",
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInput(inputName, "Nama Diskon"),
            _buildDropdownCategory(),
            _buildInput(inputValue, "Nilai Diskon", isNumber: true),
            SwitchListTile(
              title: const Text("Status Aktif"),
              subtitle: Text(
                selectedActive ? "Diskon Aktif" : "Diskon Non-Aktif",
              ),
              value: selectedActive,
              onChanged: (bool value) {
                setState(() {
                  selectedActive = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
        FilledButton(
          onPressed: () async {
            int val = int.tryParse(inputValue.text) ?? 0;
            if (selectedType == "percentage") {
              if (val < 1 || val > 100) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Nilai persen harus di antara 1 - 100"),
                  ),
                );
                return;
              }
            }
            final discountController = Get.find<DiscountController>();
            bool success = false;
            if (widget.discountId.isEmpty) {
              final data = {
                "name": inputName.text,
                "type": selectedType,
                "value": val,
                "active": selectedActive,
              };
              success = await discountController.createDiscount(data);
            } else {
              final data = {
                "discount_id": widget.discountId,
                "name": inputName.text,
                "type": selectedType,
                "value": val,
                "active": selectedActive,
              };
              success = await discountController.updateDiscount(data);
            }
            Get.back();
            if (success) {
              showSnackBarWidget(
                context,
                widget.discountId.isEmpty
                    ? "Berhasil menambahkan discount!"
                    : "Berhasil update discount!",
                Theme.of(context).colorScheme.primary,
              );
            } else {
              showSnackBarWidget(
                context,
                discountController.actionError.value,
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
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixText: (label == "Nilai Diskon" && selectedType == "percentage")
              ? "%"
              : null,
        ),
      ),
    );
  }

  Widget _buildDropdownCategory() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: selectedType,
        decoration: InputDecoration(
          labelText: "Tipe",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: const [
          DropdownMenuItem(value: "percentage", child: Text("Persen")),
          DropdownMenuItem(value: "fixed", child: Text("Nominal Rupiah")),
        ],
        onChanged: (value) {
          setState(() {
            selectedType = value;
          });
        },
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
