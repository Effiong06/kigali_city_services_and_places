import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';    
import 'package:url_launcher/url_launcher.dart';
import '../models/listing_model.dart';
import 'edit_listing_screen.dart';
import 'package:latlong2/latlong.dart';

class DetailsScreen extends StatelessWidget {
  final Listing listing;
  const DetailsScreen({super.key, required this.listing});

  Future<void> _launchMaps() async {
    final String url = "https://www.google.com/maps/search/?api=1&query=${listing.lat},${listing.lng}";
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color kigaliGreen = Color(0xFF00A86B);

    return Scaffold(
      appBar: AppBar(
        title: Text(listing.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditListingScreen(listing: listing)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(listing.lat, listing.lng), // 🟢 No 'const'
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.kigaliapp',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(listing.lat, listing.lng),
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        listing.category,
                        style: const TextStyle(fontSize: 18, color: kigaliGreen, fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.verified, color: Colors.blue, size: 20),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(listing.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const Divider(height: 40),
                  
                  _buildInfoTile(Icons.phone, "Phone", listing.phone),
                  _buildInfoTile(Icons.location_on, "Address", listing.address),
                  _buildInfoTile(Icons.person_pin, "Added By", listing.createdBy),
                  
                  const SizedBox(height: 30),
                  
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kigaliGreen,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _launchMaps,
                    icon: const Icon(Icons.directions),
                    label: const Text("Launch Navigation", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}