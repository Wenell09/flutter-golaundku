import 'package:flutter_golaundku/repository/auth_repository.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;
  AuthController(this.authRepository);

  final isLoading = false.obs;
  final userId = ''.obs;
  final errorMessage = ''.obs;

  Future<void> login({required String name, required String password}) async {
    try {
      isLoading.value = true;
      final result = await authRepository.login(name, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', result);
      userId.value = result;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = "Pastikan Username dan Password sesuai!";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    userId.value = '';
  }
}
