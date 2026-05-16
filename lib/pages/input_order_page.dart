import 'package:flutter/material.dart';
import 'package:flutter_golaundku/controller/customer_controller.dart';
import 'package:flutter_golaundku/controller/discount_controller.dart';
import 'package:flutter_golaundku/controller/input_order_controller.dart';
import 'package:flutter_golaundku/controller/order_controller.dart';
import 'package:flutter_golaundku/controller/service_controller.dart';
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
    return Obx(() {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final customers = customerController.customerData;
                    return DropdownButtonFormField<String>(
                      initialValue: controller.selectedCustomer.value,
                      items: customers.map((data) {
                        return DropdownMenuItem(
                          value: data.customerId,
                          child: Text(
                            data.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: controller.selectCustomer,
                      decoration: InputDecoration(
                        labelText: "Pilih Customer",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 15),
                  Obx(() {
                    final services = serviceController.serviceData
                        .where((e) => e.category == "kiloan")
                        .toList();
                    return Column(
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: controller.selectedKiloan.value,
                          items: services.map((data) {
                            return DropdownMenuItem(
                              value: data.serviceId,
                              child: Text(data.name),
                            );
                          }).toList(),
                          onChanged: controller.selectKiloan,
                          decoration: InputDecoration(
                            labelText: "Paket Kiloan",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          onChanged: controller.inputBerat,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Berat (Kg)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 15),
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
                                      initialValue: item.selectedServiceId,
                                      items: services.map((data) {
                                        return DropdownMenuItem(
                                          value: data.serviceId,
                                          child: Text(data.name),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        controller.updateService(index, value);
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Layanan",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      controller: item.qtyController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (v) =>
                                          controller.updateQty(index, v),
                                      decoration: InputDecoration(
                                        labelText: "Qty",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () =>
                                        controller.removeFormItem(index),
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
                  const SizedBox(height: 15),

                  Obx(() {
                    return DropdownButtonFormField<String>(
                      initialValue: controller.selectedPayment.value,
                      items: const [
                        DropdownMenuItem(value: "Cash", child: Text("Cash")),
                        DropdownMenuItem(value: "QRIS", child: Text("QRIS")),
                        DropdownMenuItem(value: "Transfer", child: Text("Transfer")),
                      ],
                      onChanged: controller.selectedPayment.call,
                      decoration: InputDecoration(
                        labelText: "Payment",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 15),
                  Obx(() {
                    final discounts = discountController.discountData
                        .where((e) => e.active)
                        .toList();
                    return DropdownButtonFormField<String>(
                      initialValue: controller.selectedDiscount.value?.discountId,
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text("Tanpa Diskon"),
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
                      decoration: InputDecoration(
                        labelText: "Promo",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 15),
                  TextField(
                    onChanged: controller.inputCatatan,
                    decoration: InputDecoration(
                      labelText: "Catatan",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: Obx(() {
              return ElevatedButton(
                onPressed: () {
                  final items = controller.buildOrderItems(
                    serviceController.serviceData,
                  );
                  if (items.isEmpty ||
                      controller.selectedCustomer.value == null ||
                      controller.selectedPayment.value == null) {
                    Get.snackbar("Error", "Form belum lengkap");
                    return;
                  }
                  final header = OrderHeader(
                    customerId: controller.selectedCustomer.value!,
                    userId: userId,
                    discountId: controller.selectedDiscount.value?.discountId,
                    orderDate: DateTime.now(),
                    totalPrice: 0,
                    status: "Masuk",
                    paymentMethod: controller.selectedPayment.value!,
                    paymentStatus: "unpaid",
                    notes: controller.catatan.value,
                  );
                  orderController.createOrder(header, items);
                  controller.resetForm();
                },
                child: const Text("Simpan Order"),
              );
            }),
          ),
        ],
      );
    });
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
