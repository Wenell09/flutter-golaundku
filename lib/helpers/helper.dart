import 'package:flutter_golaundku/models/discount_model.dart';
import 'package:flutter_golaundku/models/order_item.dart';

class Helper {
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
