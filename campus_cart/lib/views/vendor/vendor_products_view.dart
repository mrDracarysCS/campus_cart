import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_cart/utils/constants.dart';

class VendorProductsView extends StatelessWidget {
  const VendorProductsView({super.key});

  // ⚠️ Temporary sample data for now
  final List<Map<String, dynamic>> sampleProducts = const [
    {'name': 'Desk Chair', 'price': 50.0, 'stock': 10},
    {'name': 'Notebook Set', 'price': 12.0, 'stock': 25},
    {'name': 'Coffee Mug', 'price': 8.0, 'stock': 30},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: Text(
          'My Products',
          style: GoogleFonts.patuaOne(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: sampleProducts.length,
          itemBuilder: (context, index) {
            final product = sampleProducts[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(product['name']),
                subtitle: Text('Price: \$${product['price']} — Stock: ${product['stock']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // TODO: Implement edit product
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // TODO: Implement delete product
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
