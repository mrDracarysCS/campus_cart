class Order {
  final int id;
  final String userId;
  final int stallId;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.stallId,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromMap(Map<String, dynamic> map) => Order(
    id: map['id'],
    userId: map['user_id'],
    stallId: map['stall_id'],
    status: map['status'],
    createdAt: DateTime.parse(map['created_at']),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'stall_id': stallId,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };
}
