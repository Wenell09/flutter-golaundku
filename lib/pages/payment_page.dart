import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/order/order_bloc.dart';
import 'package:flutter_golaundku/helpers/helper.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String keyword = "";
  late TextEditingController searchCustomer;
  @override
  void initState() {
    searchCustomer = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchCustomer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(15),
      children: [
        TextField(
          onChanged: (value) {
            setState(() {
              keyword = value;
            });
          },
          decoration: InputDecoration(
            filled: true,
            prefixIcon: Icon(Icons.search),
            fillColor: Theme.of(context).colorScheme.onPrimary,
            hintText: "Cari ID atau nama pelanggan...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 20),
        BlocBuilder<OrderBloc, OrderState>(
          buildWhen: (previous, current) {
            return current is OrderLoading || current is OrderLoaded;
          },
          builder: (context, state) {
            if (state is OrderLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is OrderLoaded) {
              final filteredData = state.orderData.where((data) {
                return data.orderId.toLowerCase().contains(keyword) ||
                    data.customerModel!.name.toLowerCase().contains(keyword);
              }).toList();
              if (state.orderData.isEmpty) {
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
                        "daftar pembayaran kosong!",
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
                  final data = filteredData[index];
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        spacing: 5,
                        crossAxisAlignment: .start,
                        children: [
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Text(
                                data.orderId,
                                style: TextTheme.of(context).titleMedium,
                              ),
                              Container(
                                padding: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: (data.paymentStatus == "paid")
                                      ? Colors.green
                                      : Theme.of(context).colorScheme.error,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    (data.paymentStatus == "paid")
                                        ? "LUNAS"
                                        : "BELUM LUNAS",
                                    style: TextTheme.of(context).bodySmall!
                                        .copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
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
                                Icons.person,
                                size: 15,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Flexible(
                                child: Text(
                                  data.customerModel!.name,
                                  style: TextTheme.of(context).titleMedium!
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
                          Row(
                            spacing: 5,
                            children: [
                              Icon(
                                Icons.payment,
                                size: 15,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Text(
                                data.paymentMethod,
                                style: TextTheme.of(context).bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: .start,
                                children: [
                                  Text(
                                    "TOTAL TAGIHAN",
                                    style: TextTheme.of(context).titleSmall,
                                  ),
                                  Text(
                                    Helper.formatRupiah(data.totalPrice),
                                    style: TextTheme.of(context).titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                  ),
                                ],
                              ),
                              (data.paymentStatus == "paid")
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                "Konfirmasi Pembayaran",
                                              ),
                                              content: Text(
                                                "Konfirmasi Pembayaran ${data.orderId} ?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(
                                                    context,
                                                  ).pop(),
                                                  child: const Text("Batal"),
                                                ),
                                                FilledButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    context
                                                        .read<OrderBloc>()
                                                        .add(
                                                          UpdatePaymentConfirm(
                                                            orderId:
                                                                data.orderId,
                                                            paymentStatus:
                                                                "paid",
                                                          ),
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
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Konfirmasi Bayar",
                                            style: TextTheme.of(context)
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
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: filteredData.length,
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
