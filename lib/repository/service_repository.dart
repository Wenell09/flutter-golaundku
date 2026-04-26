import 'package:flutter/material.dart';
import 'package:flutter_golaundku/models/service_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ServiceRepository {
  final supabase = Supabase.instance.client;

  Future<void> addService(Map<String, dynamic> data) async {
    try {
      await supabase.from("services").insert({
        "service_id": Uuid().v4(),
        "name": data["name"],
        "category": data["category"],
        "price": data["price"],
        "min_weight": data["min_weight"],
        "duration": data["duration"],
      });
      debugPrint("success add service");
    } catch (e) {
      debugPrint("error add service:$e");
      throw Exception("error add service:$e");
    }
  }

  Future<List<ServiceModel>> getService() async {
    try {
      final response = await supabase.from("services").select();
      debugPrint("result get service:$response");
      return response.map((e) => ServiceModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("error get service:$e");
      throw Exception("error get service:$e");
    }
  }

  Future<void> updateService(Map<String, dynamic> data) async {
    try {
      await supabase
          .from("services")
          .update({
            "name": data["name"],
            "category": data["category"],
            "price": data["price"],
            "min_weight": data["min_weight"],
            "duration": data["duration"],
          })
          .eq("service_id", data["service_id"]);
    } catch (e) {
      debugPrint("error update service:$e");
      throw Exception("error update service:$e");
    }
  }

  Future<void> deleteService(String serviceId) async {
    try {
      await supabase.from("services").delete().eq("service_id", serviceId);
    } catch (e) {
      debugPrint("error delete service:$e");
      throw Exception("error delete service:$e");
    }
  }
}
