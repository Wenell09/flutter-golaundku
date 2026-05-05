import 'package:flutter_golaundku/models/customer_model.dart';
import 'package:flutter_golaundku/models/discount_model.dart';

class OrderModel {
  final String orderId;
  final String customerId;
  final String userId;
  final String discountId;
  final CustomerModel? customerModel;
  final DiscountModel? discountModel;
  final DateTime orderDate;
  final DateTime estimatedDate;
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
    this.customerModel,
    this.discountModel,
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
      orderDate: DateTime.parse(json["order_date"]),
      estimatedDate: DateTime.parse(json["estimated_date"]),
      totalPrice: json["total_price"] ?? 0,
      status: json["status"] ?? "",
      paymentStatus: json["payment_status"] ?? "",
      paymentMethod: json["payment_method"] ?? "",
      notes: json["notes"] ?? "",
    );
  }

  OrderModel copyWith({
    CustomerModel? customerModel,
    DiscountModel? discountModel,
  }) {
    return OrderModel(
      orderId: orderId,
      customerId: customerId,
      userId: userId,
      discountId: discountId,
      customerModel: customerModel ?? this.customerModel,
      discountModel: discountModel ?? this.discountModel,
      orderDate: orderDate,
      estimatedDate: estimatedDate,
      totalPrice: totalPrice,
      status: status,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      notes: notes,
    );
  }
}
