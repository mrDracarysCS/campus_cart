import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/widgets/top_web_nav_bar.dart';
import 'package:campus_cart/widgets/footer.dart';
import 'package:campus_cart/models/app_user.dart';
import 'package:campus_cart/db/product_service.dart';
import 'package:campus_cart/views/vendor/add_product_view.dart';

class VendorDashboardView extends StatefulWidget {
  final AppUser user;

  const VendorDashboardView({super.key, required this.user});

  @override
  State<VendorDashboardView> createState() => _VendorDashboardViewState();
}

class _VendorDashboardViewState extends State<VendorDashboardView> {
  int _selectedIndex = 0;
  final List<String> _menuItems = ["Orders", "Inventory", "Account"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          TopWebNavBar(user: widget.user),
          Expanded(
            child: Row(
              children: [
                _buildSideMenu(),
                Expanded(child: _buildContentArea()),
              ],
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }

  /// ✅ Left Sidebar Menu
  Widget _buildSideMenu() {
    return Container(
      width: 220,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Vendor Dashboard",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kPrimaryDarkColor,
            ),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < _menuItems.length; i++)
            ListTile(
              leading: Icon(
                i == 0
                    ? Icons.shopping_bag
                    : i == 1
                    ? Icons.inventory
                    : Icons.person,
                color: _selectedIndex == i ? kAccentLightColor : Colors.black54,
              ),
              title: Text(
                _menuItems[i],
                style: TextStyle(
                  fontWeight: _selectedIndex == i
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedIndex == i
                      ? kAccentLightColor
                      : Colors.black87,
                ),
              ),
              onTap: () => setState(() => _selectedIndex = i),
            ),
        ],
      ),
    );
  }

  /// ✅ Main Content Area
  Widget _buildContentArea() {
    switch (_selectedIndex) {
      case 0:
        return _ordersSection();
      case 1:
        return _inventorySection();
      case 2:
        return _accountSection();
      default:
        return const Center(child: Text("Select an option"));
    }
  }

  /// 📦 Orders Section
  Widget _ordersSection() {
    return const Center(
      child: Text(
        "📦 Orders Section (Upcoming Orders, Order Status, etc.)",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  /// 📦 Inventory Section → List stalls, add products, view products
  Widget _inventorySection() {
    return FutureBuilder(
      future: Supabase.instance.client
          .from('stalls')
          .select()
          .eq('owner_id', widget.user.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final stalls = snapshot.data as List<dynamic>;

        if (stalls.isEmpty) {
          return const Center(
            child: Text("No stalls found. Create one first."),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: stalls.length,
          itemBuilder: (context, index) {
            final stall = stalls[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(stall['name']),
                subtitle: Text(stall['description'] ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.list_alt),
                      tooltip: "View Products",
                      onPressed: () => _showProducts(stall['id']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: "Add Product",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddProductView(stallId: stall['id']),
                          ),
                        ).then((value) {
                          if (value == true) setState(() {});
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 🔍 Show Products for a Stall
  void _showProducts(int stallId) async {
    final products = await ProductService.getProductsByStall(stallId);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Products"),
        content: products.isEmpty
            ? const Text("No products added yet.")
            : SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: products
                      .map(
                        (p) => ListTile(
                          title: Text(p.name),
                          subtitle: Text("\$${p.price}"),
                        ),
                      )
                      .toList(),
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  /// 👤 Account Section
  Widget _accountSection() {
    return const Center(
      child: Text(
        "👤 Account Section (Profile, Settings, Logout)",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}
