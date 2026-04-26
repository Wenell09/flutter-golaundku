import 'package:flutter/material.dart';
import 'package:flutter_golaundku/models/material_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class MaterialRepository {
  final supabase = Supabase.instance.client;

  Future<void> addMaterial(Map<String, dynamic> data) async {
    try {
      await supabase.from("materials").insert({
        "material_id": Uuid().v4(),
        "name": data["name"],
        "stock": data["stock"],
        "unit": data["unit"],
        "min_stock": data["min_stock"],
      });
      debugPrint("success add material");
    } catch (e) {
      debugPrint("error add material:$e");
      throw Exception("error add material:$e");
    }
  }

  Future<List<MaterialModel>> getMaterial() async {
    try {
      final response = await supabase.from("materials").select();
      debugPrint("result get materials:$response");
      return response.map((e) => MaterialModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint("error get materials:$e");
      throw Exception("error get materials:$e");
    }
  }

  Future<void> updateMaterial(Map<String, dynamic> data) async {
    try {
      await supabase
          .from("materials")
          .update({
            "name": data["name"],
            "stock": data["stock"],
            "unit": data["unit"],
            "min_stock": data["min_stock"],
          })
          .eq("material_id", data["material_id"]);
    } catch (e) {
      debugPrint("error update material:$e");
      throw Exception("error update material:$e");
    }
  }

  Future<void> deleteMaterial(String materialId) async {
    try {
      await supabase.from("materials").delete().eq("material_id", materialId);
    } catch (e) {
      debugPrint("error delete material:$e");
      throw Exception("error delete material:$e");
    }
  }
}
