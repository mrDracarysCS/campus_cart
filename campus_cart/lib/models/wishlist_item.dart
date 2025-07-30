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
      productId: map['menu_item_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'user_id': userId, 'menu_item_id': productId};
  }
}
