import 'package:flutter/material.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({ Key? key }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        actions: Icons.more_vert,
        title: 'Account',
        elevation: 0,
      ),
      body: Center(
        child: Text('Profile'),
      ),
    );
  }
}