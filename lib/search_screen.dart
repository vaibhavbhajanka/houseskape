// import 'package:firebase_auth/firebase_auth.dart'; // Not used after refactor
// import 'package:provider/provider.dart'; // Not used after refactor
// import 'package:houseskape/notifiers/property_notifier.dart';
import 'package:flutter/material.dart';
import 'package:houseskape/model/property_model.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'package:houseskape/widgets/property_card.dart';
import 'package:houseskape/model/search_query.dart';
import 'package:houseskape/repository/property_search_repository.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> _locations = ["Gangtok", "Majitar", "Rangpo", "Singtam"];
  String _selectedLocation = "Gangtok";
  final _searchRepo = PropertySearchRepository();

  @override
  Widget build(BuildContext context) {
    final query = SearchQuery(location: _selectedLocation);

    return Scaffold(
      appBar: CustomAppBar(
        leading: Icons.arrow_back_ios_new_rounded,
        title: 'Discover',
        widget: const SizedBox.shrink(),
        elevation: 0,
        onPressed: () => Navigator.pop(context),
      ),
      body: Column(
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
              value: _selectedLocation,
              items: _locations
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: (item) {
                if (item == null) return;
                setState(() => _selectedLocation = item);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Property>>(
              stream: _searchRepo.watchProperties(query),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final properties = snapshot.data ?? [];

                if (properties.isEmpty) {
                  return const _PlaceholderView(
                    icon: Icons.search_off,
                    title: 'No results',
                    subtitle: 'Try another location',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: properties.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    return PropertyCard(
                      property: property,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/property-details',
                          arguments: property,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
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
