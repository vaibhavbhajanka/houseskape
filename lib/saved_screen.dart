import 'package:flutter/material.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({ Key? key }) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar:  CustomAppBar(
        widget: Icon(Icons.search),
        title: 'Saved',
      ),
      body: Center(
        child: Text('Saved'),
      ),
    );
  }
}