enum UserRole { guest, student, vendor }

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: UserRole.values.firstWhere(
        (r) => r.name == map['role'],
        orElse: () => UserRole.guest,
      ),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role.name,
  };

  static const guest = AppUser(
    id: 'guest',
    name: '',
    email: '',
    role: UserRole.guest,
  );
}
