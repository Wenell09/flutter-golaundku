import 'package:flutter_golaundku/models/user_model.dart';
import 'package:flutter_golaundku/repository/user_repository.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserRepository userRepository;
  UserController(this.userRepository);
  final isLoading = false.obs;
  final userData = Rxn<UserModel>();

  final isError = false.obs;

  Future<void> getUser(String userId) async {
    try {
      isLoading.value = true;
      isError.value = false;

      final result = await userRepository.getUser(userId);

      userData.value = result;
    } catch (e) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
