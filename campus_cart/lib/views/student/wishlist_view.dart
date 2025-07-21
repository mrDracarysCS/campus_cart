import 'package:flutter/material.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: const Center(
        child: Text(
          'This is the Wishlist View',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
