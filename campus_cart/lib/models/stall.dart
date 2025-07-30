class Stall {
  final int id;
  final String name;
  final String description;
  final String? ownerId;

  Stall({
    required this.id,
    required this.name,
    required this.description,
    this.ownerId,
  });

  factory Stall.fromMap(Map<String, dynamic> map) {
    return Stall(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      ownerId: map['owner_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'owner_id': ownerId,
    };
  }
}
