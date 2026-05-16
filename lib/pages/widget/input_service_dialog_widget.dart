import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/service_controller.dart';
import 'package:get/get.dart';

class InputServiceDialogWidget extends StatefulWidget {
  final String serviceId;
  final String textName, textCategory, textPrice, textDuration;
  const InputServiceDialogWidget({
    super.key,
    this.serviceId = "",
    this.textName = "",
    this.textCategory = "",
    this.textPrice = "",
    this.textDuration = "",
  });

  @override
  State<InputServiceDialogWidget> createState() =>
      _InputServiceDialogWidgetState();
}

class _InputServiceDialogWidgetState extends State<InputServiceDialogWidget> {
  late TextEditingController inputName;
  String? selectedCategory;
  late TextEditingController inputPrice;
  late TextEditingController inputDuration;
  @override
  void initState() {
    inputName = TextEditingController(text: widget.textName);
    selectedCategory = widget.textCategory.isNotEmpty
        ? widget.textCategory
        : null;
    inputPrice = TextEditingController(text: widget.textPrice);
    inputDuration = TextEditingController(text: widget.textDuration);
    super.initState();
  }

  @override
  void dispose() {
    inputName.dispose();
    inputPrice.dispose();
    inputDuration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.serviceId.isEmpty ? "Tambah Layanan" : "Update Layanan",
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInput(inputName, "Nama Layanan"),
            _buildDropdownCategory(),
            _buildInput(inputPrice, "Harga", isNumber: true),
            _buildInput(inputDuration, "Durasi (hari)", isNumber: true),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Batal")),

        FilledButton(
          onPressed: () async {
            if (selectedCategory == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Kategori harus dipilih")),
              );

              return;
            }
            final serviceController = Get.find<ServiceController>();
            bool success = false;
            if (widget.serviceId.isEmpty) {
              final data = {
                "name": inputName.text,
                "category": selectedCategory,
                "price": int.tryParse(inputPrice.text) ?? 0,
                "min_weight": 4,
                "duration": int.tryParse(inputDuration.text) ?? 0,
              };
              success = await serviceController.createService(data);
            } else {
              final data = {
                "service_id": widget.serviceId,
                "name": inputName.text,
                "category": selectedCategory,
                "price": int.tryParse(inputPrice.text) ?? 0,
                "min_weight": 4,
                "duration": int.tryParse(inputDuration.text) ?? 0,
              };
              success = await serviceController.updateService(data);
            }
            Get.back();
            if (success) {
              showSnackBarWidget(
                context,
                widget.serviceId.isEmpty
                    ? "Berhasil menambahkan layanan!"
                    : "Berhasil update layanan!",
                Theme.of(context).colorScheme.primary,
              );
            }
            // ERROR
            else {
              showSnackBarWidget(
                context,
                serviceController.errorMessage.value,
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

  Widget _buildDropdownCategory() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        initialValue: selectedCategory,
        decoration: InputDecoration(
          labelText: "Kategori",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: const [
          DropdownMenuItem(value: "kiloan", child: Text("Kiloan")),
          DropdownMenuItem(value: "satuan", child: Text("Satuan")),
        ],
        onChanged: (value) {
          setState(() {
            selectedCategory = value;
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
