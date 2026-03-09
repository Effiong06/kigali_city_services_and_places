import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String id;
  final String userId;
  final String name;
  final String category;
  final String address;
  final String phone;
  final String description;
  final double lat;
  final double lng;
  final String createdBy;

  Listing({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.address,
    required this.phone,
    required this.description,
    required this.lat,
    required this.lng,
    required this.createdBy,
  });

  factory Listing.fromMap(Map<String, dynamic> data, String id) {
    return Listing(
      id: id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      description: data['description'] ?? '',
      lat: (data['lat'] as num? ?? 0.0).toDouble(),
      lng: (data['lng'] as num? ?? 0.0).toDouble(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'category': category,
      'address': address,
      'phone': phone,
      'description': description,
      'lat': lat,
      'lng': lng,
      'createdBy': createdBy,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}