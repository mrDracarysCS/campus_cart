/// Model class representing a food stall
class Stall {
  final int? id; // Unique ID of the stall (auto-incremented by DB)
  final String name; // Name of the stall
  final String? description; // Optional description of the stall

  Stall({this.id, required this.name, this.description});

  /// Converts a map (from SQLite) into a Stall object
  factory Stall.fromMap(Map<String, dynamic> map) {
    return Stall(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  /// Converts a Stall object into a map to store in SQLite
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'description': description};
  }
}
