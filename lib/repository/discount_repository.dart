import 'package:flutter/material.dart';
import 'package:flutter_golaundku/models/discount_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class DiscountRepository {
  final supabase = Supabase.instance.client;
  Future<void> addDiscount(Map<String, dynamic> data) async {
    try {
      await supabase.from("discounts").insert({
        "discount_id": Uuid().v4(),
        "name": data["name"],
        "type": data["type"],
        "value": data["value"],
        "active": data["active"],
      });
      debugPrint("success add discount");
    } catch (e) {
      debugPrint("error add discount:$e");
      throw Exception("error add discount:$e");
    }
  }

  Future<List<DiscountModel>> getDiscount() async {
    try {
      final response = await supabase.from("discounts").select();
      debugPrint("result get discounts:$response");
      return response.map((e) => DiscountModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("error get discounts:$e");
      throw Exception("error get discounts:$e");
    }
  }

  Future<void> updateDiscount(Map<String, dynamic> data) async {
    try {
      await supabase
          .from("discounts")
          .update({
            "name": data["name"],
            "type": data["type"],
            "value": data["value"],
            "active": data["active"],
          })
          .eq("discount_id", data["discount_id"]);
    } catch (e) {
      debugPrint("error update discount:$e");
      throw Exception("error update discount:$e");
    }
  }

  Future<void> deleteDiscount(String discountId) async {
    try {
      await supabase.from("discounts").delete().eq("discount_id", discountId);
    } catch (e) {
      debugPrint("error delete discount:$e");
      throw Exception("error delete discount:$e");
    }
  }
}
