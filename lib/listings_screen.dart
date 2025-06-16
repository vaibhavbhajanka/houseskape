import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseskape/api/property_api.dart';
import 'package:houseskape/model/property_model.dart';
import 'package:houseskape/notifiers/property_notifier.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houseskape/step1_screen.dart';
import 'package:houseskape/widgets/property_card.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  Property property = Property();

  @override
  void initState() {
    PropertyNotifier propertyNotifier =
        Provider.of<PropertyNotifier>(context, listen: false);
    getProperties(propertyNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PropertyNotifier propertyNotifier = Provider.of<PropertyNotifier>(context);
    Future<void> refreshList() async {
      getProperties(propertyNotifier);
    }

    return Scaffold(
      appBar: CustomAppBar(
        leading: Icons.arrow_back_ios_new_rounded,
        title: 'Listings',
        widget: const SizedBox.shrink(),
        elevation: 0,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: ListView.separated(
          itemCount: propertyNotifier.propertyList.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            final property = propertyNotifier.propertyList[index];
            return Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    propertyNotifier.currentProperty = property;
                    Navigator.pushNamed(context, '/property-details');
                  },
                  child: SizedBox(
                    height: 160,
                    child: PropertyCard(
                      property: property,
                      onTap: () {
                        propertyNotifier.currentProperty = property;
                        Navigator.pushNamed(context, '/property-details');
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 48,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Step1Screen(property: property),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete Listing'),
                          content: Text(
                              'Are you sure you want to delete this property?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel',
                                  style: TextStyle(color: Color(0xff25262b))),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && property.id != null) {
                        await FirebaseFirestore.instance
                            .collection('properties')
                            .doc(property.id)
                            .delete();
                        refreshList();
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
