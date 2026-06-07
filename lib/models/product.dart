class Product {
  final int id;
  final String name;
  final double price;
  final String? category;
  final int? stock;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.category,
    this.stock,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        category: json['category'] as String?,
        stock: json['stock'] as int?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toInsertJson() => {
        'name': name,
        'price': price,
        if (category != null) 'category': category,
        if (stock != null) 'stock': stock,
      };
}
