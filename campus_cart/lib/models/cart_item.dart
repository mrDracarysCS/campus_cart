class CartItem {
  final int id;
  final String userId;
  final int productId;
  final int quantity;
  final String productName;
  final double price;
  final String? imageUrl;
  final String stallName;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.productName,
    required this.price,
    this.imageUrl,
    required this.stallName,
  });

  /// ✅ Parse data returned by Supabase JOIN query
  factory CartItem.fromSupabase(Map<String, dynamic> map) {
    final product = map['products'] ?? {};
    final stall = product['stalls'] ?? {};

    return CartItem(
      id: map['id'],
      userId: map['user_id'],
      productId: map['product_id'],
      quantity: map['quantity'] ?? 1,
      productName: product['name'] ?? '',
      price: (product['price'] ?? 0).toDouble(),
      imageUrl: product['image_url'],
      stallName: stall['name'] ?? '',
    );
  }

  /// ✅ If you also need a `toMap()` function
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
      'product_name': productName,
      'price': price,
      'image_url': imageUrl,
      'stall_name': stallName,
    };
  }
}
