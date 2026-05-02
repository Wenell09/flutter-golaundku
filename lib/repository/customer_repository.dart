import 'package:flutter/material.dart';
import 'package:flutter_golaundku/models/customer_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CustomerRepository {
  final supabase = Supabase.instance.client;

  Future<void> addCustomer(Map<String, dynamic> data) async {
    try {
      await supabase.from("customers").insert({
        "customer_id": Uuid().v4(),
        "name": data["name"],
        "phone": data["phone"],
        "address": data["address"],
      });
      debugPrint("success add customer");
    } catch (e) {
      debugPrint("error add customer:$e");
      throw Exception("error add customer:$e");
    }
  }

  Stream<List<CustomerModel>> streamCustomers() {
    return supabase
        .from("customers")
        .stream(primaryKey: ["customer_id"])
        .map((data) => data.map((e) => CustomerModel.fromJson(e)).toList())
        .handleError((error) {
          throw Exception("Stream customer error: $error");
        });
  }

  Future<void> updateCustomer(Map<String, dynamic> data) async {
    try {
      await supabase
          .from("customers")
          .update({
            "name": data["name"],
            "phone": data["phone"],
            "address": data["address"],
          })
          .eq("customer_id", data["customer_id"]);
    } catch (e) {
      debugPrint("error update customer:$e");
      throw Exception("error update customer:$e");
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    try {
      await supabase.from("customers").delete().eq("customer_id", customerId);
    } catch (e) {
      debugPrint("error delete customer:$e");
      throw Exception("error delete customer:$e");
    }
  }
}
