class CustomerModel {
  final String customerId;
  final String name;
  final String phone;
  final String address;
  CustomerModel({
    required this.customerId,
    required this.name,
    required this.phone,
    required this.address,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json["customer_id"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
    );
  }
}
