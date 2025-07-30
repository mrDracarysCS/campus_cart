import 'package:flutter/material.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/widgets/top_web_nav_bar.dart';
import 'package:campus_cart/widgets/footer.dart';
import 'package:campus_cart/db/cart_service.dart';
import 'package:campus_cart/db/orders_service.dart';
import 'package:campus_cart/models/cart_item.dart';
import 'package:campus_cart/models/order_list.dart';
import 'package:campus_cart/models/app_user.dart';

class CartView extends StatefulWidget {
  final AppUser user;

  const CartView({super.key, required this.user});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<CartItem> cartItems = [];
  Set<int> selectedItems = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => isLoading = true);
    final items = await CartService.getCart(widget.user.id);
    setState(() {
      cartItems = items;
      isLoading = false;
    });
  }

  Future<void> _removeItem(int productId) async {
    final success = await CartService.removeFromCart(widget.user.id, productId);
    if (success) {
      _loadCart();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Item removed from cart")));
    }
  }

  Future<void> _placeOrder() async {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please select items to order")),
      );
      return;
    }

    // ✅ Group items by stall
    final Map<int, List<CartItem>> groupedByStall = {};

    for (var item in cartItems.where(
      (i) => selectedItems.contains(i.productId),
    )) {
      final stallId = item.stallId ?? 0;
      groupedByStall.putIfAbsent(stallId, () => []).add(item);
    }

    for (var entry in groupedByStall.entries) {
      final stallId = entry.key;
      final items = entry.value;

      final orderItems = items
          .map(
            (i) => OrderList(
              orderId: 0, // This will be set by Supabase after insertion
              productId: i.productId,
              quantity: i.quantity,
            ),
          )
          .toList();

      final order = await OrdersService.placeOrder(
        widget.user.id,
        stallId,
        orderItems,
      );

      if (order!.id > 0) {
        // ✅ Remove each ordered item from cart
        for (var i in items) {
          await CartService.removeFromCart(widget.user.id, i.productId);
        }
      }
    }

    await _loadCart(); // 🔄 Refresh cart after removing items

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Order placed successfully")),
    );

    // Clear selection
    setState(() {
      selectedItems.clear();
    });
  }

  double get totalPrice => cartItems
      .where((i) => selectedItems.contains(i.productId))
      .fold(0, (sum, item) => sum + (item.productPrice) * item.quantity);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          TopWebNavBar(user: widget.user),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : cartItems.isEmpty
                ? const Center(
                    child: Text(
                      "🛒 Your cart is empty!",
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: CheckboxListTile(
                                  value: selectedItems.contains(item.productId),
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        selectedItems.add(item.productId);
                                      } else {
                                        selectedItems.remove(item.productId);
                                      }
                                    });
                                  },
                                  title: Text(
                                    item.productName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Stall: ${item.stallName}"),
                                      Text(
                                        "\$${item.productPrice} x ${item.quantity}",
                                      ),
                                    ],
                                  ),
                                  secondary: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        _removeItem(item.productId),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "\$${totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _placeOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentLightColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 14,
                            ),
                          ),
                          child: const Text(
                            "Place Order",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          const Footer(),
        ],
      ),
    );
  }
}
