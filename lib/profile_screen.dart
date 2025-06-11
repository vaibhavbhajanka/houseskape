import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:houseskape/home_icons.dart';
import 'package:houseskape/model/user_model.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  
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
      // print(loggedInUser);
      setState(() {});
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        onPressed: (){},
        widget: PopupMenuButton(
          icon: const Icon(
            Icons.more_vert,
            color: Color(0xff25262b),
          ),
          onSelected: (value) => selectedItem(context, value),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 0,
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
              ),
            ),
          ],
        ),
        title: 'Account',
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 const Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 50,
                      backgroundImage:
                      // NetworkImage("${user?.photoURL}"),
                      AssetImage(
                        "assets/images/dp.jpg",
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${loggedInUser.name}',
                        // "${user?.displayName}",
                        style: const TextStyle(
                          color: Color(0xff25262b),
                          fontWeight: FontWeight.w500,
                          fontSize: 35,
                        ),
                      ),
                      // Text(
                      //   'Turing',
                      //   style: TextStyle(
                      //     color: Color(0xff25262b),
                      //     fontWeight: FontWeight.w500,
                      //     fontSize: 35,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF1b3359),
                      ),
                      child: const Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        // signIn(emailController.text, passwordController.text);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF1b3359),
                      ),
                      child: const Text(
                        'Listings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
                        // signIn(emailController.text, passwordController.text);
                        Navigator.pushNamed(context, '/listings');
                      },
                    ),
                  ),
                ),
              ],
            ),
            const ReusableListTile(
              icon: HomeIcons.profileOutline,
              title: 'Profile',
            ),
            const Divider(
              indent: 100,
              endIndent: 30,
              thickness: 1,
            ),
            const ReusableListTile(
              icon: Icons.notifications,
              title: 'Notifications',
            ),
            const Divider(
              indent: 100,
              endIndent: 30,
              thickness: 1,
            ),
            const ReusableListTile(
              icon: Icons.info_outline_rounded,
              title: 'About Us',
            ),
            const Divider(
              indent: 100,
              endIndent: 30,
              thickness: 1,
            ),
            const ReusableListTile(
              icon: HomeIcons.lock,
              title: 'Privacy',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.restorablePushReplacementNamed(context, '/login');
  }

  void selectedItem(BuildContext context, value) {
    switch (value) {
      case 0:
        logout(context);
        break;
    }
  }
}

class ReusableListTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const ReusableListTile({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: CircleAvatar(
              radius: 35,
              child: Icon(
                icon,
                color: const Color(0xff25262b),
                size: 35,
              ),
              backgroundColor: const Color(0xffefefef),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
