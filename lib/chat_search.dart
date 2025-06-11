// import 'package:chatapp/helper/constants.dart';
// import 'package:chatapp/models/user.dart';
// import 'package:chatapp/services/database.dart';
// import 'package:chatapp/views/chat.dart';
// import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:houseskape/api/property_api.dart';
import 'package:flutter/material.dart';
import 'package:houseskape/chat.dart';
import 'package:houseskape/model/user_model.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';

class ChatSearch extends StatefulWidget {
  const ChatSearch({Key? key}) : super(key: key);

  @override
  State<ChatSearch> createState() => _ChatSearchState();
}

class _ChatSearchState extends State<ChatSearch> {
  // DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = TextEditingController();
  QuerySnapshot<Map<String,dynamic>>? searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  User? user = FirebaseAuth.instance.currentUser;

  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
    });
  }

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await searchByName(searchEditingController.text).then((snapshot) {
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  
  Widget userTile(String name) {
    return GestureDetector(
      onTap: (){
        sendMessage(name);
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.transparent,
          child: Image.asset(
            "assets/images/person1.png",
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style:const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              // Text('16 mins ago'),
            ],
          ),
        ),
        // subtitle: Row(
        //   children: const [
        //     Icon(Icons.done_all_rounded),
        //     Text(
        //       'We can meet at 2 PM Monday!',
        //       style: TextStyle(
        //         fontSize: 15,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  Widget userList(){
    return haveUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchResultSnapshot?.docs.length,
        itemBuilder: (context, index){
        return userTile(
          searchResultSnapshot?.docs[index].data()["name"],
          // searchResultSnapshot.documents[index].data["userEmail"],
        );
        }) : Container();
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
  // / 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage(String userName){
    List<String> users = [loggedInUser.name.toString(),userName];

    String chatRoomId = getChatRoomId(loggedInUser.name.toString(),userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

    addChatRoom(chatRoom, chatRoomId);

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => Chat(
        chatRoomId: chatRoomId,
      )
    ));

  }

  // Widget userTile(String userName,String userEmail){
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //     child: Row(
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               userName,
  //               style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 16
  //               ),
  //             ),
  //             Text(
  //               userEmail,
  //               style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 16
  //               ),
  //             )
  //           ],
  //         ),
  //         Spacer(),
  //         GestureDetector(
  //           onTap: (){
  //             sendMessage(userName);
  //           },
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
  //             decoration: BoxDecoration(
  //                 color: Colors.blue,
  //                 borderRadius: BorderRadius.circular(24)
  //             ),
  //             child: Text("Message",
  //               style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 16
  //               ),),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        widget: const Icon(
          Icons.search,
          color: Color(0xfffcf9f4),
        ),
        leading: Icons.arrow_back_ios,
        title: 'Search',
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: isLoading
          ? const Center(
            child: CircularProgressIndicator(),
          )
          : Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                color: const Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchEditingController,
                        // style: simpleTextStyle(),
                        decoration: InputDecoration(
                          labelStyle: Theme.of(context).textTheme.bodyText2,
                          // labelText: ' Street Address ',
                          hintText: 'Search Name',
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        initiateSearch();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [
                                    Color(0x36FFFFFF),
                                    Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight),
                              borderRadius: BorderRadius.circular(40)),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(Icons.search)),
                    )
                  ],
                ),
              ),
              userList()
            ],
          ),
    );
  }
}
