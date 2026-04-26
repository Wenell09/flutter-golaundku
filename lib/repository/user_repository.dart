import 'package:flutter/material.dart';
import 'package:flutter_golaundku/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final supabase = Supabase.instance.client;
  Future<UserModel> getUser(String userId) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from("users")
          .select("user_id,name,role")
          .eq("user_id", userId)
          .single();
      if (response.isEmpty) {
        throw Exception("error get users");
      }
      debugPrint("result get users:$response");
      return UserModel.fromJson(response);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
