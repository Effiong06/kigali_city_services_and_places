import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../services/firestore_service.dart';

class EditListingScreen extends StatefulWidget {
  final Listing listing;
  const EditListingScreen({super.key, required this.listing});

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  String? _selectedCategory;

  final List<String> _categories = ['Hospital', 'Police Station', 'Library', 'Restaurant', 'Café', 'Park', 'Tourist Attraction'];

  @override
  void initState() {
    super.initState();
    // Pre-fill the controllers with existing data
    _nameController = TextEditingController(text: widget.listing.name);
    _descController = TextEditingController(text: widget.listing.description);
    _addressController = TextEditingController(text: widget.listing.address);
    _phoneController = TextEditingController(text: widget.listing.phone);
    _selectedCategory = widget.listing.category;
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedListing = Listing(
        id: widget.listing.id,
        userId: widget.listing.userId,
        name: _nameController.text,
        description: _descController.text,
        category: _selectedCategory!,
        address: _addressController.text,
        phone: _phoneController.text,
        lat: widget.listing.lat, 
        lng: widget.listing.lng,
        createdBy: widget.listing.createdBy, // 🟢 Add this line to satisfy the model
      );

      // 🟢 Pass both the ID and the listing object to the service
      await FirestoreService().updateListing(widget.listing.id, updatedListing);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Listing updated successfully!")),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Listing")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Place Name"),
                validator: (v) => v!.isEmpty ? "Enter a name" : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                decoration: const InputDecoration(labelText: "Category"),
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Contact Phone"),
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Physical Address"),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A86B),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _saveChanges,
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}