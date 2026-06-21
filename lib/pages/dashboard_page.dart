import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/order_controller.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});
  final orderController = Get.find<OrderController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (orderController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final totalOrder = orderController.orderData.length;
      final activeOrder = orderController.orderData.where((element) {
        return element.status != "Selesai" && element.status != "Diantar";
      }).toList();
      final totalActiveOrder = activeOrder.length;
      return ListView(
        padding: const EdgeInsets.all(15),
        children: [
          DashboardContainerWidget(
            title: "TOTAL ORDER",
            value: totalOrder.toString(),
            colorCircle: Colors.blue.withValues(alpha: 0.15),
            icons: Icons.shopping_bag_outlined,
            colorIcon: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 10),
          DashboardContainerWidget(
            title: "ORDER AKTIF",
            value: totalActiveOrder.toString(),
            colorCircle: Colors.orange.withValues(alpha: 0.15),
            icons: Icons.timer_outlined,
            colorIcon: Colors.orange,
          ),
          const SizedBox(height: 25),
          Text("Antrean Pesanan", style: TextTheme.of(context).titleLarge),
          const SizedBox(height: 5),
          (activeOrder.isEmpty || totalOrder == 0)
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Tidak ada antrean pesanan!",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              : Container(),
          ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: activeOrder.length,
            itemBuilder: (context, index) {
              final data = activeOrder[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 5,
                            children: [
                              Icon(
                                Icons.tag,
                                size: 15,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Text(
                                data.orderId,
                                style: TextTheme.of(context).bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (data.status == "Masuk")
                                  ? Colors.blue.withValues(alpha: 0.15)
                                  : Colors.orange.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                data.status.toUpperCase(),
                                style: TextTheme.of(context).bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: (data.status == "Masuk")
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Colors.deepOrange,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.person_2_outlined,
                            size: 15,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Flexible(
                            child: Text(
                              data.customerModel!.nameCustomer,
                              style: TextTheme.of(context).bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          await orderController.updateOrderStatus(
                            data.orderId,
                            (data.status == "Masuk") ? "Diproses" : "Selesai",
                          );
                          showSnackBarWidget(
                            context,
                            (data.status == "Masuk")
                                ? "Pesanan sedang diproses!"
                                : "Pesanan sudah selesai!",
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: (data.status == "Masuk")
                                ? Theme.of(context).colorScheme.primary
                                : Colors.green,
                          ),
                          child: Center(
                            child: Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  (data.status == "Masuk")
                                      ? Icons.play_arrow
                                      : Icons.check,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                                Text(
                                  (data.status == "Masuk")
                                      ? "MULAI PROSES SEKARANG"
                                      : "TANDAI SUDAH SELESAI",
                                  style: TextTheme.of(context).bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }
}

class DashboardContainerWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icons;
  final Color colorIcon;
  final Color colorCircle;

  const DashboardContainerWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icons,
    required this.colorIcon,
    required this.colorCircle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        spacing: 10,
        mainAxisAlignment: .spaceBetween,
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(title, style: TextTheme.of(context).bodyLarge),
              Text(
                value,
                style: TextTheme.of(
                  context,
                ).bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: colorCircle,
            child: Center(child: Icon(icons, color: colorIcon, size: 20)),
          ),
        ],
      ),
    );
  }
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
