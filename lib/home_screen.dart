// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:houseskape/home_icons.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:houseskape/api/property_api.dart';
import 'package:houseskape/notifiers/property_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houseskape/model/property_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leading: HomeIcons.menu,
        // actions: InkWell(child: Icon(Icons.search)),
        widget: Icon(Icons.search),
        elevation: 0,
        onPressed: (){
          Navigator.pushNamed(context, '/search');
        },
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('properties').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No properties found.'));
          }
          final properties = snapshot.data!.docs
              .map((doc) => Property.fromMap(doc.data()))
              .toList();
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return Card(
                color: Color(0xfffcf9f4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 20),
                child: ListTile(
                  leading: property.image != null && property.image!.startsWith('http')
                      ? Image.network(property.image!, width: 80, height: 80, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported))
                      : Image.asset('assets/images/house1.png', width: 80, height: 80, fit: BoxFit.cover),
                  title: Text(property.adTitle ?? 'No Title', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 16, color: Color(0xff949494)),
                          SizedBox(width: 4),
                          Expanded(child: Text(property.location ?? '', style: TextStyle(fontSize: 14, color: Color(0xff949494)), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.currency_rupee, size: 16),
                          Text('${property.monthlyRent?.toString() ?? '-'} / month', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    // If you want to keep using the notifier for details, you can do so here:
                    // final notifier = Provider.of<PropertyNotifier>(context, listen: false);
                    // notifier.currentProperty = property;
                    Navigator.pushNamed(context, '/property-details', arguments: property);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
