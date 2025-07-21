/// Model class representing a specific item in an order
class OrderItem {
  final int? id; // Unique ID of the order item
  final int orderId; // ID of the associated order (foreign key)
  final int itemId; // ID of the menu item being ordered
  final int quantity; // Quantity of the menu item ordered

  OrderItem({
    this.id,
    required this.orderId,
    required this.itemId,
    required this.quantity,
  });

  /// Converts a map (from SQLite) into an OrderItem object
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      orderId: map['order_id'],
      itemId: map['item_id'],
      quantity: map['quantity'],
    );
  }

  /// Converts an OrderItem object into a map to store in SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'item_id': itemId,
      'quantity': quantity,
    };
  }
}
