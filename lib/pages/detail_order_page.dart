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
      body: ListView(
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
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    spacing: 10,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        child: Center(child: Icon(Icons.person)),
                      ),
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            "PELANGGAN",
                            style: TextTheme.of(context).bodySmall,
                          ),
                          Text(
                            widget.orderModel.customerModel!.name,
                            style: TextTheme.of(
                              context,
                            ).bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.date_range,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  "MASUK",
                                  style: TextTheme.of(context).bodySmall,
                                ),
                                Text(
                                  Helper.toIndoDate(
                                    widget.orderModel.orderDate,
                                  ),
                                  style: TextTheme.of(context).bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
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
                              color: Theme.of(context).colorScheme.error,
                            ),
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  "ESTIMASI",
                                  style: TextTheme.of(context).bodySmall,
                                ),
                                Text(
                                  Helper.toIndoDate(
                                    widget.orderModel.orderDate,
                                  ),
                                  style: TextTheme.of(context).bodyLarge!
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
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.payment,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  "METODE BAYAR",
                                  style: TextTheme.of(context).bodySmall,
                                ),
                                Text(
                                  widget.orderModel.paymentMethod,
                                  style: TextTheme.of(context).bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
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
                            color: (widget.orderModel.paymentStatus == "paid")
                                ? Colors.green
                                : Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              widget.orderModel.paymentStatus,
                              style: TextTheme.of(context).bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: BlocBuilder<DetailOrderBloc, DetailOrderState>(
                    buildWhen: (previous, current) {
                      return current is DetailOrderLoading ||
                          current is DetailOrderLoaded;
                    },
                    builder: (context, state) {
                      if (state is DetailOrderLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is DetailOrderLoaded) {
                        return ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final data = state.detailOrderData[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Row(
                                    mainAxisAlignment: .spaceBetween,
                                    children: [
                                      BlocBuilder<ServiceBloc, ServiceState>(
                                        builder: (context, serviceState) {
                                          if (serviceState is ServiceLoaded) {
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
                                        style: TextTheme.of(context).titleLarge!
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
                                            ? data.quantity.toInt().toString()
                                            : data.quantity.toString(),
                                        style: TextTheme.of(context).bodySmall,
                                      ),
                                      BlocBuilder<ServiceBloc, ServiceState>(
                                        builder: (context, serviceState) {
                                          if (serviceState is ServiceLoaded) {
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
                                                  (serviceData.first.category ==
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
                                ],
                              ),
                            );
                          },
                          itemCount: state.detailOrderData.length,
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
