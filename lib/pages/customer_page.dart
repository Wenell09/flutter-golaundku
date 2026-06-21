import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/customer_controller.dart';
import 'package:flutter_golaundku/pages/widget/input_customer_dialog_widget.dart';
import 'package:get/get.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  late TextEditingController inputSearchCustomer;
  final customerController = Get.find<CustomerController>();
  final keyword = ''.obs;

  @override
  void initState() {
    super.initState();
    inputSearchCustomer = TextEditingController();
  }

  @override
  void dispose() {
    inputSearchCustomer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        TextField(
          controller: inputSearchCustomer,
          onChanged: (value) {
            keyword.value = value.toLowerCase();
          },
          decoration: InputDecoration(
            filled: true,
            prefixIcon: const Icon(Icons.search),
            fillColor: Theme.of(context).colorScheme.onPrimary,
            hintText: "Cari Pelanggan...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 20),
        Obx(() {
          final filteredData = customerController.customerData.where((data) {
            return data.customerId.toLowerCase().contains(keyword.value) ||
                data.name.toLowerCase().contains(keyword.value);
          }).toList();
          if (customerController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (customerController.streamError.value.isNotEmpty) {
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
          if (customerController.customerData.isEmpty) {
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
          if (filteredData.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 100),
                  Text(
                    "Order tidak ditemukan!",
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
                              data.name,
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
                                InputCustomerDialogWidget(
                                  customerId: data.customerId,
                                  textName: data.name,
                                  textPhone: data.phone,
                                  textAddress: data.address,
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
                                  title: const Text("Hapus Pelanggan"),
                                  content: const Text(
                                    "Apakah kamu yakin ingin menghapus pelanggan ini?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text("Batal"),
                                    ),
                                    FilledButton(
                                      onPressed: () async {
                                        Get.back();
                                        final success = await customerController
                                            .deleteCustomer(data.customerId);
                                        if (success) {
                                          showSnackBarWidget(
                                            context,
                                            "Berhasil menghapus pelanggan!",
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          );
                                        } else {
                                          showSnackBarWidget(
                                            context,
                                            customerController
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.phone,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                data.phone.toString(),
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    data.address,
                                    softWrap: true,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
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
