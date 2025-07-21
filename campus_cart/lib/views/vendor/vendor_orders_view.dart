import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/views/vendor/order_detail_view.dart';

class VendorOrdersView extends StatelessWidget {
  const VendorOrdersView({super.key});

  // ⚠️ Temporary sample orders
  final List<Map<String, dynamic>> sampleOrders = const [
    {'id': 101, 'buyer': 'Alex Rivera', 'total': 120.0, 'status': 'Pending'},
    {'id': 102, 'buyer': 'Jessica Lee', 'total': 75.5, 'status': 'Shipped'},
    {'id': 103, 'buyer': 'Chris Wong', 'total': 45.0, 'status': 'Delivered'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: Text(
          'Vendor Orders',
          style: GoogleFonts.patuaOne(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: sampleOrders.length,
          itemBuilder: (context, index) {
            final order = sampleOrders[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('Order #${order['id']}'),
                subtitle: Text('Buyer: ${order['buyer']} — Total: \$${order['total']}'),
                trailing: Text(
                  order['status'],
                  style: TextStyle(
                    color: _statusColor(order['status']),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailView(order: order),
                  ),
  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Shipped':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
