import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/order_controller.dart';
import 'package:flutter_golaundku/controller/service_controller.dart';
import 'package:flutter_golaundku/helpers/helper.dart';
import 'package:flutter_golaundku/models/order_model.dart';
import 'package:get/get.dart';

class DetailOrderPage extends StatefulWidget {
  final OrderModel orderModel;
  const DetailOrderPage({super.key, required this.orderModel});

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  late final OrderController orderController;
  late final ServiceController serviceController;

  @override
  void initState() {
    super.initState();
    orderController = Get.find<OrderController>();
    serviceController = Get.find<ServiceController>();
    orderController.getDetailOrder(widget.orderModel.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Order #${widget.orderModel.orderId}")),
      body: Obx(() {
        if (orderController.isDetailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final detailData = orderController.detailOrderData.toList();
        detailData.sort((a, b) {
          if (a.deliveryStatus == b.deliveryStatus) {
            return 0;
          }
          return a.deliveryStatus ? -1 : 1;
        });
        final subtotal = Helper.calculateSubtotalFromDetail(detailData);
        final discountAmount = Helper.calculateDiscountAmount(
          subtotal: subtotal,
          discount: widget.orderModel.discountModel,
        );
        final total = Helper.calculateTotalFromDetail(
          items: detailData,
          discount: widget.orderModel.discountModel,
        );
        return ListView(
          padding: const EdgeInsets.all(15),
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    height: 45,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      "RINGKASAN PESANAN",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              child: Icon(Icons.person),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "PELANGGAN",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  Text(
                                    widget.orderModel.customerModel!.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "MASUK",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    Text(
                                      Helper.toIndoDate(
                                        widget.orderModel.orderDate,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.timer,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ESTIMASI",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    Text(
                                      Helper.toIndoDate(
                                        widget.orderModel.estimatedDate,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.error,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.payment,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "METODE BAYAR",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    Text(
                                      widget.orderModel.paymentMethod,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: widget.orderModel.paymentStatus == "paid"
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.error,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.orderModel.paymentStatus,
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: detailData.length,
                          itemBuilder: (context, index) {
                            final data = detailData[index];
                            final service = serviceController.serviceData
                                .firstWhere(
                                  (element) =>
                                      element.serviceId == data.serviceId,
                                );
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        service.name,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge,
                                      ),
                                      Text(
                                        Helper.formatRupiah(data.subTotal),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        data.quantity % 1 == 0
                                            ? data.quantity.toInt().toString()
                                            : data.quantity.toString(),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        service.category == "kiloan"
                                            ? "Kg"
                                            : "(pcs/set)",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "x",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        Helper.formatRupiah(service.price),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "STATUS PENGIRIMAN:",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await orderController
                                              .updateShippingStatus(
                                                data.orderId,
                                                data.orderItemId,
                                                !data.deliveryStatus,
                                              );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: !data.deliveryStatus
                                                  ? Theme.of(
                                                      context,
                                                    ).colorScheme.error
                                                  : Colors.transparent,
                                            ),
                                            color: data.deliveryStatus
                                                ? Colors.green.withValues(
                                                    alpha: 0.15,
                                                  )
                                                : Colors.white,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                data.deliveryStatus
                                                    ? Icons
                                                          .check_circle_outline_rounded
                                                    : Icons.close,
                                                color: !data.deliveryStatus
                                                    ? Theme.of(
                                                        context,
                                                      ).colorScheme.error
                                                    : Colors.green,
                                                size: 15,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                data.deliveryStatus
                                                    ? "SUDAH"
                                                    : "BELUM",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          !data.deliveryStatus
                                                          ? Theme.of(
                                                              context,
                                                            ).colorScheme.error
                                                          : Colors.green,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Text(
                          "Catatan Pelanggan",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          widget.orderModel.notes.isEmpty
                              ? "Tidak ada catatan dari pelanggan"
                              : widget.orderModel.notes,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal Harga:",
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            Text(
                              Helper.formatRupiah(subtotal),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Potongan Diskon:",
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            Text(
                              widget.orderModel.discountModel == null
                                  ? "Rp 0"
                                  : widget.orderModel.discountModel!.type ==
                                        "percentage"
                                  ? "(${widget.orderModel.discountModel!.value}%) ${Helper.formatRupiah(discountAmount)}"
                                  : Helper.formatRupiah(discountAmount),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Tagihan:",
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            Text(
                              Helper.formatRupiah(total),
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
