import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/listing_provider.dart';
import '../widgets/location_card.dart';
import 'details_screen.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: Provider.of<ListingProvider>(context).getMyListings(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final listings = snapshot.data!;

        if (listings.isEmpty) {
          return const Center(child: Text("You haven't added any listings yet."));
        }

        return ListView.builder(
          itemCount: listings.length,
          itemBuilder: (context, index) {
            final item = listings[index];

            return LocationCard(
              item: item,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailsScreen(listing: item),
                ),
              ),
              onDelete: () => Provider.of<ListingProvider>(context, listen: false)
                  .deleteListing(item.id),
            );
          },
        );
      },
    );
  }
}