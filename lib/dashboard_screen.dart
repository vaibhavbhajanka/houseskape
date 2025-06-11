import 'package:flutter/material.dart';
import 'package:houseskape/chat_screen.dart';
import 'package:houseskape/home_icons.dart';
import 'package:houseskape/home_screen.dart';
import 'package:houseskape/profile_screen.dart';
import 'package:houseskape/saved_screen.dart';
import 'package:houseskape/step1_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int currentTab = 0;

  final screens = [
    const HomeScreen(),
    const SavedScreen(),
    const ChatScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcf9f4),
      body: IndexedStack(
        index: currentTab,
        children: screens,
      ),
      // body: Center(
      //   child: Padding(
      //     padding: const EdgeInsets.all(20),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: <Widget>[
      //         const Text(
      //           'Welcome Back',
      //           style: TextStyle(
      //             fontSize: 20,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //         const SizedBox(
      //           height: 10,
      //         ),
      //         Text(
      //           "${loggedInUser.name}",
      //           style: const TextStyle(
      //             color: Colors.black54,
      //             fontWeight: FontWeight.w500,
      //           ),
      //         ),
      //         Text(
      //           "${loggedInUser.email}",
      //           style: const TextStyle(
      //             color: Colors.black54,
      //             fontWeight: FontWeight.w500,
      //           ),
      //         ),
      //         const SizedBox(
      //           height: 15,
      //         ),
      //         ElevatedButton(
      //           style: ElevatedButton.styleFrom(
      //             primary: const Color(0xFFFC1B5B),
      //           ),
      //           child: const Padding(
      //             padding:
      //                 EdgeInsets.only(left: 80, right: 80, top: 20, bottom: 20),
      //             child: Text(
      //               'Logout',
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 20.0,
      //               ),
      //             ),
      //           ),
      //           onPressed: () {
      //             logout(context);
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Step1Screen(),),);
        },
        shape: const CircleBorder(
          side: BorderSide(
            color: Colors.white,
            width: 4,
          ),
        ),
        backgroundColor: const Color(0xff1b3359),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xfffcf9f4),
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                minWidth: 25,
                onPressed: () {
                  setState(() {
                    currentTab = 0;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    HomeIcons.home,
                    size: 20,
                    color: currentTab == 0
                        ? const Color(0xff1b3359)
                        : const Color(0xffcccccc),
                  ),
                ),
              ),
              MaterialButton(
                minWidth: 25,
                onPressed: () {
                  setState(() {
                    currentTab = 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: Icon(
                    HomeIcons.bookmark,
                    size: 20,
                    color: currentTab == 1
                        ? const Color(0xff1b3359)
                        : const Color(0xffcccccc),
                  ),
                ),
              ),
              MaterialButton(
                minWidth: 25,
                onPressed: () {
                  setState(() {
                    currentTab = 2;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Icon(
                    HomeIcons.chat,
                    size: 20,
                    color: currentTab == 2
                        ? const Color(0xff1b3359)
                        : const Color(0xffcccccc),
                  ),
                ),
              ),
              MaterialButton(
                minWidth: 25,
                onPressed: () {
                  setState(() {
                    currentTab = 3;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    HomeIcons.account,
                    size: 27,
                    color: currentTab == 3
                        ? const Color(0xff1b3359)
                        : const Color(0xffcccccc),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
