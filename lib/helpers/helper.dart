import 'package:flutter_golaundku/models/discount_model.dart';
import 'package:flutter_golaundku/models/order_item.dart';
import 'package:intl/intl.dart';

class Helper {
  static String toIndoDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  int calculateSubtotal(List<OrderItem> items) {
    return items.fold(0, (sum, item) => sum + item.subtotal);
  }

  int calculateDiscountAmount({
    required int subtotal,
    DiscountModel? discount,
  }) {
    if (discount == null) return 0;

    if (discount.type == "percentage") {
      return (subtotal * discount.value / 100).round();
    } else {
      return discount.value;
    }
  }

  int calculateTotal({
    required List<OrderItem> items,
    DiscountModel? discount,
  }) {
    final grossTotal = items.fold(0, (sum, item) => sum + item.subtotal);
    if (discount == null) return grossTotal;
    int discountAmount = 0;
    if (discount.type == "percentage") {
      discountAmount = (grossTotal * discount.value / 100).round();
    } else {
      discountAmount = discount.value;
    }
    return grossTotal - discountAmount;
  }
}
