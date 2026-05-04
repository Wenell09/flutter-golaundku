class OrderHeader {
  final String customerId;
  final String userId;
  final String? discountId;
  final DateTime orderDate;
  final int totalPrice;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final String notes;

  OrderHeader({
    required this.customerId,
    required this.userId,
    this.discountId,
    required this.orderDate,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      "customer_id": customerId,
      "user_id": userId,
      "discount_id": discountId,
      "order_date": orderDate.toIso8601String(),
      "total_price": totalPrice,
      "status": status,
      "payment_method": paymentMethod,
      "payment_status": paymentStatus,
      "notes": notes,
    };
  }
}
