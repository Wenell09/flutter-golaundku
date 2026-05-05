class DiscountModel {
  final String discountId;
  final String name;
  final String type;
  final int value;
  final bool active;

  DiscountModel({
    required this.discountId,
    required this.name,
    required this.type,
    required this.value,
    required this.active,
  });
  bool get isPercentage => type == "percentage";

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      discountId: json["discount_id"] ?? "",
      name: json["name"] ?? "",
      type: json["type"] ?? "",
      value: json["value"] ?? 0,
      active: json["active"] ?? false,
    );
  }

 
}
