import 'package:flutter_golaundku/models/discount_model.dart';
import 'package:flutter_golaundku/models/order_item.dart';
import 'package:intl/intl.dart';

class Helper {
  static final _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String formatRupiah(int value) {
    return _formatter.format(value);
  }

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
    int discountAmount = 0;
    if (discount.type == "percentage") {
      discountAmount = (subtotal * discount.value / 100).round();
    } else {
      discountAmount = discount.value;
    }
    if (discountAmount > subtotal) {
      discountAmount = subtotal;
    }
    return discountAmount;
  }

  int calculateTotal({
    required List<OrderItem> items,
    DiscountModel? discount,
  }) {
    final subtotal = calculateSubtotal(items);
    final discountAmount = calculateDiscountAmount(
      subtotal: subtotal,
      discount: discount,
    );
    return subtotal - discountAmount;
  }
}
