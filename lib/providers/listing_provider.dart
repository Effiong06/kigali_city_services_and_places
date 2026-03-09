import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../services/firestore_service.dart';

class ListingProvider with ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  Stream<List<Listing>> getAllListings() {
    return _service.getListings();
  }

  Stream<List<Listing>> getMyListings(String uid) {
    return _service.getUserListings(uid);
  }

  Future<void> deleteListing(String id) async {
    await _service.deleteListing(id);
  }
}