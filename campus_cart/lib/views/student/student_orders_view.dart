import 'package:flutter/material.dart';
import 'package:campus_cart/models/app_user.dart';
import 'package:campus_cart/models/order.dart';
import 'package:campus_cart/models/order_list.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/db/orders_service.dart';
import 'package:campus_cart/db/product_service.dart';

class StudentOrdersView extends StatefulWidget {
  final AppUser user;

  const StudentOrdersView({super.key, required this.user});

  @override
  State<StudentOrdersView> createState() => _StudentOrdersViewState();
}

class _StudentOrdersViewState extends State<StudentOrdersView> {
  bool isLoading = true;
  List<Order> orders = [];
  Map<int, List<OrderList>> orderItems = {};

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => isLoading = true);

    final fetchedOrders = await OrdersService.getOrders(widget.user.id);

    // Load order items for each order
    final Map<int, List<OrderList>> itemsMap = {};
    for (var order in fetchedOrders) {
      final items = await OrdersService.getOrderItems(order.id);
      itemsMap[order.id] = items;
    }

    setState(() {
      orders = fetchedOrders;
      orderItems = itemsMap;
      isLoading = false;
    });
  }

  Future<double> _calculateOrderTotal(List<OrderList> items) async {
    double total = 0;
    for (var i in items) {
      final product = await ProductService.getProduct(i.productId);
      if (product != null) {
        total += (product.price ?? 0) * i.quantity;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: kPrimaryDarkColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? const Center(
              child: Text(
                "📦 You haven't placed any orders yet!",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final items = orderItems[order.id] ?? [];

                return FutureBuilder<double>(
                  future: _calculateOrderTotal(items),
                  builder: (context, snapshot) {
                    final total = snapshot.data ?? 0;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ExpansionTile(
                        title: Text(
                          "Order #${order.id}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          "Status: ${order.status} | ${order.createdAt.toString().split(' ').first}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: Text(
                          "\$${total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        children: items.isEmpty
                            ? [
                                const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text("No items found."),
                                ),
                              ]
                            : items.map((item) {
                                return FutureBuilder(
                                  future: ProductService.getProduct(
                                    item.productId,
                                  ),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox.shrink();
                                    }
                                    final product = snapshot.data!;
                                    return ListTile(
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(
                                          product.imageUrl ??
                                              'https://via.placeholder.com/60',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(product.name),
                                      subtitle: Text(
                                        "\$${product.price.toStringAsFixed(2)} x ${item.quantity}",
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
