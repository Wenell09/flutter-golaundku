class UserModel {
  final String userId;
  final String name;
  final String role;
  UserModel({required this.userId, required this.name, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["user_id"] ?? "",
      name: json["name"] ?? "",
      role: json["role"] ?? "",
    );
  }
}
