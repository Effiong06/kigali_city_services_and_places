import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/listing_model.dart';

class LocationCard extends StatelessWidget {
  final Listing item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const LocationCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Requirement 2: Check if the current user is the creator
    final bool isOwner = item.userId == FirebaseAuth.instance.currentUser?.uid;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF00A86B), // Kigali Green
          child: const Icon(Icons.location_city, color: Colors.white, size: 20),
        ),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${item.category}\n${item.address}"),
        isThreeLine: true,
        trailing: isOwner 
            ? IconButton(
                icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                onPressed: onDelete,
              )
            : const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }
}