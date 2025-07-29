class CartItem {
  final int id;
  final String userId;
  final int productId;
  final int quantity;

  CartItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      userId: map['user_id'],
      productId: map['product_id'], // ✅ matches column name in cart_items table
      quantity: map['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}
