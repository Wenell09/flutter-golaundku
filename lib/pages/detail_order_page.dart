import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/detail_order/detail_order_bloc.dart';
import 'package:flutter_golaundku/bloc/service/service_bloc.dart';
import 'package:flutter_golaundku/helpers/helper.dart';
import 'package:flutter_golaundku/models/order_model.dart';

class DetailOrderPage extends StatefulWidget {
  final OrderModel orderModel;
  const DetailOrderPage({super.key, required this.orderModel});

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  @override
  void initState() {
    context.read<DetailOrderBloc>().add(
      GetDetailOrder(orderId: widget.orderModel.orderId),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Order #${widget.orderModel.orderId}")),
      body: BlocBuilder<DetailOrderBloc, DetailOrderState>(
        buildWhen: (previous, current) {
          return current is DetailOrderLoading || current is DetailOrderLoaded;
        },
        builder: (context, state) {
          if (state is DetailOrderLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DetailOrderLoaded) {
            final subtotal = Helper.calculateSubtotalFromDetail(
              state.detailOrderData,
            );
            final discountAmount = Helper.calculateDiscountAmount(
              subtotal: subtotal,
              discount: widget.orderModel.discountModel,
            );
            final total = Helper.calculateTotalFromDetail(
              items: state.detailOrderData,
              discount: widget.orderModel.discountModel,
            );
            return ListView(
              padding: EdgeInsets.all(15),
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          "RINGKASAN PESANAN",
                          style: TextTheme.of(context).bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  child: Center(child: Icon(Icons.person)),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text(
                                        "PELANGGAN",
                                        style: TextTheme.of(context).bodySmall,
                                      ),
                                      Text(
                                        widget.orderModel.customerModel!.name,
                                        style: TextTheme.of(context).bodyLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    spacing: 10,
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                      Column(
                                        crossAxisAlignment: .start,
                                        children: [
                                          Text(
                                            "MASUK",
                                            style: TextTheme.of(
                                              context,
                                            ).bodySmall,
                                          ),
                                          Text(
                                            Helper.toIndoDate(
                                              widget.orderModel.orderDate,
                                            ),
                                            style: TextTheme.of(context)
                                                .bodyLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    spacing: 10,
                                    children: [
                                      Icon(
                                        Icons.timer,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                      Column(
                                        crossAxisAlignment: .start,
                                        children: [
                                          Text(
                                            "ESTIMASI",
                                            style: TextTheme.of(
                                              context,
                                            ).bodySmall,
                                          ),
                                          Text(
                                            Helper.toIndoDate(
                                              widget.orderModel.orderDate,
                                            ),
                                            style: TextTheme.of(context)
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
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    spacing: 10,
                                    children: [
                                      Icon(
                                        Icons.payment,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                      Column(
                                        crossAxisAlignment: .start,
                                        children: [
                                          Text(
                                            "METODE BAYAR",
                                            style: TextTheme.of(
                                              context,
                                            ).bodySmall,
                                          ),
                                          Text(
                                            widget.orderModel.paymentMethod,
                                            style: TextTheme.of(context)
                                                .bodyLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.only(right: 10),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          (widget.orderModel.paymentStatus ==
                                              "paid")
                                          ? Colors.green
                                          : Theme.of(context).colorScheme.error,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.orderModel.paymentStatus,
                                        style: TextTheme.of(context).bodySmall!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                state.detailOrderData.sort((a, b) {
                                  if (a.deliveryStatus == b.deliveryStatus) {
                                    return 0;
                                  }
                                  return a.deliveryStatus ? -1 : 1;
                                });
                                final data = state.detailOrderData[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: .spaceBetween,
                                        children: [
                                          BlocBuilder<
                                            ServiceBloc,
                                            ServiceState
                                          >(
                                            builder: (context, serviceState) {
                                              if (serviceState
                                                  is ServiceLoaded) {
                                                final serviceData = serviceState
                                                    .serviceData
                                                    .where(
                                                      (element) =>
                                                          element.serviceId ==
                                                          data.serviceId,
                                                    );
                                                return Text(
                                                  serviceData.first.name,
                                                  style: TextTheme.of(
                                                    context,
                                                  ).titleLarge,
                                                );
                                              }
                                              return Container();
                                            },
                                          ),
                                          Text(
                                            Helper.formatRupiah(data.subTotal),
                                            style: TextTheme.of(context)
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
                                        spacing: 2,
                                        children: [
                                          Text(
                                            data.quantity % 1 == 0
                                                ? data.quantity
                                                      .toInt()
                                                      .toString()
                                                : data.quantity.toString(),
                                            style: TextTheme.of(
                                              context,
                                            ).bodySmall,
                                          ),
                                          BlocBuilder<
                                            ServiceBloc,
                                            ServiceState
                                          >(
                                            builder: (context, serviceState) {
                                              if (serviceState
                                                  is ServiceLoaded) {
                                                final serviceData = serviceState
                                                    .serviceData
                                                    .where(
                                                      (element) =>
                                                          element.serviceId ==
                                                          data.serviceId,
                                                    );
                                                return Row(
                                                  children: [
                                                    Text(
                                                      (serviceData
                                                                  .first
                                                                  .category ==
                                                              "kiloan")
                                                          ? "Kg"
                                                          : "(pcs/set)",
                                                      style: TextTheme.of(
                                                        context,
                                                      ).bodySmall,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      "x",
                                                      style: TextTheme.of(
                                                        context,
                                                      ).bodySmall,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      Helper.formatRupiah(
                                                        serviceData.first.price,
                                                      ),
                                                      style: TextTheme.of(
                                                        context,
                                                      ).bodySmall,
                                                    ),
                                                  ],
                                                );
                                              }
                                              return Container();
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: .spaceBetween,
                                        children: [
                                          Text(
                                            "STATUS PENGIRIMAN:",
                                            style: TextTheme.of(
                                              context,
                                            ).bodySmall,
                                          ),
                                          GestureDetector(
                                            onTap: () => context
                                                .read<DetailOrderBloc>()
                                                .add(
                                                  UpdateDeliveryStatus(
                                                    orderId: data.orderId,
                                                    orderItemId:
                                                        data.orderItemId,
                                                    deliveryStatus:
                                                        !data.deliveryStatus,
                                                  ),
                                                ),
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: (!data.deliveryStatus)
                                                      ? Theme.of(
                                                          context,
                                                        ).colorScheme.error
                                                      : Colors.transparent,
                                                ),
                                                color: (data.deliveryStatus)
                                                    ? Colors.green.withValues(
                                                        alpha: 0.15,
                                                      )
                                                    : Colors.white,
                                              ),
                                              child: Center(
                                                child: Row(
                                                  spacing: 5,
                                                  children: [
                                                    Icon(
                                                      (data.deliveryStatus)
                                                          ? Icons
                                                                .check_circle_outline_rounded
                                                          : Icons.close,
                                                      color:
                                                          (!data.deliveryStatus)
                                                          ? Theme.of(
                                                              context,
                                                            ).colorScheme.error
                                                          : Colors.green,
                                                      size: 15,
                                                    ),
                                                    Text(
                                                      (data.deliveryStatus)
                                                          ? "SUDAH"
                                                          : "BELUM",
                                                      style:
                                                          TextTheme.of(
                                                            context,
                                                          ).bodySmall!.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                (!data
                                                                    .deliveryStatus)
                                                                ? Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .error
                                                                : Colors.green,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: state.detailOrderData.length,
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Subtotal Harga:",
                                  style: TextTheme.of(context).titleLarge!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                                Text(
                                  Helper.formatRupiah(subtotal),
                                  style: TextTheme.of(context).titleLarge,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Potongan Diskon:",
                                  style: TextTheme.of(context).titleLarge!
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
                                  style: TextTheme.of(context).titleLarge,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Tagihan:",
                                  style: TextTheme.of(context).titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                                Text(
                                  Helper.formatRupiah(total),
                                  style: TextTheme.of(context).titleLarge!
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
          }
          return Container();
        },
      ),
    );
  }
}
