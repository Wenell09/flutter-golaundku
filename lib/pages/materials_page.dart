import 'package:flutter/material.dart' hide MaterialState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/material/material_bloc.dart';
import 'package:flutter_golaundku/pages/widget/input_material_dialog_widget.dart';

class MaterialsPage extends StatefulWidget {
  const MaterialsPage({super.key});

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  late TextEditingController inputSearchProduct;
  @override
  void initState() {
    context.read<MaterialBloc>().add(GetMaterial());
    inputSearchProduct = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    inputSearchProduct.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MaterialBloc, MaterialState>(
      listener: (context, state) {
        if (state is MaterialAddSuccess) {
          showSnackBarWidget(context, "Berhasil menambahkan barang baru!");
        } else if (state is MaterialUpdateSuccess) {
          showSnackBarWidget(context, "Berhasil update barang!");
        } else if (state is MaterialDeleteSuccess) {
          showSnackBarWidget(context, "Berhasil menghapus barang!");
        } else if (state is MaterialError) {
          context.read<MaterialBloc>().add(GetMaterial());
        }
      },
      child: ListView(
        padding: EdgeInsets.all(15),
        children: [
          TextField(
            onChanged: (value) {
              context.read<MaterialBloc>().add(SearchMaterial(keyword: value));
            },
            decoration: InputDecoration(
              filled: true,
              prefixIcon: Icon(Icons.search),
              fillColor: Theme.of(context).colorScheme.onPrimary,
              hintText: "Cari Barang...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<MaterialBloc, MaterialState>(
            builder: (context, state) {
              if (state is MaterialLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is MaterialLoaded) {
                if (state.materialData.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .center,
                      children: [
                        Icon(
                          Icons.warning,
                          color: Theme.of(context).colorScheme.error,
                          size: 100,
                        ),
                        Text(
                          "daftar barang kosong!",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final data = state.materialData[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: .start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    data.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          InputMaterialDialogWidget(
                                            materialId: data.materialId,
                                            textName: data.name,
                                            textStock: data.stock.toString(),
                                            textUnit: data.unit,
                                            textMinStock: data.minStock
                                                .toString(),
                                          ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Hapus Barang"),
                                          content: const Text(
                                            "Apakah kamu yakin ingin menghapus barang ini?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text("Batal"),
                                            ),
                                            FilledButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                context
                                                    .read<MaterialBloc>()
                                                    .add(
                                                      DeleteMaterial(
                                                        materialId:
                                                            data.materialId,
                                                      ),
                                                    );
                                              },
                                              style: FilledButton.styleFrom(
                                                backgroundColor: Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                              ),
                                              child: const Text("Hapus"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Min Stock: ${data.minStock} ${data.unit}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.inventory,
                                      size: 20,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Stok Saat Ini:",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    Text(
                                      "${data.stock} ${data.unit}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: state.materialData.length,
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  void showSnackBarWidget(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
}
