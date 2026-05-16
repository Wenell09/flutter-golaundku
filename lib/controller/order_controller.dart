import 'dart:async';

import 'package:flutter_golaundku/models/customer_model.dart';
import 'package:flutter_golaundku/models/discount_model.dart';
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
  final errorMessage = ''.obs;
  final orderData = <OrderModel>[].obs;
  late Map<String, CustomerModel> _customerMap;
  late Map<String, DiscountModel> _discountMap;
  List<CustomerModel> _customers = [];
  List<DiscountModel> _discounts = [];
  final isDetailLoading = false.obs;
  final detailOrderData = <OrderItemsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    streamOrders();
  }

  Future<void> streamOrders() async {
    try {
      isLoading.value = true;
      await _subscription?.cancel();
      _customers = await customerRepository.getCustomers();
      _discounts = await discountRepository.getDiscounts();
      _customerMap = {for (var c in _customers) c.customerId: c};
      _discountMap = {for (var d in _discounts) d.discountId: d};
      _subscription = orderRepository.streamOrders().listen(
        (orders) {
          final mappedOrders = orders.map((order) {
            final customer = _customerMap[order.customerId];
            final discount = _discountMap[order.discountId];
            return order.copyWith(
              customerModel: customer,
              discountModel: discount,
            );
          }).toList();
          orderData.assignAll(mappedOrders);
          isLoading.value = false;
        },
        onError: (error) {
          errorMessage.value = error.toString();
          isLoading.value = false;
        },
      );
    } catch (e) {
      errorMessage.value = "Gagal load master data";
      isLoading.value = false;
    }
  }

  Future<bool> createOrder(
    OrderHeader orderHeader,
    List<OrderItem> items,
  ) async {
    try {
      isLoading.value = true;
      await orderRepository.addOrder(orderHeader, items);
      isLoading.value = false;
      return true;
    } catch (e) {
      errorMessage.value = "Gagal menambahkan orders!";
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      await orderRepository.updateStatusOrder(orderId, status);
      return true;
    } catch (e) {
      errorMessage.value = "Gagal mengupdate status order!";
      return false;
    }
  }

  Future<bool> updatePaymentConfirm(
    String orderId,
    String paymentStatus,
  ) async {
    try {
      await orderRepository.paymentConfirm(orderId, paymentStatus);
      return true;
    } catch (e) {
      errorMessage.value = "Gagal mengupdate konfirmasi pembayaran!";
      return false;
    }
  }

  Future<void> getDetailOrder(String orderId) async {
    try {
      isDetailLoading.value = true;
      final result = await orderRepository.getDetailOrder(orderId);
      detailOrderData.assignAll(result);
      isDetailLoading.value = false;
    } catch (e) {
      errorMessage.value = "Gagal mengambil detail order!";
      isDetailLoading.value = false;
    }
  }

  Future<bool> updateShippingStatus(
    String orderId,
    String orderItemId,
    bool deliveryStatus,
  ) async {
    try {
      await orderRepository.updateStatusDeliveryOrder(
        orderItemId,
        deliveryStatus,
      );
      await getDetailOrder(orderId);
      return true;
    } catch (e) {
      errorMessage.value = "Gagal mengupdate status pengiriman!";
      return false;
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
