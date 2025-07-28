import 'package:flutter/material.dart';
import '../db/auth_service.dart';
import '../db/stalls_service.dart';
import '../db/orders_service.dart';
import '../db/cart_service.dart';
import '../db/wishlist_service.dart';
import '../models/app_user.dart';
import '../models/product.dart';
import '../models/order_list.dart';
import '../models/stall.dart';

class BackendTestView extends StatefulWidget {
  const BackendTestView({super.key});

  @override
  State<BackendTestView> createState() => _BackendTestViewState();
}

class _BackendTestViewState extends State<BackendTestView> {
  AppUser? currentUser;
  List<Stall> stalls = [];
  Stall? selectedStall;
  List<Product> products = [];
  List orders = [];
  String status = "🚀 Ready";

  void _setStatus(String msg) => setState(() => status = msg);

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final user = await AuthService.getCurrentUser();
    setState(() => currentUser = user);
    _setStatus(
      user != null ? "✅ Logged in as ${user.name}" : "ℹ️ Not logged in",
    );
  }

  Future<void> _registerAndLogin() async {
    _setStatus("🔄 Registering user...");
    final user = await AuthService.register(
      "teststudent@campus.com",
      "password123",
      "Test Student",
      UserRole.student,
    );

    if (user == null) {
      _setStatus("⚠️ Registration failed (maybe user exists). Trying login...");
      await _login(); // Try logging in if already exists
    } else {
      setState(() => currentUser = user);
      _setStatus("✅ Registered and logged in as ${user.name}");
    }
  }

  Future<void> _login() async {
    _setStatus("🔄 Logging in...");
    final user = await AuthService.login(
      "teststudent@campus.com",
      "password123",
    );
    if (user != null) {
      setState(() => currentUser = user);
      _setStatus("✅ Logged in as ${user.name}");
    } else {
      _setStatus("❌ Login failed");
    }
  }

  Future<void> _getStalls() async {
    final res = await StallsService.getStalls();
    setState(() {
      stalls = res;
      if (res.isNotEmpty) selectedStall = res.first;
    });
    _setStatus("✅ Loaded ${res.length} stalls");
  }

  Future<void> _getProducts() async {
    if (selectedStall == null) return _setStatus("⚠️ Select a stall first");
    final res = await StallsService.getProducts(selectedStall!.id);
    setState(() => products = res);
    _setStatus("✅ Loaded ${res.length} products");
  }

  Future<void> _placeOrder() async {
    if (currentUser == null) return _setStatus("⚠️ Login first");
    if (products.isEmpty) return _setStatus("⚠️ Load products first");

    final orderList = [
      OrderList(id: 0, orderId: 0, productId: products.first.id, quantity: 2),
    ];
    final order = await OrdersService.placeOrder(
      currentUser!.id,
      selectedStall!.id,
      orderList,
    );
    _setStatus("✅ Order placed (ID: ${order.id})");
  }

  Future<void> _getOrders() async {
    if (currentUser == null) return _setStatus("⚠️ Login first");
    final res = await OrdersService.getOrders(currentUser!.id);
    setState(() => orders = res);
    _setStatus("✅ Found ${res.length} orders");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Backend Tester")),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.all(8),
            child: Text(status, style: const TextStyle(color: Colors.green)),
          ),
          const Divider(),
          if (currentUser != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Logged in as: ${currentUser!.name}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: _registerAndLogin,
                child: const Text("Register & Login"),
              ),
              ElevatedButton(
                onPressed: _login,
                child: const Text("Login Only"),
              ),
              ElevatedButton(
                onPressed: _getStalls,
                child: const Text("Get Stalls"),
              ),
              ElevatedButton(
                onPressed: _getProducts,
                child: const Text("Get Products"),
              ),
              ElevatedButton(
                onPressed: _placeOrder,
                child: const Text("Place Order"),
              ),
              ElevatedButton(
                onPressed: _getOrders,
                child: const Text("Get Orders"),
              ),
            ],
          ),
          const Divider(),
          if (stalls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: DropdownButton<Stall>(
                value: selectedStall,
                hint: const Text("Select Stall"),
                items: stalls
                    .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                    .toList(),
                onChanged: (stall) => setState(() => selectedStall = stall),
              ),
            ),
          Expanded(
            child: ListView(
              children: [
                _buildSection(
                  "Products",
                  products
                      .map(
                        (p) => "${p.name} - \$${p.price} (${p.stock} in stock)",
                      )
                      .toList(),
                ),
                _buildSection(
                  "Orders",
                  orders.map((o) => "Order #${o.id} (${o.status})").toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: items.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("No data"),
                ),
              ]
            : items.map((e) => ListTile(title: Text(e))).toList(),
      ),
    );
  }
}
