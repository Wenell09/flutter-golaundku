import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/order_controller.dart';
import 'package:flutter_golaundku/helpers/helper.dart';
import 'package:get/get.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final TextEditingController searchCustomer;
  late final OrderController orderController;
  final keyword = ''.obs;

  @override
  void initState() {
    super.initState();
    searchCustomer = TextEditingController();
    orderController = Get.find<OrderController>();
  }

  @override
  void dispose() {
    searchCustomer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        TextField(
          controller: searchCustomer,
          onChanged: (value) {
            keyword.value = value.toLowerCase();
          },
          decoration: InputDecoration(
            filled: true,
            prefixIcon: const Icon(Icons.search),
            fillColor: Theme.of(context).colorScheme.onPrimary,
            hintText: "Cari ID atau nama pelanggan...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),

        const SizedBox(height: 20),

        Obx(() {
          if (orderController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredData = orderController.orderData.where((data) {
            return data.orderId.toLowerCase().contains(keyword.value) ||
                data.customerModel!.nameCustomer.toLowerCase().contains(
                  keyword.value,
                );
          }).toList();

          if (orderController.orderData.isEmpty) {
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
                    "Daftar pembayaran kosong!",
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
                    "Pembayaran tidak ditemukan!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              final data = filteredData[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.orderId,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),

                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: data.paymentStatus == "paid"
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.error,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              data.paymentStatus == "paid"
                                  ? "LUNAS"
                                  : "BELUM LUNAS",
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 15,
                            color: Theme.of(context).colorScheme.primary,
                          ),

                          const SizedBox(width: 5),

                          Flexible(
                            child: Text(
                              data.customerModel!.nameCustomer,
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Icon(
                            Icons.payment,
                            size: 15,
                            color: Theme.of(context).colorScheme.primary,
                          ),

                          const SizedBox(width: 5),

                          Text(
                            data.paymentMethod,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "TOTAL TAGIHAN",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),

                              Text(
                                Helper.formatRupiah(data.totalPrice),
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),

                          data.paymentStatus == "paid"
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Text(
                                          "Konfirmasi Pembayaran",
                                        ),
                                        content: Text(
                                          "Konfirmasi pembayaran ${data.orderId} ?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text("Batal"),
                                          ),

                                          FilledButton(
                                            onPressed: () async {
                                              Get.back();

                                              await orderController
                                                  .updatePaymentConfirm(
                                                    data.orderId,
                                                    "paid",
                                                  );
                                            },
                                            style: FilledButton.styleFrom(
                                              backgroundColor: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                            child: const Text("YA"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    child: Text(
                                      "Konfirmasi Bayar",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                          ),
                                    ),
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
