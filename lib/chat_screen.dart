import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseskape/api/property_api.dart';
import 'package:houseskape/chat.dart';
import 'package:houseskape/chat_search.dart';
import 'package:houseskape/model/user_model.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? chatRooms;

  User? user = FirebaseAuth.instance.currentUser;

  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
    });
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data?.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return ChatRoomsTile(
                    userName: data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(loggedInUser.name.toString(), ""),
                    chatRoomId: data["chatRoomId"],
                  );
                })
            : Container();
      },
    );
  }

  getUserInfogetChats() async {
    await getUserChats(loggedInUser.name.toString()).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${loggedInUser.name.toString()}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        widget: const Icon(
          Icons.search,
          color: Color(0xfffcf9f4),
        ),
        leading: Icons.search,
        title: 'Message',
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ChatSearch()));
        },

        // elevation: ,
        // onPressed: (){

        // },
      ),
      body: Container(
        child: chatRoomsList(),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  const ChatRoomsTile(
      {Key? key, required this.userName, required this.chatRoomId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  // color: colorAccent,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         widget: const Icon(Icons.search,color: Color(0xfffcf9f4),),
//         leading: Icons.search,
//         title: 'Message',
//         onPressed: (){
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => const ChatSearch()));
//         },

//         // elevation: ,
//         // onPressed: (){
          
//         // },
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             leading: CircleAvatar(
//               radius: 25,
//               backgroundColor: Colors.transparent,
//               child: Image.asset(
//                 "assets/images/person1.png",
//               ),
//             ),
//             title: Padding(
//               padding: const EdgeInsets.symmetric(vertical:8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text('Anna Shvets',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),),
//                   Text('16 mins ago'),
//                 ],
//               ),
//             ),
//             subtitle: Row(
//               children: const [
//                 Icon(Icons.done_all_rounded),
//                 Text('We can meet at 2 PM Monday!',
//                 style: TextStyle(
//                   fontSize: 15,
//                 ),),
//               ],
//             ),
//           ),
//           const Divider(),
//           ListTile(
//             leading: CircleAvatar(
//               radius: 25,
//               backgroundColor: Colors.transparent,
//               child: Image.asset(
//                 "assets/images/person2.png",
//               ),
//             ),
//             title: Padding(
//               padding: const EdgeInsets.symmetric(vertical:8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text('Spencer Selover',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),),
//                   Text('34 mins ago'),
//                 ],
//               ),
//             ),
//             subtitle: Row(
//               children: const [
//                 Icon(Icons.done_all_rounded),
//                 Text('I want to book the house',
//                 style: TextStyle(
//                   fontSize: 15,
//                 ),),
//               ],
//             ),
//           ),
//           const Divider(),
//           ListTile(
//             leading: CircleAvatar(
//               radius: 25,
//               backgroundColor: Colors.transparent,
//               child: Image.asset(
//                 "assets/images/person3.png",
//               ),
//             ),
//             title: Padding(
//               padding: const EdgeInsets.symmetric(vertical:8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text('Yogender Singh',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),),
//                   Text('1 hour ago'),
//                 ],
//               ),
//             ),
//             subtitle: Row(
//               children: const [
//                 Icon(Icons.done_all_rounded),
//                 Text("Nice house, but I can't afford",
//                 style: TextStyle(
//                   fontSize: 15,
//                 ),),
//               ],
//             ),
//           ),
//           const Divider(),
//           ListTile(
//             leading: CircleAvatar(
//               radius: 25,
//               backgroundColor: Colors.transparent,
//               child: Image.asset(
//                 "assets/images/person4.png",
//               ),
//             ),
//             title: Padding(
//               padding: const EdgeInsets.symmetric(vertical:8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text('Anastasia Ganin',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),),
//                   Text('4 hours ago'),
//                 ],
//               ),
//             ),
//             subtitle: Row(
//               children: const [
//                 Icon(Icons.done_all_rounded),
//                 Text('We can meet at 5 PM Tuesday!',
//                 style: TextStyle(
//                   fontSize: 15,
//                 ),),
//               ],
//             ),
//           ),
//           const Divider(),
//           ListTile(
//             leading: CircleAvatar(
//               radius: 25,
//               backgroundColor: Colors.transparent,
//               child: Image.asset(
//                 "assets/images/person5.png",
//               ),
//             ),
//             title: Padding(
//               padding: const EdgeInsets.symmetric(vertical:8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text('Harsh Vardhan',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),),
//                   Text('17 hours ago'),
//                 ],
//               ),
//             ),
//             subtitle: Row(
//               children: const [
//                 Icon(Icons.done_all_rounded),
//                 Text('Are you free sometime in the...',
//                 style: TextStyle(
//                   fontSize: 15,
//                 ),),
//               ],
//             ),
//           ),
//           const Divider(),
//           ListTile(
//             leading: CircleAvatar(
//               radius: 25,
//               backgroundColor: Colors.transparent,
//               child: Image.asset(
//                 "assets/images/person1.png",
//               ),
//             ),
//             title: Padding(
//               padding: const EdgeInsets.symmetric(vertical:8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text('Sinita Leunen',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),),
//                   Text('Yesterday'),
//                 ],
//               ),
//             ),
//             subtitle: Row(
//               children: const [
//                 Icon(Icons.done_all_rounded),
//                 Text('We can meet at 2 PM Monday!',
//                 style: TextStyle(
//                   fontSize: 15,
//                 ),),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
