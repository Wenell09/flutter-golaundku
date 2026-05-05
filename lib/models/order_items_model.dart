class OrderItemsModel {
  final String orderItemId;
  final String orderId;
  final String serviceId;
  final double quantity;
  final int pricePerUnit;
  final int subTotal;
  final bool deliveryStatus;

  OrderItemsModel({
    required this.orderItemId,
    required this.orderId,
    required this.serviceId,
    required this.quantity,
    required this.pricePerUnit,
    required this.subTotal,
    required this.deliveryStatus,
  });

  factory OrderItemsModel.fromJson(Map<String, dynamic> json) {
    return OrderItemsModel(
      orderItemId: json["order_item_id"] ?? "",
      orderId: json["order_id"] ?? "",
      serviceId: json["service_id"] ?? "",
      quantity: (json["quantity"] ?? 0).toDouble(),
      pricePerUnit: json["price_per_unit"] ?? 0,
      subTotal: json["subtotal"] ?? 0,
      deliveryStatus: json["delivery_status"] ?? false,
    );
  }
}
