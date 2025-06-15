import 'package:flutter/material.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:houseskape/widgets/property_card.dart';
import 'package:houseskape/model/property_model.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text('Not logged in'));
    }

    return Scaffold(
      appBar: CustomAppBar(
        leading: null,
        widget: const SizedBox.shrink(),
        title: 'Saved',
        elevation: 0,
        onPressed: () {},
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('saved')
            .orderBy('savedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          final savedDocs = snapshot.data?.docs ?? [];
          if (savedDocs.isEmpty) {
            return const Center(child: Text('No saved properties'));
          }

          return ListView.separated(
            itemCount: savedDocs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final propertyId = savedDocs[index].id;
              return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('properties')
                    .doc(propertyId)
                    .get(),
                builder: (context, propertySnap) {
                  if (propertySnap.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (!propertySnap.hasData || !propertySnap.data!.exists) {
                    return const SizedBox.shrink();
                  }
                  final prop = Property.fromMap(propertySnap.data!.data()!,
                      id: propertySnap.data!.id);
                  return PropertyCard(
                    property: prop,
                    onTap: () {
                      Navigator.pushNamed(context, '/property-details',
                          arguments: prop);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
