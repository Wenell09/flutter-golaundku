import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/service_controller.dart';
import 'package:flutter_golaundku/pages/widget/input_service_dialog_widget.dart';
import 'package:get/get.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});
  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  late TextEditingController inputSearchLayanan;
  final serviceController = Get.find<ServiceController>();
  final keyword = "".obs;

  @override
  void initState() {
    super.initState();
    inputSearchLayanan = TextEditingController();
  }

  @override
  void dispose() {
    inputSearchLayanan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        TextField(
          controller: inputSearchLayanan,
          onChanged: (value) {
            keyword.value = value.toLowerCase();
          },
          decoration: InputDecoration(
            filled: true,
            prefixIcon: const Icon(Icons.search),
            fillColor: Theme.of(context).colorScheme.onPrimary,
            hintText: "Cari Layanan...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 20),
        Obx(() {
          final filteredData = serviceController.serviceData.where((data) {
            return data.serviceId.toLowerCase().contains(keyword.value) ||
                data.nameService.toLowerCase().contains(keyword.value);
          }).toList();
          if (serviceController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (serviceController.streamError.value.isNotEmpty) {
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
          if (serviceController.serviceData.isEmpty) {
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
                    "daftar layanan kosong!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }
          if (filteredData.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 100),
                  Text(
                    "Layanan tidak ditemukan!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              final data = filteredData[index];
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
                              data.nameService,
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
                                InputServiceDialogWidget(
                                  serviceId: data.serviceId,
                                  textName: data.nameService,
                                  textCategory: data.category,
                                  textPrice: data.price.toString(),
                                  textDuration: data.duration.toString(),
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
                                  title: const Text("Hapus Layanan"),
                                  content: const Text(
                                    "Apakah kamu yakin ingin menghapus layanan ini?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text("Batal"),
                                    ),
                                    FilledButton(
                                      onPressed: () async {
                                        Get.back();
                                        final success = await serviceController
                                            .deleteService(data.serviceId);
                                        if (success) {
                                          showSnackBarWidget(
                                            context,
                                            "Berhasil menghapus layanan!",
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          );
                                        } else {
                                          showSnackBarWidget(
                                            context,
                                            serviceController.actionError.value,
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
                      Text(
                        data.category,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.discount_outlined,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                (data.category.toLowerCase() == "kiloan")
                                    ? "Rp ${data.price} / kg"
                                    : "Rp ${data.price} / (pcs,set)",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.watch_later_outlined,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${data.duration} Hari",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w500),
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
