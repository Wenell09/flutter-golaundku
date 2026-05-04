import 'package:uuid/uuid.dart';

class OrderItem {
  final String orderItemId;
  final String serviceId;
  final double quantity;
  final int pricePerUnit;
  final int subtotal;
  final bool deliveryStatus;

  OrderItem({
    required this.orderItemId,
    required this.serviceId,
    required this.quantity,
    required this.pricePerUnit,
    required this.subtotal,
    required this.deliveryStatus,
  });

  Map<String, dynamic> toMap(String orderId) {
    return {
      "order_item_id": orderItemId,
      "order_id": orderId,
      "service_id": serviceId,
      "quantity": quantity,
      "price_per_unit": pricePerUnit,
      "subtotal": subtotal,
      "delivery_status": deliveryStatus,
    };
  }
}
