import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  Future<String> login(String username, String password) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('name', username)
          .maybeSingle();
      if (response == null) {
        throw Exception("Login Gagal: Username atau Password salah");
      }
      bool isValid = BCrypt.checkpw(password, response['password']);
      if (!isValid) {
        throw Exception("Login Gagal: Username atau Password salah");
      }
      debugPrint("Login Berhasil! user_id: ${response["user_id"]}");
      return response["user_id"];
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
