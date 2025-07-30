import 'package:flutter/material.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/widgets/top_web_nav_bar.dart';
import 'package:campus_cart/widgets/footer.dart';
import 'package:campus_cart/models/app_user.dart';
import 'package:campus_cart/db/stalls_service.dart';
import 'package:campus_cart/views/vendor/add_stall_view.dart';

class VendorDashboardView extends StatefulWidget {
  final AppUser user;

  const VendorDashboardView({super.key, required this.user});

  @override
  State<VendorDashboardView> createState() => _VendorDashboardViewState();
}

class _VendorDashboardViewState extends State<VendorDashboardView> {
  int _selectedIndex = 0;
  final List<String> _menuItems = ["Orders", "Inventory", "Account"];
  List<dynamic> _stalls = [];

  @override
  void initState() {
    super.initState();
    _fetchStalls();
  }

  Future<void> _fetchStalls() async {
    final stalls = await StallService.fetchVendorStalls(widget.user.id);
    setState(() => _stalls = stalls);
  }

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

  Widget _ordersSection() {
    return const Center(
      child: Text(
        "📦 Orders Section (Upcoming Orders, Order Status, etc.)",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _inventorySection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddStallView(user: widget.user),
                ),
              );
              if (result == true) {
                _fetchStalls(); // Refresh stalls after creation
              }
            },
            icon: const Icon(Icons.add_business),
            label: const Text("Create New Stall"),
            style: ElevatedButton.styleFrom(
              backgroundColor: kAccentLightColor,
              foregroundColor: kPrimaryDarkColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            "Your Stalls",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: _stalls.isEmpty
                ? const Center(
                    child: Text(
                      "No stalls yet. Create your first stall!",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    itemCount: _stalls.length,
                    itemBuilder: (context, index) {
                      final stall = _stalls[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: stall['image_url'] != null
                              ? Image.network(
                                  stall['image_url'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.store),
                          title: Text(stall['name']),
                          subtitle: Text(stall['description'] ?? ''),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _accountSection() {
    return const Center(
      child: Text(
        "👤 Account Section (Profile, Settings, Logout)",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}
