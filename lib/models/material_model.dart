class MaterialModel {
  final String materialId;
  final String name;
  final int stock;
  final String unit;
  final int minStock;

  MaterialModel({
    required this.materialId,
    required this.name,
    required this.stock,
    required this.unit,
    required this.minStock,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      materialId: json["material_id"] ?? "",
      name: json["name"] ?? "",
      stock: json["stock"] ?? 0,
      unit: json["unit"] ?? "",
      minStock: json["min_stock"] ?? 0,
    );
  }
}
