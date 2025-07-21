import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_cart/utils/constants.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';
  double price = 0.0;
  int stock = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: Text(
          'Add New Product',
          style: GoogleFonts.patuaOne(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Product Name'),
                onChanged: (value) => name = value,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                validator: (value) => value == null || double.tryParse(value) == null ? 'Enter a valid price' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Stock Quantity'),
                keyboardType: TextInputType.number,
                onChanged: (value) => stock = int.tryParse(value) ?? 0,
                validator: (value) => value == null || int.tryParse(value) == null ? 'Enter a valid quantity' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Save product to DB
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product added successfully!')),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentLightColor,
                  foregroundColor: kPrimaryDarkColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
