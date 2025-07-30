class CartItem {
  final int id;
  final String userId;
  final int productId;
  final int quantity;
  final String productName;
  final double productPrice;
  final String? productImage;
  final String stallName;
  final int? stallId; // ✅ Added

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.stallName,
    required this.stallId, // ✅ Added
  });

  /// ✅ Parse Supabase JOIN query result
  factory CartItem.fromSupabase(Map<String, dynamic> map) {
    final product = map['products'] ?? {};
    final stall = product['stalls'] ?? {};

    return CartItem(
      id: map['id'],
      userId: map['user_id'],
      productId: map['product_id'],
      quantity: map['quantity'] ?? 1,
      productName: product['name'] ?? '',
      productPrice: (product['price'] ?? 0).toDouble(),
      productImage: product['image_url'],
      stallName: stall['name'] ?? '',
      stallId: product['stall_id'], // ✅ Added
    );
  }
}
