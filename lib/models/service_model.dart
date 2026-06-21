class ServiceModel {
  final String serviceId;
  final String nameService;
  final String category;
  final int price;
  final String unit;
  final int minWeight;
  final int duration;

  ServiceModel({
    required this.serviceId,
    required this.nameService,
    required this.category,
    required this.price,
    required this.unit,
    required this.minWeight,
    required this.duration,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: json["service_id"] ?? "",
      nameService: json["name_service"] ?? "",
      category: json["category"] ?? "",
      price: json["price"] ?? 0,
      unit: json["unit"] ?? "",
      minWeight: json["min_weight"] ?? 0,
      duration: json["duration"] ?? 0,
    );
  }
}
