import 'package:flutter/material.dart';

class VendorDashboard extends StatelessWidget {
  const VendorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final inventory = [
      {'name': 'Burger', 'stock': 10},
      {'name': 'Pizza', 'stock': 3},
      {'name': 'Coffee', 'stock': 0},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Vendor Dashboard")),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Inventory", style: TextStyle(fontSize: 20)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: inventory.length,
                    itemBuilder: (context, index) {
                      final item = inventory[index];
                      return ListTile(
                        title: Text(item['name']),
                        trailing: Text(
                          'Stock: ${item['stock']}',
                          style: TextStyle(
                            color: item['stock'] == 0
                                ? Colors.red
                                : item['stock'] < 4
                                    ? Colors.orange
                                    : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: Column(
              children: const [
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Orders", style: TextStyle(fontSize: 20)),
                ),
                Expanded(
                  child: Center(child: Text("Orders will appear here")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
