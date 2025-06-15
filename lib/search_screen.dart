import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseskape/api/property_api.dart';
import 'package:houseskape/model/property_model.dart';
import 'package:houseskape/notifiers/property_notifier.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:houseskape/widgets/property_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> items = ["Gangtok", "Majitar", "Rangpo", "Singtam"];
  String? selecteditem = "Gangtok";

  User? user = FirebaseAuth.instance.currentUser;

  Property property = Property();

  @override
  void initState() {
    PropertyNotifier propertyNotifier =
        Provider.of<PropertyNotifier>(context, listen: false);
    getAllProperties(propertyNotifier, selecteditem.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PropertyNotifier propertyNotifier = Provider.of<PropertyNotifier>(context);
    Future<void> refreshList() async {
      getAllProperties(propertyNotifier, selecteditem.toString());
    }

    return Scaffold(
      appBar: CustomAppBar(
        leading: Icons.arrow_back_ios_new_rounded,
        title: 'Search',
        widget: const SizedBox.shrink(),
        elevation: 0,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  labelText: ' Location ',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                value: selecteditem,
                items: items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (item) => setState(() {
                  selecteditem = item;
                  getAllProperties(propertyNotifier, selecteditem.toString());
                }),
              ),
            ),
            RefreshIndicator(
              onRefresh: refreshList,
              child: propertyNotifier.allPropertyList.isEmpty
                  ? const _PlaceholderView(
                      icon: Icons.search_off,
                      title: 'No results',
                      subtitle: 'Try another location')
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: propertyNotifier.allPropertyList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return PropertyCard(
                          property: propertyNotifier.allPropertyList[index],
                          onTap: () {
                            propertyNotifier.currentProperty =
                                propertyNotifier.allPropertyList[index];
                            Navigator.pushNamed(context, '/property-details');
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 80, color: Colors.grey),
        const SizedBox(height: 16),
        Text(title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }
}
