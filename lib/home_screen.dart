import 'package:flutter/material.dart';
import 'package:houseskape/home_icons.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar:  CustomAppBar(
        leading: HomeIcons.menu,
        // actions: Icons.search,
        widget: Icon(Icons.search),
        elevation: 0,
        // onPressed: (){},
      ),
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}