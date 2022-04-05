import 'package:flutter/material.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        actions: Icons.search,
        leading: Icons.arrow_back_ios_new_rounded,
        title: 'Message',
        // elevation: ,
      ),
      body: Center(
        child: Text('Chat'),
      ),
    );
  }
}
