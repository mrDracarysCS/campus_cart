import 'package:flutter/material.dart';
import 'views/home_view.dart'; // For guest home view
// import 'views/student/student_home_view.dart'; // Uncomment to test student view

void main() {
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
      home: const HomeView(), // 👈 change this to StudentHomeView() to test student
    );
  }
}
