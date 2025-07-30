import 'package:flutter/material.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/widgets/top_web_nav_bar.dart';
import 'package:campus_cart/widgets/footer.dart';
import 'package:campus_cart/models/app_user.dart';

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

  Widget _buildSideMenu() {
    return Container(
      width: 220,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Vendor Dashboard",
            style: const TextStyle(
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
                  fontWeight:
                      _selectedIndex == i ? FontWeight.bold : FontWeight.normal,
                  color:
                      _selectedIndex == i ? kAccentLightColor : Colors.black87,
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
    return Center(
      child: Text(
        "📦 Orders Section (Upcoming Orders, Order Status, etc.)",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _inventorySection() {
    return Center(
      child: Text(
        "📦 Inventory Section (Manage Products, Stock Levels, etc.)",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _accountSection() {
    return Center(
      child: Text(
        "👤 Account Section (Profile, Settings, Logout)",
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}
