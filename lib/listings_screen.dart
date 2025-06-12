import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseskape/api/property_api.dart';
import 'package:houseskape/model/property_model.dart';
import 'package:houseskape/notifiers/property_notifier.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houseskape/step1_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({Key? key}) : super(key: key);

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  // final auth = FirebaseAuth.instance;
  // final googleSignIn = GoogleSignIn();

  User? user = FirebaseAuth.instance.currentUser;

  Property property = Property();

  @override
  void initState() {
    PropertyNotifier propertyNotifier =
        Provider.of<PropertyNotifier>(context, listen: false);
    getProperties(propertyNotifier);
    // print(propertyNotifier.propertyList[0].adTitle);
    super.initState();
    // FirebaseFirestore.instance
    //     .collection('listings')
    //     .doc(user!.uid)
    //     .get()
    //     .then((value) {
    //   property = Property.fromMap(value.data());
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    PropertyNotifier propertyNotifier = Provider.of<PropertyNotifier>(context);
    Future<void> _refreshList() async {
      getProperties(propertyNotifier);
    }

    return Scaffold(
      appBar: CustomAppBar(
        leading: Icons.close,
        title: 'Listings',
        widget: const Icon(
          Icons.abc,
          color: Color(0xfffcf9f4),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
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
                  onTap: (){
                    propertyNotifier.currentProperty = property;
                    Navigator.pushNamed(context, '/property-details');
                  },
                  child: SizedBox(
                    height: 160,
                    child: Card(
                      color: const Color(0xfffcf9f4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 5,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: property.image != null
                                      ? property.image.toString()
                                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                                  height: 100,
                                  width: 140,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => const Icon(Icons.image_not_supported, size: 60),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(property.adTitle.toString(),
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                      property.location.toString().toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.black)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(children: [
                                    const Icon(Icons.location_on_outlined,
                                        color: Color(0xff949494), size: 20),
                                    Expanded(
                                      child: Text(property.address.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff949494))),
                                    ),
                                  ]),
                                ),
                                const SizedBox(height: 10),
                                Wrap(children: [
                                  const Icon(Icons.currency_rupee),
                                  Text(
                                      "${property.monthlyRent?.toInt()}/month",
                                      style: const TextStyle(fontSize: 17))
                                ])
                              ],
                            ),
                          )
                        ],
                      ),
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
                          content: Text('Are you sure you want to delete this property?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && property.id != null) {
                        await FirebaseFirestore.instance.collection('properties').doc(property.id).delete();
                        _refreshList();
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
