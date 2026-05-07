import 'package:flutter/material.dart';
import 'package:flutter_golaundku/models/order_header.dart';
import 'package:flutter_golaundku/models/order_item.dart';
import 'package:flutter_golaundku/models/order_items_model.dart';
import 'package:flutter_golaundku/models/order_model.dart';
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

  Stream<List<OrderModel>> streamOrders() {
    return supabase
        .from("orders")
        .stream(primaryKey: ["order_id"])
        .map((data) {
          return data.map((e) => OrderModel.fromJson(e)).toList();
        })
        .handleError((error) {
          throw Exception("Stream order error: $error");
        });
  }

  Future<List<OrderItemsModel>> getDetailOrder(String orderId) async {
    try {
      final result = await supabase
          .from("order_items")
          .select("*")
          .eq("order_id", orderId);
      return result.map((e) => OrderItemsModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("error get detail order:$e");
      throw Exception("error get detail order:$e");
    }
  }

  Future<void> updateStatusDeliveryOrder(
    String orderItemId,
    bool deliveryStatus,
  ) async {
    try {
      await supabase
          .from("order_items")
          .update({"delivery_status": deliveryStatus})
          .eq("order_item_id", orderItemId);
    } catch (e) {
      debugPrint("error update delivery status order:$e");
      throw Exception("error update delivery status order:$e");
    }
  }

  Future<void> updateStatusOrder(String orderId, String status) async {
    try {
      await supabase
          .from("orders")
          .update({"status": status})
          .eq("order_id", orderId);
    } catch (e) {
      debugPrint("error update status order:$e");
      throw Exception("error update status order:$e");
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
