import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_cart/utils/constants.dart';

class OrderDetailView extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Sample items (replace with real order items)
    final List<Map<String, dynamic>> items = [
      {'name': 'Notebook Set', 'quantity': 2, 'price': 12.0},
      {'name': 'Desk Chair', 'quantity': 1, 'price': 50.0},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: Text(
          'Order #${order['id']}',
          style: GoogleFonts.patuaOne(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Buyer: ${order['buyer']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Status: ${order['status']}'),
            const Divider(height: 32),
            const Text(
              'Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => ListTile(
                  title: Text(item['name']),
                  subtitle: Text('Quantity: ${item['quantity']}'),
                  trailing: Text('\$${item['price']}'),
                )),
            const Divider(height: 32),
            Text(
              'Total: \$${order['total']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Update order status
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order status updated!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentLightColor,
                foregroundColor: kPrimaryDarkColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Update Status'),
            ),
          ],
        ),
      ),
    );
  }
}
