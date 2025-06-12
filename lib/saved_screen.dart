import 'package:flutter/material.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({ super.key });

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
        widget: const Icon(Icons.search),
        title: 'Saved',
        onPressed: (){},
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: Text('Saved'),
        ),
      ),
    );
  }
}