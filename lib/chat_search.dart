// import 'package:chatapp/helper/constants.dart';
// import 'package:chatapp/models/user.dart';
// import 'package:chatapp/services/database.dart';
// import 'package:chatapp/views/chat.dart';
// import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseskape/chat.dart';
import 'package:houseskape/model/user_model.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'package:houseskape/repository/chat_repository.dart';

class ChatSearch extends StatefulWidget {
  const ChatSearch({super.key});

  @override
  State<ChatSearch> createState() => _ChatSearchState();
}

class _ChatSearchState extends State<ChatSearch> {
  // DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = TextEditingController();
  QuerySnapshot<Map<String, dynamic>>? searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  User? user = FirebaseAuth.instance.currentUser;

  UserModel loggedInUser = UserModel();
  final chatRepo = FirestoreChatRepository();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((u) {
      if (u != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(u.uid)
            .get()
            .then((value) {
          setState(() {
            loggedInUser = UserModel.fromMap(value.data());
          });
        });
      }
    });
  }

  Future<void> initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: searchEditingController.text)
          .get()
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userTile(String name, String uid) {
    return GestureDetector(
      onTap: () async {
        if (user == null) return;
        final roomId = await chatRepo.createOrGetRoom(user!.uid, uid);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(chatRoomId: roomId, otherUserName: name),
          ),
        );
      },
      child: ListTile(
        leading: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data();
            final profileUrl = data?['profileImage'] as String?;

            return CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xffcccccc),
              backgroundImage: profileUrl != null && profileUrl.isNotEmpty
                  ? NetworkImage(profileUrl)
                  : null,
              child: profileUrl == null || profileUrl.isEmpty
                  ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Color(0xff25262b),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            );
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot?.docs.length ?? 0,
            itemBuilder: (context, index) {
              final data = searchResultSnapshot!.docs[index].data();
              return userTile(data["name"] ?? '', data["uid"] ?? '');
            },
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        widget: const Icon(
          Icons.search,
          color: Color(0xff25262b),
        ),
        leading: Icons.arrow_back_ios,
        title: 'Search',
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  color: const Color(0x54FFFFFF),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchEditingController,
                          decoration: InputDecoration(
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            hintText: 'Search Name',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
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
                              colors: [Color(0x36FFFFFF), Color(0x0FFFFFFF)],
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(Icons.search),
                        ),
                      ),
                    ],
                  ),
                ),
                userList(),
              ],
            ),
    );
  }
}
