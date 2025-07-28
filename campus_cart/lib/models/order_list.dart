class OrderList {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;

  OrderList({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
  });

  factory OrderList.fromMap(Map<String, dynamic> map) {
    return OrderList(
      id: map['id'],
      orderId: map['order_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}
