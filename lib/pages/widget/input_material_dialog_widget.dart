import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/material/material_bloc.dart';

class InputMaterialDialogWidget extends StatefulWidget {
  final String materialId;
  final String textName, textStock, textUnit, textMinStock;
  const InputMaterialDialogWidget({
    super.key,
    this.materialId = "",
    this.textName = "",
    this.textStock = "",
    this.textUnit = "",
    this.textMinStock = "",
  });

  @override
  State<InputMaterialDialogWidget> createState() =>
      _InputMaterialDialogWidgetState();
}

class _InputMaterialDialogWidgetState extends State<InputMaterialDialogWidget> {
  late TextEditingController inputName;
  late TextEditingController inputStock;
  late TextEditingController inputUnit;
  late TextEditingController inputMinStock;
  @override
  void initState() {
    inputName = TextEditingController(text: widget.textName);
    inputStock = TextEditingController(text: widget.textStock);
    inputUnit = TextEditingController(text: widget.textUnit);
    inputMinStock = TextEditingController(text: widget.textMinStock);
    super.initState();
  }

  @override
  void dispose() {
    inputName.dispose();
    inputStock.dispose();
    inputUnit.dispose();
    inputMinStock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.materialId.isEmpty ? "Tambah Stok Barang" : "Update Stok Barang",
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInput(inputName, "Nama Barang"),
            _buildInput(inputStock, "Stok", isNumber: true),
            _buildInput(inputUnit, "Unit(liter/pack/pcs/dll)"),
            _buildInput(inputMinStock, "Minimal Stok", isNumber: true),
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
            if (widget.materialId.isEmpty || widget.materialId == "") {
              final data = {
                "name": inputName.text,
                "stock": inputStock.text,
                "unit": inputUnit.text,
                "min_stock": inputMinStock.text,
              };
              context.read<MaterialBloc>().add(AddMaterial(data: data));
            } else {
              final data = {
                "material_id": widget.materialId,
                "name": inputName.text,
                "stock": inputStock.text,
                "unit": inputUnit.text,
                "min_stock": inputMinStock.text,
              };
              context.read<MaterialBloc>().add(UpdateMaterial(data: data));
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
