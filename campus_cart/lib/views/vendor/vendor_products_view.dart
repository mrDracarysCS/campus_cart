import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:campus_cart/utils/constants.dart';
import 'package:campus_cart/models/app_user.dart';
import 'package:campus_cart/db/product_service.dart';
import 'add_product_view.dart';

class VendorProductsView extends StatefulWidget {
  final AppUser user;

  const VendorProductsView({super.key, required this.user});

  @override
  State<VendorProductsView> createState() => _VendorProductsViewState();
}

class _VendorProductsViewState extends State<VendorProductsView> {
  List<dynamic> stalls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStalls();
  }

  Future<void> _fetchStalls() async {
    setState(() => isLoading = true);

    final res = await Supabase.instance.client
        .from('stalls')
        .select()
        .eq('owner_id', widget.user.id);

    setState(() {
      stalls = List.from(res);
      isLoading = false;
    });
  }

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
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return ListTile(
                      title: Text(p.name),
                      subtitle: Text(
                        "\$${p.price.toStringAsFixed(2)} | Stock: ${p.stock}",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final success = await ProductService.deleteProduct(
                            p.id,
                          );
                          if (success) {
                            Navigator.pop(context);
                            _showProducts(stallId); // Refresh
                          }
                        },
                      ),
                    );
                  },
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (stalls.isEmpty) {
      return const Center(child: Text("No stalls found. Create one first."));
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
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddProductView(stallId: stall['id']),
                      ),
                    );
                    if (result == true) setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
