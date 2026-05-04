import 'package:flutter/material.dart';
import 'package:flutter_golaundku/models/order_header.dart';
import 'package:flutter_golaundku/models/order_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final supabase = Supabase.instance.client;

  Future<void> addOrder(OrderHeader header, List<OrderItem> items) async {
    final supabase = Supabase.instance.client;
    try {
      final orderResponse = await supabase
          .from('orders')
          .insert(header.toMap())
          .select()
          .single();
      final String orderId = orderResponse['order_id'];
      final itemsPayload = items.map((e) => e.toMap(orderId)).toList();
      await supabase.from('order_items').insert(itemsPayload);
    } catch (e) {
      debugPrint("error add order:$e");
      throw Exception(e.toString());
    }
  }

  // Stream<List<OrderModel>> streamOrdersFIFO() {
  //   return supabase
  //       .from("orders")
  //       .stream(primaryKey: ["order_id"])
  //       .order("order_date", ascending: true)
  //       .map((data) {
  //         return data
  //             .map((e) => OrderModel.fromJson(e))
  //             .where(
  //               (order) =>
  //                   order.status != "Selesai" && order.status != "Diantar",
  //             )
  //             .toList();
  //       });
  // }
}
