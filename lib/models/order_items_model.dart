class OrderItemsModel {
  final String orderItemId;
  final String orderId;
  final String serviceId;
  final num quantity;
  final int pricePerUnit;
  final int subTotal;

  OrderItemsModel({
    required this.orderItemId,
    required this.orderId,
    required this.serviceId,
    required this.quantity,
    required this.pricePerUnit,
    required this.subTotal,
  });

  factory OrderItemsModel.fromJson(Map<String, dynamic> data) {
    return OrderItemsModel(
      orderItemId: data["order_item_id"] ?? "",
      orderId: data["order_id"] ?? "",
      serviceId: data["service_id"] ?? "",
      quantity: data["quantity"] ?? 0,
      pricePerUnit: data["price_per_unit"] ?? 0,
      subTotal: data["sub_total"] ?? 0,
    );
  }
}
