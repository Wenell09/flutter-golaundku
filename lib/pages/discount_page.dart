import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/discount_controller.dart';
import 'package:flutter_golaundku/pages/widget/input_discount_dialog_widget.dart';
import 'package:get/get.dart';

class DiscountPage extends StatelessWidget {
  DiscountPage({super.key});
  final discountController = Get.find<DiscountController>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        const SizedBox(height: 20),
        Obx(() {
          if (discountController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (discountController.streamError.value.isNotEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    color: Theme.of(context).colorScheme.error,
                    size: 100,
                  ),
                  Text(
                    "Koneksi realtime bermasalah",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }
          if (discountController.discountData.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    color: Theme.of(context).colorScheme.error,
                    size: 100,
                  ),
                  Text(
                    "daftar pelanggan kosong!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: discountController.discountData.length,
            itemBuilder: (context, index) {
              final data = discountController.discountData[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data.nameDiscount,
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.dialog(
                                InputDiscountDialogWidget(
                                  discountId: data.discountId,
                                  textName: data.nameDiscount,
                                  textType: data.type,
                                  textValue: data.value.toString(),
                                  isActive: data.active,
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text("Hapus Discount"),
                                  content: const Text(
                                    "Apakah kamu yakin ingin menghapus discount ini?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text("Batal"),
                                    ),
                                    FilledButton(
                                      onPressed: () async {
                                        Get.back();
                                        final success = await discountController
                                            .deleteDiscount(data.discountId);
                                        if (success) {
                                          showSnackBarWidget(
                                            context,
                                            "Berhasil menghapus discount!",
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          );
                                        } else {
                                          showSnackBarWidget(
                                            context,
                                            discountController
                                                .actionError
                                                .value,
                                            Theme.of(context).colorScheme.error,
                                          );
                                        }
                                      },
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                      child: const Text("Hapus"),
                                    ),
                                  ],
                                ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.discount,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                data.type == "fixed"
                                    ? "Rp ${data.value}"
                                    : "${data.value}%",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Status:",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                data.active ? "Aktif" : "Tidak Aktif",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: data.active
                                          ? Colors.green
                                          : Colors.red,
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
          );
        }),
      ],
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
