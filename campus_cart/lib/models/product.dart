class Product {
  final int id;
  final int stallId;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String? imageUrl;
  final bool shippable;

  Product({
    required this.id,
    required this.stallId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    required this.shippable,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      stallId: map['stall_id'],
      name: map['name'],
      description: map['description'] ?? '',
      price: (map['price'] as num).toDouble(),
      stock: map['stock'] ?? 0,
      imageUrl: map['image_url'],
      shippable: map['shippable'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stall_id': stallId,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
      'shippable': shippable,
    };
  }
}
