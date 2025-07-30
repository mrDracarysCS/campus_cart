class OrderList {
  final int? id; // ✅ Make it nullable
  final int orderId;
  final int productId;
  final int quantity;

  OrderList({
    this.id, // ✅ Optional (DB will assign)
    required this.orderId,
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // ✅ Only send if available
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
    };
  }

  factory OrderList.fromMap(Map<String, dynamic> map) {
    return OrderList(
      id: map['id'],
      orderId: map['order_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
    );
  }
}
