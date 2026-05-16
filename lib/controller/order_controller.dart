import 'dart:async';

import 'package:flutter_golaundku/controller/customer_controller.dart';
import 'package:flutter_golaundku/controller/discount_controller.dart';
import 'package:flutter_golaundku/models/order_header.dart';
import 'package:flutter_golaundku/models/order_item.dart';
import 'package:flutter_golaundku/models/order_items_model.dart';
import 'package:flutter_golaundku/models/order_model.dart';
import 'package:flutter_golaundku/repository/customer_repository.dart';
import 'package:flutter_golaundku/repository/discount_repository.dart';
import 'package:flutter_golaundku/repository/order_repository.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final OrderRepository orderRepository;
  final CustomerRepository customerRepository;
  final DiscountRepository discountRepository;

  OrderController(
    this.orderRepository,
    this.customerRepository,
    this.discountRepository,
  );
  StreamSubscription<List<OrderModel>>? _subscription;
  final isLoading = false.obs;
  final isDetailLoading = false.obs;
  final streamError = ''.obs;
  final actionError = ''.obs;
  final orderData = <OrderModel>[].obs;
  final detailOrderData = <OrderItemsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    streamOrders();
  }

  Future<void> streamOrders() async {
    try {
      isLoading.value = true;
      streamError.value = '';
      await _subscription?.cancel();
      _subscription = orderRepository.streamOrders().listen(
        (orders) {
          final customerController = Get.find<CustomerController>();
          final discountController = Get.find<DiscountController>();
          final customerMap = {
            for (final customer in customerController.customerData)
              customer.customerId: customer,
          };
          final discountMap = {
            for (final discount in discountController.discountData)
              discount.discountId: discount,
          };
          final mappedOrders = orders.map((order) {
            return order.copyWith(
              customerModel: customerMap[order.customerId],
              discountModel: discountMap[order.discountId],
            );
          }).toList();
          orderData.assignAll(mappedOrders);
          streamError.value = '';
          isLoading.value = false;
        },
        onError: (error) {
          streamError.value = error.toString();
          isLoading.value = false;
        },
      );
    } catch (e) {
      streamError.value = "Gagal load data order";
      isLoading.value = false;
    }
  }

  Future<bool> createOrder(
    OrderHeader orderHeader,
    List<OrderItem> items,
  ) async {
    try {
      isLoading.value = true;
      actionError.value = '';
      await orderRepository.addOrder(orderHeader, items);
      isLoading.value = false;
      return true;
    } catch (e) {
      actionError.value = "Gagal menambahkan order!";
      isLoading.value = false;

      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      actionError.value = '';
      await orderRepository.updateStatusOrder(orderId, status);
      return true;
    } catch (e) {
      actionError.value = "Gagal mengupdate status order!";
      return false;
    }
  }

  Future<bool> updatePaymentConfirm(
    String orderId,
    String paymentStatus,
  ) async {
    try {
      actionError.value = '';
      await orderRepository.paymentConfirm(orderId, paymentStatus);
      return true;
    } catch (e) {
      actionError.value = "Gagal mengupdate konfirmasi pembayaran!";
      return false;
    }
  }

  Future<void> getDetailOrder(String orderId) async {
    try {
      isDetailLoading.value = true;
      actionError.value = '';
      final result = await orderRepository.getDetailOrder(orderId);
      detailOrderData.assignAll(result);
      isDetailLoading.value = false;
    } catch (e) {
      actionError.value = "Gagal mengambil detail order!";
      isDetailLoading.value = false;
    }
  }

  Future<bool> updateShippingStatus(
    String orderId,
    String orderItemId,
    bool deliveryStatus,
  ) async {
    try {
      actionError.value = '';
      await orderRepository.updateStatusDeliveryOrder(
        orderItemId,
        deliveryStatus,
      );
      await getDetailOrder(orderId);
      return true;
    } catch (e) {
      actionError.value = "Gagal mengupdate status pengiriman!";
      return false;
    }
  }

  void clearActionError() {
    actionError.value = '';
  }

  void clearStreamError() {
    streamError.value = '';
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
