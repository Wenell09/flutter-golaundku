import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/bloc/order_bloc.dart';
import 'package:flutter_golaundku/helpers/helper.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  late TextEditingController searchCustomer;
  @override
  void initState() {
    searchCustomer = TextEditingController();
    context.read<OrderBloc>().add(StartOrderStream());
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
          onChanged: (value) {},
          decoration: InputDecoration(
            filled: true,
            prefixIcon: Icon(Icons.search),
            fillColor: Theme.of(context).colorScheme.onPrimary,
            hintText: "Cari nama pelanggan...",
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
                        "daftar order kosong!",
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
                  final data = state.orderData[index];
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
                                style: TextTheme.of(context).bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  context.read<OrderBloc>().add(
                                    UpdateStatusOrder(
                                      orderId: data.orderId,
                                      status: value,
                                    ),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                          Text(
                            data.customerModel!.name,
                            style: TextTheme.of(
                              context,
                            ).bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    size: 15,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  Text(
                                    "Masuk: ${Helper.toIndoDate(data.orderDate)}",
                                  ),
                                  // Text(
                                  //   "Masuk: ${Helper.toIndoDate(data.orderDate)}",
                                  // ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer,
                                    size: 15,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  Text(
                                    "Estimasi: ${Helper.toIndoDate(data.estimatedDate)}",
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
                itemCount: state.orderData.length,
              );
            }
            return Container();
          },
        ),
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
