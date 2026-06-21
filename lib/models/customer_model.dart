class CustomerModel {
  final String customerId;
  final String nameCustomer;
  final String phone;
  final String address;
  CustomerModel({
    required this.customerId,
    required this.nameCustomer,
    required this.phone,
    required this.address,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json["customer_id"] ?? "",
      nameCustomer: json["name_customer"] ?? "",
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
    );
  }
}
