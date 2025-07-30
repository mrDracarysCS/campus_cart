import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:campus_cart/utils/constants.dart';

class VendorOrdersView extends StatefulWidget {
  final String vendorId;

  const VendorOrdersView({super.key, required this.vendorId});

  @override
  State<VendorOrdersView> createState() => _VendorOrdersViewState();
}

class _VendorOrdersViewState extends State<VendorOrdersView> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => isLoading = true);

    // ✅ Get stalls owned by vendor
    final stalls = await Supabase.instance.client
        .from('stalls')
        .select('id')
        .eq('owner_id', widget.vendorId);

    final stallIds = stalls.map((s) => s['id']).toList();

    if (stallIds.isEmpty) {
      setState(() {
        orders = [];
        isLoading = false;
      });
      return;
    }

    // ✅ Get orders for these stalls
    final res = await Supabase.instance.client
        .from('orders')
        .select('id, status, created_at, user_id, stalls(name)')
        .inFilter('stall_id', stallIds)
        .order('created_at', ascending: false);

    setState(() {
      orders = List<Map<String, dynamic>>.from(res);
      isLoading = false;
    });
  }

  Future<void> _markCompleted(int orderId) async {
    await Supabase.instance.client
        .from('orders')
        .update({'status': 'completed'})
        .eq('id', orderId);

    _fetchOrders(); // Refresh list
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (orders.isEmpty) {
      return const Center(child: Text("No orders found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          child: ListTile(
            title: Text("Order #${order['id']} - ${order['stalls']['name']}"),
            subtitle: Text(
              "Status: ${order['status']} • ${order['created_at'].toString().substring(0, 16)}",
            ),
            trailing: order['status'] == 'pending'
                ? ElevatedButton(
                    onPressed: () => _markCompleted(order['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text("Mark Completed"),
                  )
                : const Icon(Icons.check_circle, color: Colors.green),
          ),
        );
      },
    );
  }
}
