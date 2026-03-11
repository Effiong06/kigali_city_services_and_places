import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter_map/flutter_map.dart'; 
import 'package:url_launcher/url_launcher.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../services/firestore_service.dart';
import '../models/listing_model.dart';
import '../widgets/location_card.dart';
import 'add_listing_screen.dart';
import 'details_screen.dart';
import 'package:latlong2/latlong.dart';
import 'my_listings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _searchQuery = "";
  String _selectedCategory = "All";
  
  final Color kigaliGreen = const Color(0xFF00A86B);
  final List<String> _categories = ['All', 'Government','Health', 'Education', 'Tourism', 'Transport'];

  Future<void> _launchNavigation(double lat, double lng) async {
    final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not launch maps")));
    }
  }

  Widget _buildBrowsePage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search Kigali services...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: _categories.map((cat) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(cat),
                selected: _selectedCategory == cat,
                onSelected: (s) => setState(() => _selectedCategory = cat),
              ),
            )).toList(),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Listing>>(
            stream: FirestoreService().getListings(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              
              var list = snapshot.data!.where((item) {
                final matchQuery = item.name.toLowerCase().contains(_searchQuery);
                final matchCat = _selectedCategory == "All" || item.category == _selectedCategory;
                return matchQuery && matchCat;
              }).toList();

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) => LocationCard(
                  item: list[index],
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(listing: list[index]))),
                  onDelete: () => _confirmDelete(list[index].id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMapPage() {
    return StreamBuilder<List<Listing>>(
      stream: FirestoreService().getListings(),
      builder: (context, snapshot) {
        final listings = snapshot.data ?? [];
        
        final markers = listings.map((l) => Marker(
          point: LatLng(l.lat, l.lng),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => _showMapPopup(l),
            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
          ),
        )).toList();

        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(-1.9441, 30.0619), 
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.kigaliapp',
            ),
            MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }

  void _showMapPopup(Listing l) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 180,
        child: Column(
          children: [
            Text(l.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(l.category, style: TextStyle(color: kigaliGreen)),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.directions),
              label: const Text("Navigate to Location"),
              onPressed: () => _launchNavigation(l.lat, l.lng),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 20),
          Text(FirebaseAuth.instance.currentUser?.email ?? "User", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(height: 40),
          SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            value: themeProvider.isDarkMode,
            onChanged: (v) => themeProvider.toggleTheme(),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(50)),
            onPressed: () => Provider.of<AuthProvider>(context, listen: false).signOut(),
            child: const Text("Sign Out"),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Delete?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text("No")),
          TextButton(onPressed: () { FirestoreService().deleteListing(id); Navigator.pop(c); }, child: const Text("Yes")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildBrowsePage(),
      const MyListingsScreen(), // ⭐ NEW
      _buildMapPage(),
      _buildProfilePage(),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("Kigali City Connect"), centerTitle: true),
      body: pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
        backgroundColor: kigaliGreen,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const AddListingScreen())),
        child: const Icon(Icons.add),
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),

        selectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,

        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black54,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Directory"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "My Listings"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}