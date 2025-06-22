/// Model class representing an item on a stall's menu
class MenuItem {
  final int? id; // Unique ID of the menu item
  final int stallId; // ID of the associated stall (foreign key)
  final String name; // Name of the menu item
  final double price; // Price of the item
  final int stock; // Stock count for the item

  MenuItem({
    this.id,
    required this.stallId,
    required this.name,
    required this.price,
    required this.stock,
  });

  /// Converts a map (from SQLite) into a MenuItem object
  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'],
      stallId: map['stall_id'],
      name: map['name'],
      price: map['price'],
      stock: map['stock'],
    );
  }

  /// Converts a MenuItem object into a map to store in SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stall_id': stallId,
      'name': name,
      'price': price,
      'stock': stock,
    };
  }
}
