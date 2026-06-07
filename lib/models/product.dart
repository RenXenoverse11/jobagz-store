class Product {
  final int id;
  final String name;
  final double price;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toInsertJson() => {
        'name': name,
        'price': price,
      };
}
