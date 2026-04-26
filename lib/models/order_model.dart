class OrderModel {
  final String orderId;
  final String customerId;
  final String userId;
  final String discountId;
  final String orderDate;
  final String estimatedDate;
  final int totalPrice;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final String notes;

  OrderModel({
    required this.orderId,
    required this.customerId,
    required this.userId,
    required this.discountId,
    required this.orderDate,
    required this.estimatedDate,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.notes,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json["order_id"] ?? "",
      customerId: json["customer_id"] ?? "",
      userId: json["user_id"] ?? "",
      discountId: json["discount_id"] ?? "",
      orderDate: json["order_date"] ?? "",
      estimatedDate: json["estimated_date"] ?? "",
      totalPrice: json["total_price"] ?? 0,
      status: json["status"] ?? "",
      paymentStatus: json["payment_status"] ?? "",
      paymentMethod: json["payment_method"] ?? "",
      notes: json["notes"] ?? "",
    );
  }
}
