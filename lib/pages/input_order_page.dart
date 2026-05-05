import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_golaundku/bloc/customer/customer_bloc.dart';
import 'package:flutter_golaundku/bloc/discount/discount_bloc.dart';
import 'package:flutter_golaundku/bloc/order/order_bloc.dart';
import 'package:flutter_golaundku/bloc/service/service_bloc.dart';
import 'package:flutter_golaundku/cubit/input_order_cubit.dart';
import 'package:flutter_golaundku/helpers/helper.dart';
import 'package:flutter_golaundku/models/order_header.dart';

class InputOrderPage extends StatefulWidget {
  final String userId;
  const InputOrderPage({super.key, required this.userId});

  @override
  State<InputOrderPage> createState() => _InputOrderPageState();
}

class _InputOrderPageState extends State<InputOrderPage> {
  late TextEditingController inputBerat;
  late TextEditingController inputNotes;

  @override
  void initState() {
    inputBerat = TextEditingController();
    inputNotes = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    inputBerat.dispose();
    inputNotes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InputOrderCubit>();
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderAddSuccess) {
          showSnackBarWidget(
            context,
            "Berhasil menambahkan order baru!",
            "action",
          );
          context.read<InputOrderCubit>().resetForm();
        }
      },
      child: BlocBuilder<InputOrderCubit, InputOrderState>(
        builder: (context, formState) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1. INFORMASI PELANGGAN",
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            BlocBuilder<CustomerBloc, CustomerState>(
                              builder: (context, state) {
                                if (state is CustomerLoaded) {
                                  return DropdownButtonFormField(
                                    initialValue: formState.selectedCustomer,
                                    decoration: InputDecoration(
                                      hintText: "Pilih Pelanggan",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    items: state.customerData.map((data) {
                                      return DropdownMenuItem(
                                        value: data.customerId,
                                        child: Text(data.name),
                                      );
                                    }).toList(),
                                    onChanged: cubit.selectCustomer,
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "2. LAYANAN KILOAN",
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            BlocBuilder<ServiceBloc, ServiceState>(
                              builder: (context, state) {
                                if (state is ServiceLoaded) {
                                  return Column(
                                    children: [
                                      DropdownButtonFormField(
                                        initialValue: formState.selectedKiloan,
                                        decoration: InputDecoration(
                                          hintText: "Pilih Paket Kiloan",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        items: [
                                          const DropdownMenuItem<String>(
                                            value: null,
                                            child: Text("Tidak pilih"),
                                          ),
                                          ...state.serviceData
                                              .where(
                                                (e) => e.category == "kiloan",
                                              )
                                              .map((data) {
                                                return DropdownMenuItem(
                                                  value: data.serviceId,
                                                  child: Text(data.name),
                                                );
                                              }),
                                        ],
                                        onChanged: cubit.selectKiloan,
                                      ),
                                      const SizedBox(height: 10),
                                      TextField(
                                        controller: inputBerat,

                                        enabled:
                                            formState.selectedKiloan != null,
                                        keyboardType: TextInputType.number,
                                        onChanged: cubit.inputBerat,
                                        decoration: InputDecoration(
                                          labelText: "Berat Total (Kg)",
                                          hintText: "0.00",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "3. LAYANAN SATUAN",
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            BlocBuilder<ServiceBloc, ServiceState>(
                              builder: (context, state) {
                                if (state is ServiceLoaded) {
                                  final satuanServices = state.serviceData
                                      .where((e) => e.category == "satuan")
                                      .toList();
                                  return Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: formState.formItems.length,
                                        itemBuilder: (context, index) {
                                          final item =
                                              formState.formItems[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 10,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: DropdownButtonFormField(
                                                    isExpanded: true,
                                                    initialValue:
                                                        item.selectedServiceId,
                                                    decoration: InputDecoration(
                                                      hintText: "Pilih Paket",
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                    items: satuanServices.map((
                                                      data,
                                                    ) {
                                                      return DropdownMenuItem(
                                                        value: data.serviceId,
                                                        child: Text(data.name),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      cubit.updateService(
                                                        index,
                                                        value,
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextField(
                                                    controller:
                                                        item.qtyController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      hintText: "Jumlah",
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                    ),
                                                    onChanged: (value) {
                                                      cubit.updateQty(
                                                        index,
                                                        value,
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.error,
                                                  ),
                                                  onPressed: () {
                                                    cubit.removeFormItem(index);
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton.icon(
                                          onPressed: cubit.addFormItem,
                                          icon: const Icon(Icons.add),
                                          label: const Text("Tambah Satuan"),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "4. PEMBAYARAN & PROMO",
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField(
                              initialValue: formState.selectedPayment,
                              decoration: InputDecoration(
                                hintText: "Metode Pembayaran",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: [
                                const DropdownMenuItem<String>(
                                  value: "Cash",
                                  child: Text("Cash"),
                                ),
                                const DropdownMenuItem<String>(
                                  value: "QRIS",
                                  child: Text("QRIS"),
                                ),
                                const DropdownMenuItem<String>(
                                  value: "Transfer",
                                  child: Text("Transfer"),
                                ),
                              ],
                              onChanged: (value) {
                                cubit.selectPaymentMethod(value);
                              },
                            ),
                            const SizedBox(height: 10),
                            BlocBuilder<DiscountBloc, DiscountState>(
                              builder: (context, state) {
                                if (state is DiscountLoaded) {
                                  return DropdownButtonFormField(
                                    initialValue:
                                        formState.selectedDiscount?.discountId,
                                    decoration: InputDecoration(
                                      hintText: "Gunakan kode promo",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    items: [
                                      const DropdownMenuItem<String>(
                                        value: null,
                                        child: Text("Tidak pilih"),
                                      ),
                                      ...state.discountData
                                          .where(
                                            (element) => element.active == true,
                                          )
                                          .map((data) {
                                            return DropdownMenuItem(
                                              value: data.discountId,
                                              child: Text(data.name),
                                            );
                                          }),
                                    ],
                                    onChanged: (value) {
                                      if (value == null) {
                                        cubit.selectDiscount(null);
                                      } else {
                                        final discount = state.discountData
                                            .firstWhere(
                                              (e) => e.discountId == value,
                                            );
                                        cubit.selectDiscount(discount);
                                      }
                                    },
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "5. CATATAN (OPSIONAL)",
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: inputNotes,
                              keyboardType: TextInputType.text,
                              onChanged: cubit.inputCatatan,
                              decoration: InputDecoration(
                                hintText: "Catatan pelanggan",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<ServiceBloc, ServiceState>(
                              builder: (context, serviceState) {
                                if (serviceState is! ServiceLoaded) {
                                  return const SizedBox();
                                }
                                return BlocBuilder<
                                  InputOrderCubit,
                                  InputOrderState
                                >(
                                  builder: (context, state) {
                                    final cubit = context
                                        .read<InputOrderCubit>();
                                    final helper = Helper();

                                    final items = cubit.buildOrderItems(
                                      serviceState.serviceData,
                                    );
                                    final subtotal = helper.calculateSubtotal(
                                      items,
                                    );
                                    final discountAmount = helper
                                        .calculateDiscountAmount(
                                          subtotal: subtotal,
                                          discount: state.selectedDiscount,
                                        );
                                    final totalTagihan = helper.calculateTotal(
                                      items: items,
                                      discount: state.selectedDiscount,
                                    );
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Subtotal Harga:",
                                              style: TextTheme.of(context)
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                  ),
                                            ),
                                            Text(
                                              Helper.formatRupiah(subtotal),
                                              style: TextTheme.of(context)
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Potongan Diskon:",
                                              style: TextTheme.of(context)
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                  ),
                                            ),
                                            Text(
                                              state.selectedDiscount == null
                                                  ? "Rp 0"
                                                  : state
                                                            .selectedDiscount!
                                                            .type ==
                                                        "percentage"
                                                  ? "${state.selectedDiscount!.value}% ${Helper.formatRupiah(discountAmount)}"
                                                  : Helper.formatRupiah(
                                                      discountAmount,
                                                    ),
                                              style: TextTheme.of(context)
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Total Tagihan:",
                                              style: TextTheme.of(context)
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                  ),
                                            ),
                                            Text(
                                              Helper.formatRupiah(totalTagihan),
                                              style: TextTheme.of(context)
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    final cubit = context.read<InputOrderCubit>();
                    final state = cubit.state;
                    final serviceState =
                        context.read<ServiceBloc>().state as ServiceLoaded;
                    final error = cubit.validateForm(
                      state,
                      serviceState.serviceData,
                    );
                    if (error != null) {
                      showSnackBarWidget(context, error, "error");
                      return;
                    }
                    final items = cubit.buildOrderItems(
                      serviceState.serviceData,
                    );
                    if (items.isEmpty || state.selectedCustomer == null) {
                      debugPrint("Form belum lengkap");
                      return;
                    }
                    final helper = Helper();
                    final total = helper.calculateTotal(
                      items: items,
                      discount: state.selectedDiscount,
                    );
                    final header = OrderHeader(
                      customerId: state.selectedCustomer!,
                      userId: widget.userId,
                      discountId: state.selectedDiscount?.discountId,
                      orderDate: DateTime.now(),
                      totalPrice: total,
                      status: "Masuk",
                      paymentMethod: state.selectedPayment!,
                      paymentStatus: "unpaid",
                      notes: state.catatan,
                    );
                    context.read<OrderBloc>().add(
                      AddOrder(orderHeader: header, items: items),
                    );
                  },
                  child: Center(
                    child: BlocBuilder<OrderBloc, OrderState>(
                      builder: (context, state) {
                        if (state is OrderLoading) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          );
                        }
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Center(
                            child: Text(
                              "Simpan order sekarang".toUpperCase(),
                              style: TextTheme.of(context).bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void showSnackBarWidget(BuildContext context, String text, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: (label == "action")
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.error,
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
}
