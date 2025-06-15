import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:houseskape/home_icons.dart';
import 'package:houseskape/model/user_model.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  final ImagePicker _picker = ImagePicker();
  bool _uploadingImage = false;

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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? profileImageUrl = _getProfileImageUrl();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        leading: null,
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
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          radius: 50,
                          backgroundImage: profileImageUrl != null
                              ? NetworkImage(profileImageUrl)
                              : null,
                          child: profileImageUrl == null
                              ? const Icon(Icons.person,
                                  size: 50, color: Color(0xff25262b))
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickAndUploadImage,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: _uploadingImage
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : const Icon(Icons.camera_alt,
                                      size: 16, color: Color(0xff25262b)),
                            ),
                          ),
                        )
                      ],
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
                        style: const TextStyle(
                          color: Color(0xff25262b),
                          fontWeight: FontWeight.w500,
                          fontSize: 35,
                        ),
                      ),
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
                        backgroundColor: const Color(0xFF1b3359),
                      ),
                      child: const Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1b3359),
                      ),
                      child: const Text(
                        'Listings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () {
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

  String? _getProfileImageUrl() {
    // Prefer Firestore stored image if available
    if (loggedInUser.profileImage != null &&
        loggedInUser.profileImage!.isNotEmpty) {
      return loggedInUser.profileImage;
    }
    // Fall back to Google photo URL if user signed in with Google
    if (user != null) {
      final hasGoogleProvider =
          user!.providerData.any((p) => p.providerId == 'google.com');
      if (hasGoogleProvider &&
          user!.photoURL != null &&
          user!.photoURL!.isNotEmpty) {
        return user!.photoURL;
      }
    }
    return null; // No image available
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile == null) return;

    setState(() => _uploadingImage = true);
    try {
      final uid = user!.uid;
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$uid.jpg');
      await ref.putFile(File(pickedFile.path));
      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'profileImage': url});
      setState(() {
        loggedInUser.profileImage = url;
      });
    } catch (e) {
      // Handle error silently for now or show toast
    } finally {
      if (mounted) {
        setState(() => _uploadingImage = false);
      }
    }
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
    super.key,
    required this.icon,
    required this.title,
  });

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
              backgroundColor: const Color(0xffefefef),
              child: Icon(
                icon,
                color: const Color(0xff25262b),
                size: 35,
              ),
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
