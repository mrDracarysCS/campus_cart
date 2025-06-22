/// Model class representing an order placed by a student
class Order {
  final int? id; // Unique ID of the order
  final String studentName; // Name of the student placing the order
  final String status; // Status of the order: pending, in_progress, ready
  final String createdAt; // Timestamp when the order was placed

  Order({
    this.id,
    required this.studentName,
    required this.status,
    required this.createdAt,
  });

  /// Converts a map (from SQLite) into an Order object
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      studentName: map['student_name'],
      status: map['status'],
      createdAt: map['created_at'],
    );
  }

  /// Converts an Order object into a map to store in SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_name': studentName,
      'status': status,
      'created_at': createdAt,
    };
  }
}
