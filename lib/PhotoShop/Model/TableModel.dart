class TableModel {
  final int id;
  final DateTime createdAt;
  final String price;
  final String description;
  final String image1;
  final String image2;
  final String image3;

  TableModel({
    required this.id,
    required this.createdAt,
    required this.price,
    required this.description,
    required this.image1,
    required this.image2,
    required this.image3,
  });

  factory TableModel.fromMap(Map<String, dynamic> map) {
    return TableModel(
      id: map['id'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
      price: map['price'].toString(),
      description: map['description'] ?? '',
      image1: map['image1'] ?? '',
      image2: map['image2'] ?? '',
      image3: map['image3'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'price': price,
      'description': description,
      'image1': image1,
      'image2': image2,
      'image3': image3,
    };
  }
}
