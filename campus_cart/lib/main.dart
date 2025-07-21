import 'package:flutter/material.dart';
//import 'views/home_view.dart'; // For guest home view
import 'views/student/student_home_view.dart'; // Uncomment to test student view

import 'db/data_seeder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Seed dummy data once
  final seeder = DataSeeder();
  await seeder.seedData();

  runApp(const CampusCartApp());
}

class CampusCartApp extends StatelessWidget {
  const CampusCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Cart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      //home: const HomeView(), // 👈 change this to StudentHomeView() to test student
      //home:const VendorDashboard(),
      home:
          const StudentHomeView(), // 👈 change this to StudentHomeView() to test student
    );
  }
}
