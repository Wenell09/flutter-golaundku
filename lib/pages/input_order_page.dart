import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/customer_controller.dart';
import 'package:flutter_golaundku/controller/discount_controller.dart';
import 'package:flutter_golaundku/controller/input_order_controller.dart';
import 'package:flutter_golaundku/controller/order_controller.dart';
import 'package:flutter_golaundku/controller/service_controller.dart';
import 'package:flutter_golaundku/helpers/helper.dart';
import 'package:flutter_golaundku/models/order_header.dart';
import 'package:get/get.dart';

class InputOrderPage extends StatelessWidget {
  final String userId;

  InputOrderPage({super.key, required this.userId});

  final controller = Get.put(InputOrderController());
  final serviceController = Get.find<ServiceController>();
  final customerController = Get.find<CustomerController>();
  final discountController = Get.find<DiscountController>();
  final orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
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
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        final customers = customerController.customerData;
                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: controller.selectedCustomer.value,
                          decoration: InputDecoration(
                            hintText: "Pilih Pelanggan",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: customers.map((data) {
                            return DropdownMenuItem(
                              value: data.customerId,
                              child: Text(
                                data.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            );
                          }).toList(),
                          onChanged: controller.selectCustomer,
                        );
                      }),
                      const SizedBox(height: 20),
                      Text(
                        "2. LAYANAN KILOAN",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        final services = serviceController.serviceData
                            .where((e) => e.category == "kiloan")
                            .toList();
                        return Column(
                          children: [
                            DropdownButtonFormField<String>(
                              initialValue: controller.selectedKiloan.value,
                              decoration: InputDecoration(
                                hintText: "Pilih Paket Kiloan",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              items: [
                                const DropdownMenuItem<String>(
                                  value: null,
                                  child: Text("Tidak pilih"),
                                ),
                                ...services.map((data) {
                                  return DropdownMenuItem(
                                    value: data.serviceId,
                                    child: Text(data.name),
                                  );
                                }),
                              ],
                              onChanged: controller.selectKiloan,
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              enabled: controller.selectedKiloan.value != null,
                              keyboardType: TextInputType.number,
                              onChanged: controller.inputBerat,
                              decoration: InputDecoration(
                                labelText: "Berat Total (Kg)",
                                hintText: "0.00",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 20),
                      Text(
                        "3. LAYANAN SATUAN",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        final services = serviceController.serviceData
                            .where((e) => e.category == "satuan")
                            .toList();
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.formItems.length,
                              itemBuilder: (context, index) {
                                final item = controller.formItems[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          initialValue: item.selectedServiceId,
                                          decoration: InputDecoration(
                                            hintText: "Pilih Paket",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          items: services.map((data) {
                                            return DropdownMenuItem(
                                              value: data.serviceId,
                                              child: Text(data.name),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            controller.updateService(
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
                                          controller: item.qtyController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: "Jumlah",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            controller.updateQty(index, value);
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
                                          controller.removeFormItem(index);
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
                                onPressed: controller.addFormItem,
                                icon: const Icon(Icons.add),
                                label: const Text("Tambah Satuan"),
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 20),
                      Text(
                        "4. PEMBAYARAN & PROMO",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return DropdownButtonFormField<String>(
                          initialValue: controller.selectedPayment.value,
                          decoration: InputDecoration(
                            hintText: "Metode Pembayaran",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem<String>(
                              value: "Cash",
                              child: Text("Cash"),
                            ),
                            DropdownMenuItem<String>(
                              value: "QRIS",
                              child: Text("QRIS"),
                            ),
                            DropdownMenuItem<String>(
                              value: "Transfer",
                              child: Text("Transfer"),
                            ),
                          ],
                          onChanged: controller.selectedPayment.call,
                        );
                      }),
                      const SizedBox(height: 10),
                      Obx(() {
                        final discounts = discountController.discountData
                            .where((e) => e.active)
                            .toList();
                        return DropdownButtonFormField<String>(
                          initialValue:
                              controller.selectedDiscount.value?.discountId,
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
                            ...discounts.map((data) {
                              return DropdownMenuItem(
                                value: data.discountId,
                                child: Text(data.name),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            if (value == null) {
                              controller.selectDiscount(null);
                            } else {
                              final discount = discounts.firstWhere(
                                (e) => e.discountId == value,
                              );

                              controller.selectDiscount(discount);
                            }
                          },
                        );
                      }),
                      const SizedBox(height: 20),
                      Text(
                        "5. CATATAN (OPSIONAL)",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        keyboardType: TextInputType.text,
                        onChanged: controller.inputCatatan,
                        decoration: InputDecoration(
                          hintText: "Catatan pelanggan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() {
                        final items = controller.buildOrderItems(
                          serviceController.serviceData,
                        );
                        final subtotal = Helper.calculateSubtotal(items);
                        final discountAmount = Helper.calculateDiscountAmount(
                          subtotal: subtotal,
                          discount: controller.selectedDiscount.value,
                        );
                        final totalTagihan = Helper.calculateTotal(
                          items: items,
                          discount: controller.selectedDiscount.value,
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Subtotal Harga:",
                                  style: TextTheme.of(context).bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                                Text(
                                  Helper.formatRupiah(subtotal),
                                  style: TextTheme.of(context).bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Potongan Diskon:",
                                  style: TextTheme.of(context).bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                                Text(
                                  controller.selectedDiscount.value == null
                                      ? "Rp 0"
                                      : controller
                                                .selectedDiscount
                                                .value!
                                                .type ==
                                            "percentage"
                                      ? "(${controller.selectedDiscount.value!.value}%) ${Helper.formatRupiah(discountAmount)}"
                                      : Helper.formatRupiah(discountAmount),
                                  style: TextTheme.of(context).bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Tagihan:",
                                  style: TextTheme.of(context).bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                                Text(
                                  Helper.formatRupiah(totalTagihan),
                                  style: TextTheme.of(context).bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          height: 100,
          child: Obx(() {
            return GestureDetector(
              onTap: orderController.isLoading.value
                  ? null
                  : () async {
                      final items = controller.buildOrderItems(
                        serviceController.serviceData,
                      );
                      final error = controller.validateForm(
                        serviceController.serviceData,
                      );
                      if (error != null) {
                        showSnackBarWidget(context, error, "error");
                        return;
                      }
                      final total = Helper.calculateTotal(
                        items: items,
                        discount: controller.selectedDiscount.value,
                      );
                      final header = OrderHeader(
                        customerId: controller.selectedCustomer.value!,
                        userId: userId,
                        discountId:
                            controller.selectedDiscount.value?.discountId,
                        orderDate: DateTime.now(),
                        totalPrice: total,
                        status: "Masuk",
                        paymentMethod: controller.selectedPayment.value!,
                        paymentStatus: "unpaid",
                        notes: controller.catatan.value,
                      );
                      final success = await orderController.createOrder(
                        header,
                        items,
                      );
                      if (success) {
                        showSnackBarWidget(
                          context,
                          "Berhasil menambahkan order baru!",
                          "action",
                        );
                        controller.resetForm();
                      } else {
                        Get.snackbar(
                          "Error",
                          orderController.actionError.value,
                        );
                      }
                    },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(
                  child: orderController.isLoading.value
                      ? CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : Text(
                          "Simpan order sekarang".toUpperCase(),
                          style: TextTheme.of(context).bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
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
