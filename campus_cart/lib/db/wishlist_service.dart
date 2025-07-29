class WishlistItem {
  final int id;
  final String userId;
  final int productId;

  WishlistItem({
    required this.id,
    required this.userId,
    required this.productId,
  });

  factory WishlistItem.fromMap(Map<String, dynamic> map) {
    return WishlistItem(
      id: map['id'],
      userId: map['user_id'],
      productId: map['product_id'], // ✅ matches column name in wishlist table
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'user_id': userId, 'product_id': productId};
  }
}
