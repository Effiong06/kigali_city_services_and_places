import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/listing_model.dart';
import '../services/firestore_service.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descController = TextEditingController();
  
  String _selectedCategory = 'Government';
  final List<String> _categories = ['Government', 'Health', 'Education', 'Tourism', 'Transport'];
  final Color kigaliGreen = const Color(0xFF00A86B);

  void _saveListing() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_nameController.text.isEmpty || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in Name and Address")),
      );
      return;
    }

    final newListing = Listing(
      id: '', 
      userId: user.uid,
      name: _nameController.text,
      category: _selectedCategory,
      address: _addressController.text,
      phone: _phoneController.text,
      description: _descController.text,
      lat: -1.9441, 
      lng: 30.0619, 
      createdBy: user.uid,
    );

    try {
      await FirestoreService().addListing(newListing);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Kigali Service", style: TextStyle(color: Colors.white)),
        backgroundColor: kigaliGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTextField(_nameController, "Service Name (e.g., Kigali Heights)", Icons.business),
            const SizedBox(height: 15),
            DropdownButtonFormField(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: "Category",
                prefixIcon: Icon(Icons.category, color: kigaliGreen),
                border: const OutlineInputBorder(),
              ),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val as String),
            ),
            const SizedBox(height: 15),
            _buildTextField(_addressController, "Address (e.g., KN 2 St, Kigali)", Icons.map),
            const SizedBox(height: 15),
            _buildTextField(_phoneController, "Phone Number", Icons.phone, inputType: TextInputType.phone),
            const SizedBox(height: 15),
            _buildTextField(_descController, "Description", Icons.description, maxLines: 3),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveListing,
                style: ElevatedButton.styleFrom(backgroundColor: kigaliGreen),
                child: const Text("Save to Directory", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1, TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kigaliGreen),
        border: const OutlineInputBorder(),
      ),
    );
  }
}