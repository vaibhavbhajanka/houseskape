// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:houseskape/home_icons.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houseskape/model/property_model.dart';
import 'package:houseskape/widgets/property_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: HomeIcons.menu,
        widget: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/map');
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.search,
                  color: Color(0xff25262b),
                ),
              ),
            ),
          ],
        ),
        elevation: 0,
        title: '',
        onPressed: () {},
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('properties').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const _PlaceholderView(
                icon: Icons.error_outline,
                title: 'Oops',
                subtitle: 'Something went wrong');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const _PlaceholderView(
                icon: Icons.home_outlined,
                title: 'Nothing here',
                subtitle: 'No properties found');
          }

          final properties = snapshot.data!.docs
              .map((doc) => Property.fromMap(doc.data(), id: doc.id))
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: properties.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // Header – two-line hero text.
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Find your',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF25262B),
                            )),
                    const SizedBox(height: 4),
                    Text('best property',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF25262B),
                            )),
                    const SizedBox(height: 16),
                  ],
                );
              }

              final property = properties[index - 1];
              return PropertyCard(
                property: property,
                onTap: () {
                  Navigator.pushNamed(context, '/property-details', arguments: property);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _PlaceholderView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PlaceholderView({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
