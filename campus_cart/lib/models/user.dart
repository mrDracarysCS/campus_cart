enum UserRole { guest, student, vendor }

class User {
  final int id;
  final String name;
  final UserRole role;

  const User({
    required this.id,
    required this.name,
    required this.role,
  });

  /// Convert a User object to a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role.name, // stored as 'guest', 'student', or 'vendor'
    };
  }

  /// Convert a SQLite Map to a User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      role: UserRole.values.firstWhere((r) => r.name == map['role']),
    );
  }

  // Sample users for testing
  static const guest = User(id: -1, name: '', role: UserRole.guest);
  static const sampleStudent = User(id: 1, name: 'Alex Rivera', role: UserRole.student);
  static const sampleVendor = User(id: 2, name: 'Vendor Jane', role: UserRole.vendor);
}
