import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create
  Future<void> addListing(Listing listing) async {
    await _db.collection('listings').add(listing.toMap());
  }

  // Update
  Future<void> updateListing(String id, Listing listing) {
    return _db.collection('listings').doc(id).update(listing.toMap());
  }

  // Delete
  Future<void> deleteListing(String id) async {
    await _db.collection('listings').doc(id).delete();
  }

  // Read all listings
  Stream<List<Listing>> getListings() {
    return _db.collection('listings')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Listing.fromMap(doc.data(), doc.id))
            .toList());
  }

  // ⭐ NEW: Get listings created by a specific user
  Stream<List<Listing>> getUserListings(String uid) {
    return _db
        .collection('listings')
        .where('createdBy', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Listing.fromMap(doc.data(), doc.id))
            .toList());
  }
}