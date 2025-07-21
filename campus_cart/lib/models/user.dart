enum UserRole { guest, student, vendor }

class User {
  final int id;
  final String name;
  final String email;
  final UserRole role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  /// Convert a User object to a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name, // stored as 'guest', 'student', or 'vendor'
    };
  }

  /// Convert a SQLite Map to a User object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      role: UserRole.values.firstWhere((r) => r.name == map['role']),
    );
  }

  // Sample users for testing
  static const guest = User(
    id: -1,
    name: '',
    email: '',
    role: UserRole.guest,
  );

  static const sampleStudent = User(
    id: 1,
    name: 'Alex Rivera',
    email: 'alex@student.edu',
    role: UserRole.student,
  );

  static const sampleVendor = User(
    id: 2,
    name: 'Vendor Jane',
    email: 'jane@vendor.com',
    role: UserRole.vendor,
  );
}
