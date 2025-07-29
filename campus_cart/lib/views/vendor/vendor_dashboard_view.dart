import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:campus_cart/utils/constants.dart';

class VendorDashboardView extends StatefulWidget {
  const VendorDashboardView({super.key});

  @override
  State<VendorDashboardView> createState() => _VendorDashboardViewState();
}

class _VendorDashboardViewState extends State<VendorDashboardView> {
  int _selectedIndex = 0;

  final List<String> _tabs = ["Products", "Orders", "Profile"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text("Vendor Dashboard"),
        backgroundColor: kPrimaryDarkColor,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryDarkColor,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Products"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const VendorProductsTab();
      case 1:
        return const VendorOrdersTab();
      case 2:
        return const VendorProfileTab();
      default:
        return const SizedBox();
    }
  }
}

/////////////////////// ✅ PRODUCTS TAB ///////////////////////
class VendorProductsTab extends StatefulWidget {
  const VendorProductsTab({super.key});

  @override
  State<VendorProductsTab> createState() => _VendorProductsTabState();
}

class _VendorProductsTabState extends State<VendorProductsTab> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    final response =
        await Supabase.instance.client.from("menu_items").select().eq("vendor_id", Supabase.instance.client.auth.currentUser?.id as String);

    if (response is List) {
      setState(() {
        products = response;
        isLoading = false;
      });
    }
  }

  Future<void> addProduct() async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add New Product"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Product Name")),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: "Price")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty || priceController.text.isEmpty) return;

              await Supabase.instance.client.from("menu_items").insert({
                "name": nameController.text,
                "price": double.tryParse(priceController.text) ?? 0,
                "vendor_id": Supabase.instance.client.auth.currentUser?.id,
                "available": true
              });

              Navigator.pop(context);
              fetchProducts();
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return ListTile(
                leading: const Icon(Icons.fastfood),
                title: Text(p['name'] ?? 'No Name'),
                subtitle: Text("₹ ${p['price']}"),
                trailing: Switch(
                  value: p['available'] ?? true,
                  onChanged: (val) async {
                    await Supabase.instance.client
                        .from("menu_items")
                        .update({"available": val})
                        .eq("id", p['id']);
                    fetchProducts();
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Add Product"),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryDarkColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            onPressed: addProduct,
          ),
        ),
      ],
    );
  }
}

/////////////////////// ✅ ORDERS TAB ///////////////////////
class VendorOrdersTab extends StatefulWidget {
  const VendorOrdersTab({super.key});

  @override
  State<VendorOrdersTab> createState() => _VendorOrdersTabState();
}

class _VendorOrdersTabState extends State<VendorOrdersTab> {
  List<dynamic> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);
    final response = await Supabase.instance.client
        .from("orders")
        .select("id, status, total_price")
        .eq("vendor_id", Supabase.instance.client.auth.currentUser?.id as String);

    if (response is List) {
      setState(() {
        orders = response;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (orders.isEmpty) {
      return const Center(child: Text("No orders yet."));
    }

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return ListTile(
          leading: const Icon(Icons.receipt),
          title: Text("Order #${order['id']}"),
          subtitle: Text("Status: ${order['status']}"),
          trailing: Text("₹ ${order['total_price']}"),
        );
      },
    );
  }
}

/////////////////////// ✅ PROFILE TAB ///////////////////////
class VendorProfileTab extends StatelessWidget {
  const VendorProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.store, size: 80, color: kPrimaryDarkColor),
          const SizedBox(height: 12),
          Text(user?.email ?? "No Email",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(user?.id ?? "No ID",
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) Navigator.pushReplacementNamed(context, "/login");
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
