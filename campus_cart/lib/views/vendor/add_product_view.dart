import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../db/product_service.dart';

class AddProductView extends StatefulWidget {
  final int stallId;

  const AddProductView({super.key, required this.stallId});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageController = TextEditingController();

  bool _shippable = false;
  bool _loading = false;

  Future<void> _submit() async {
    setState(() => _loading = true);

    final success = await ProductService.addProduct(
      stallId: widget.stallId,
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      stock: int.tryParse(_stockController.text.trim()) ?? 0,
      shippable: _shippable,
      imageUrl: _imageController.text.trim().isEmpty
          ? null
          : _imageController.text.trim(),
    );

    setState(() => _loading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Product added successfully")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Failed to add product")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: kPrimaryDarkColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _inputField(_nameController, "Product Name"),
            const SizedBox(height: 12),
            _inputField(_descController, "Description"),
            const SizedBox(height: 12),
            _inputField(
              _priceController,
              "Price",
              keyboard: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _inputField(
              _stockController,
              "Stock",
              keyboard: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _inputField(_imageController, "Image URL (Optional)"),
            const SizedBox(height: 12),

            // ✅ Shippable Toggle
            Row(
              children: [
                Checkbox(
                  value: _shippable,
                  onChanged: (v) => setState(() => _shippable = v ?? false),
                ),
                const Text("Shippable Product"),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentLightColor,
                foregroundColor: kPrimaryDarkColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
              ),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Add Product"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    TextEditingController c,
    String hint, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: c,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
