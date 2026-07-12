class ProductModel {
  final String? id;
  final String name;
  final String description;
  final String image;

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  // ==========================
  // FROM JSON
  // ==========================
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      image: json["image"] ?? "",
    );
  }

  // ==========================
  // TO JSON
  // ==========================
  Map<String, dynamic> toJson() {
    return {"name": name, "description": description, "image": image};
  }

  // ==========================
  // COPY WITH
  // ==========================
  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }
}
