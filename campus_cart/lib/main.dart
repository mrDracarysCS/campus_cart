import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'views/home_view.dart';
import 'views/auth/login_register_view.dart';
import 'views/student/student_home_view.dart';
import 'views/vendor/vendor_dashboard_view.dart';
import 'views/vendor/add_product_view.dart';
import 'views/vendor/vendor_products_view.dart';
import 'views/vendor/vendor_orders_view.dart';
import 'views/search_view.dart';
import 'views/student/wishlist_view.dart';
import 'views/student/cart_view.dart';
import 'views/student/student_account_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Supabase
  await Supabase.initialize(
    url:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ4ZnhyanVydmh5aHRwaWVuZXRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM2NTYwMTksImV4cCI6MjA2OTIzMjAxOX0.yy4sJJG6xwQPzQj0KCplG3ZmRvtv8jJ4MMIGCRFFogE", // replace with your project URL
    anonKey: "YOUR_ANON_KEY", // replace with your anon key
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
        '/student': (context) => const StudentHomeView(),
        '/vendor': (context) => const VendorDashboardView(),
        '/vendor/add-product': (context) => const AddProductView(),
        '/vendor/products': (context) => const VendorProductsView(),
        '/vendor/orders': (context) => const VendorOrdersView(),
        '/search': (context) => const SearchView(),
        '/wishlist': (context) => const WishlistView(),
        '/cart': (context) => const CartView(),
        // '/studentAccount': (context) => StudentAccountView(user: currentUser),
      },
    );
  }
}
