import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'views/home_view.dart';
import 'views/auth/login_register_view.dart';
import 'views/vendor/vendor_dashboard_view.dart';
import 'views/vendor/add_product_view.dart';
import 'views/vendor/vendor_products_view.dart';
import 'views/vendor/vendor_orders_view.dart';
import 'views/search_view.dart';
import 'views/student/student_wishlist_view.dart';
import 'views/student/cart_view.dart';
import 'views/student/student_account_view.dart';

import 'package:campus_cart/models/app_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Supabase
  await Supabase.initialize(
    url:
        "https://bkguuklqohtvhxeeuxkl.supabase.co", // replace with your project URL
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJrZ3V1a2xxb2h0dmh4ZWV1eGtsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM3NTYzNDUsImV4cCI6MjA2OTMzMjM0NX0.-FYwDX4cmDcpEmJ2ZkJQtZkhpwojA4SBIXH7LSP5vus", // replace with your anon key
  );

  runApp(const CampusCartApp());
}

class CampusCartApp extends StatelessWidget {
  const CampusCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusCart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/', // ✅ Starts on HomeView
      routes: {
        '/': (context) => const HomeView(),
        '/login': (context) => const LoginRegisterView(),
        '/vendor': (context) => VendorDashboardView(user: AppUser.guest),
        // '/vendor/add-product': (context) => const AddProductView(),
        //'/vendor/products': (context) => const VendorProductsView(),
        //'/vendor/orders': (context) => const VendorOrdersView(),
        '/search': (context) => SearchView(user: AppUser.guest),
        '/wishlist': (context) => WishlistView(user: AppUser.guest),
        '/cart': (context) => const CartView(user: AppUser.guest),
      },
    );
  }
}
