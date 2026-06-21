class UserModel {
  final String userId;
  final String username;
  final String role;
  UserModel({required this.userId, required this.username, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["user_id"] ?? "",
      username: json["username"] ?? "",
      role: json["role"] ?? "",
    );
  }
}
