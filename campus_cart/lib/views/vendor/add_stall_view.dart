import 'package:flutter/material.dart';
import 'package:campus_cart/models/app_user.dart';
import 'package:campus_cart/db/stalls_service.dart';
import 'package:campus_cart/utils/constants.dart';

class AddStallView extends StatefulWidget {
  final AppUser user;

  const AddStallView({super.key, required this.user});

  @override
  State<AddStallView> createState() => _AddStallViewState();
}

class _AddStallViewState extends State<AddStallView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;

  Future<void> _createStall() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Stall name is required!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await StallService.createStall(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      ownerId: widget.user.id,
    );

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pop(context, true); // ✅ Go back and refresh list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to create stall. Try again!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text("Create New Stall"),
        backgroundColor: kPrimaryDarkColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Stall Name",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Description (optional)",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _createStall,
              icon: const Icon(Icons.add_business),
              label: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Create Stall"),
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentLightColor,
                foregroundColor: kPrimaryDarkColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
