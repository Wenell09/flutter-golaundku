import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/order_controller.dart';
import 'package:flutter_golaundku/helpers/helper.dart';
import 'package:flutter_golaundku/pages/detail_order_page.dart';
import 'package:get/get.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});
  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
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
          final filteredData = orderController.orderData.where((data) {
            return data.orderId.toLowerCase().contains(keyword.value) ||
                data.customerModel!.nameCustomer.toLowerCase().contains(
                  keyword.value,
                );
          }).toList();
          if (orderController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (orderController.streamError.value.isNotEmpty) {
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
                    "Daftar order kosong!",
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
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              final data = filteredData[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => DetailOrderPage(orderModel: data));
                },
                child: Card(
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
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                await orderController.updateOrderStatus(
                                  data.orderId,
                                  value,
                                );
                              },
                              itemBuilder: (context) => [
                                _buildStatusItem("Masuk"),
                                _buildStatusItem("Diproses"),
                                _buildStatusItem("Selesai"),
                                _buildStatusItem("Diantar"),
                              ],
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: getStatusColor(
                                    data.status,
                                  ).withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: getStatusColor(data.status),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      data.status,
                                      style: TextStyle(
                                        color: getStatusColor(data.status),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 18,
                                      color: getStatusColor(data.status),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          data.customerModel!.nameCustomer,
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  size: 15,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Masuk: ${Helper.toIndoDate(data.orderDate)}",
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  size: 15,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  data.estimatedDate != null
                                      ? Helper.toIndoDate(data.estimatedDate!)
                                      : "Menghitung...",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }

  PopupMenuItem<String> _buildStatusItem(String status) {
    return PopupMenuItem(value: status, child: Text(status));
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Masuk":
        return Theme.of(context).colorScheme.primary;
      case "Diproses":
        return Colors.deepOrange;
      case "Selesai":
        return Colors.green;
      case "Diantar":
        return Colors.purple;
      default:
        return Theme.of(context).colorScheme.onSurface;
    }
  }
}
