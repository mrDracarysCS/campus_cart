import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'views/home_view.dart';
import 'views/auth/login_register_view.dart';
import 'views/student/student_home_view.dart';
import 'views/vendor/vendor_dashboard_view.dart';
import 'views/vendor/add_product_view.dart';
import 'views/vendor/vendor_products_view.dart';
import 'views/vendor/vendor_orders_view.dart';
//import 'views/student/search_view.dart';
import 'views/student/wishlist_view.dart';
import 'views/student/cart_view.dart';
import 'views/student/student_account_view.dart';
import 'views/backend_test_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://rxfxrjurvhyhtpienete.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ4ZnhyanVydmh5aHRwaWVuZXRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM2NTYwMTksImV4cCI6MjA2OTIzMjAxOX0.yy4sJJG6xwQPzQj0KCplG3ZmRvtv8jJ4MMIGCRFFogE",
  );

  runApp(const LauncherApp());
}

class LauncherApp extends StatelessWidget {
  const LauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CampusCart Launcher",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ModeSelector(),
    );
  }
}

class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Mode")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const CampusCartApp()),
                );
              },
              child: const Text("Run Normal App"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const BackendTestView()),
                );
              },
              child: const Text("Run Backend Tester"),
            ),
          ],
        ),
      ),
    );
  }
}

class CampusCartApp extends StatelessWidget {
  const CampusCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusCart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        '/login': (context) => const LoginRegisterView(),
        '/student': (context) => const StudentHomeView(),
        '/vendor': (context) => const VendorDashboardView(),
        '/vendor/add-product': (context) => const AddProductView(),
        '/vendor/products': (context) => const VendorProductsView(),
        '/vendor/orders': (context) => const VendorOrdersView(),
        //       '/search': (context) => const SearchView(),
        '/wishlist': (context) => const WishlistView(),
        '/cart': (context) => const CartView(),
        // '/studentAccount': (context) => StudentAccountView(user: currentUser),
      },
    );
  }
}
