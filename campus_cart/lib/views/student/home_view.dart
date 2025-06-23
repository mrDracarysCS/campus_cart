// lib/views/student/home_view.dart

import 'package:flutter/material.dart';

class StudentHomeView extends StatelessWidget {
  const StudentHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data
    final List<Map<String, String>> stalls = [
      {'name': 'Pizza Planet', 'status': 'Open', 'category': 'Italian'},
      {'name': 'Sushi Roll', 'status': 'Closed', 'category': 'Japanese'},
      {'name': 'Taco Time', 'status': 'Open', 'category': 'Mexican'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Stalls'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: stalls.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final stall = stalls[index];
            return Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Placeholder(), // TODO: Stall logo/image
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stall['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(stall['category']!),
                    Text(
                      stall['status']!,
                      style: TextStyle(
                        color: stall['status'] == 'Open'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to Menu Page
                        },
                        child: const Text('View Menu'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
