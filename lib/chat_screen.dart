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
    return Scaffold(
      appBar: const CustomAppBar(
        widget: Icon(Icons.search),
        leading: Icons.arrow_back_ios_new_rounded,
        title: 'Message',
        // elevation: ,
        // onPressed: (){
          
        // },
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                "assets/images/person1.png",
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Anna Shvets',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
                  Text('16 mins ago'),
                ],
              ),
            ),
            subtitle: Row(
              children: const [
                Icon(Icons.done_all_rounded),
                Text('We can meet at 2 PM Monday!',
                style: TextStyle(
                  fontSize: 15,
                ),),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                "assets/images/person2.png",
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Spencer Selover',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
                  Text('34 mins ago'),
                ],
              ),
            ),
            subtitle: Row(
              children: const [
                Icon(Icons.done_all_rounded),
                Text('I want to book the house',
                style: TextStyle(
                  fontSize: 15,
                ),),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                "assets/images/person3.png",
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Yogender Singh',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
                  Text('1 hour ago'),
                ],
              ),
            ),
            subtitle: Row(
              children: const [
                Icon(Icons.done_all_rounded),
                Text("Nice house, but I can't afford",
                style: TextStyle(
                  fontSize: 15,
                ),),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                "assets/images/person4.png",
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Anastasia Ganin',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
                  Text('4 hours ago'),
                ],
              ),
            ),
            subtitle: Row(
              children: const [
                Icon(Icons.done_all_rounded),
                Text('We can meet at 5 PM Tuesday!',
                style: TextStyle(
                  fontSize: 15,
                ),),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                "assets/images/person5.png",
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Harsh Vardhan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
                  Text('17 hours ago'),
                ],
              ),
            ),
            subtitle: Row(
              children: const [
                Icon(Icons.done_all_rounded),
                Text('Are you free sometime in the...',
                style: TextStyle(
                  fontSize: 15,
                ),),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              child: Image.asset(
                "assets/images/person1.png",
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical:8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Sinita Leunen',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
                  Text('Yesterday'),
                ],
              ),
            ),
            subtitle: Row(
              children: const [
                Icon(Icons.done_all_rounded),
                Text('We can meet at 2 PM Monday!',
                style: TextStyle(
                  fontSize: 15,
                ),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
