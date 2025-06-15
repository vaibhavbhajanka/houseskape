import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
// import 'package:geocode/geocode.dart';
import 'package:houseskape/home_icons.dart';
import 'package:houseskape/notifiers/property_notifier.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:houseskape/model/property_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:houseskape/repository/chat_repository.dart';
import 'package:houseskape/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:yandex_mapkit/yandex_mapkit.dart';

bool bookmarked = false;
// Completer<YandexMapController> _completer = Completer();
// GeoCode geoCode = GeoCode();

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({super.key});
  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  Property? propertyArg;
  bool _isSaved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Property) {
      propertyArg = args;
    }
    _checkIfSaved();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _checkIfSaved() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final property = propertyArg ??
        Provider.of<PropertyNotifier>(context, listen: false).currentProperty;
    if (property.id == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('saved')
        .doc(property.id)
        .get();
    if (mounted) {
      setState(() {
        _isSaved = doc.exists;
      });
    }
  }

  Future<void> _toggleSave() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final property = propertyArg ??
        Provider.of<PropertyNotifier>(context, listen: false).currentProperty;
    if (property.id == null) return;

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('saved')
        .doc(property.id);

    if (_isSaved) {
      await ref.delete();
    } else {
      await ref.set({
        'propertyId': property.id,
        'savedAt': FieldValue.serverTimestamp(),
      });
    }

    if (mounted) {
      setState(() {
        _isSaved = !_isSaved;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    PropertyNotifier propertyNotifier = Provider.of<PropertyNotifier>(context);
    final property = propertyArg ?? propertyNotifier.currentProperty;
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leading: Icons.arrow_back_ios_new_rounded,
        onPressed: () {
          Navigator.pop(context);
        },
        title: 'Details',
        widget: IconButton(
          onPressed: _toggleSave,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_outline,
              key: ValueKey(_isSaved),
              color: const Color(0xff25262b),
            ),
          ),
        ),
        elevation: 0,
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: const Text(
      //     "Details",
      //     style: TextStyle(
      //         fontSize: 24,
      //         fontWeight: FontWeight.w700,
      //         color: Color(0xff25262B),),
      //   ),
      //   centerTitle: true,
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.arrow_back_ios,
      //       color: Color(0xff25262B),
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           setState(() {
      //             bookmarked = !bookmarked;
      //           });
      //         },
      //         icon: bookmarked
      //             ? const Icon(
      //                 Icons.bookmark_add_outlined,
      //                 size: 30,
      //                 color: Color(0xff25262B),
      //               )
      //             : const Icon(
      //                 Icons.bookmark_added_sharp,
      //                 size: 30,
      //                 color: Color(0xff25262B),
      //               ),)
      //   ],
      // ),
      bottomNavigationBar: Material(
        elevation: 20,
        shadowColor: Colors.grey[900],
        child: BottomAppBar(
          color: const Color(0xfffcf9f4),
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.currency_rupee),
                Text(
                  "${property.monthlyRent}/month",
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    property.image != null && property.image!.startsWith('http')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: CachedNetworkImage(
                                imageUrl: property.image!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.asset(
                                "assets/images/house2.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
              ),
              const SizedBox(height: 15),
              Text(
                property.adTitle.toString(),
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff25262B)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(HomeIcons.bed,
                          size: 17,
                          color: const Color(0xff25262B).withOpacity(0.7)),
                      const SizedBox(width: 10),
                      Text("${property.bedrooms} bedrooms",
                          style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xff25262B).withOpacity(0.7)))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(HomeIcons.bathtub,
                          size: 17,
                          color: const Color(0xff25262B).withOpacity(0.7)),
                      const SizedBox(width: 10),
                      Text("${property.bathrooms} bathrooms",
                          style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xff25262B).withOpacity(0.7)))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(HomeIcons.area,
                          size: 17,
                          color: const Color(0xff25262B).withOpacity(0.7)),
                      const SizedBox(width: 5),
                      Text("${property.area} sq.ft",
                          style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xff25262B).withOpacity(0.7)))
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1.5, color: Color(0xffE7E7E7)),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(property.ownerId)
                          .get(),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.data();
                        final profileUrl = data?['profileImage'] as String?;

                        return CircleAvatar(
                          radius: 25,
                          backgroundColor: const Color(0xffcccccc),
                          backgroundImage:
                              profileUrl != null && profileUrl.isNotEmpty
                                  ? NetworkImage(profileUrl)
                                  : null,
                          child: profileUrl == null || profileUrl.isEmpty
                              ? Text(
                                  (property.ownerName ??
                                          property.owner ??
                                          '?')[0]
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xff25262b),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        );
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          property.ownerName ?? property.owner ?? '',
                          style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff1B3359)),
                        ),
                        Text(
                          "Landlord",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff25262B).withOpacity(0.6)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Material(
                          child: InkWell(
                            onTap: () async {
                              final currentUser =
                                  FirebaseAuth.instance.currentUser;
                              final property = propertyArg ??
                                  propertyNotifier.currentProperty;
                              final ownerUid = property.ownerId;
                              if (currentUser == null ||
                                  ownerUid == null ||
                                  ownerUid == currentUser.uid) return;
                              final repo = FirestoreChatRepository();
                              final roomId = await repo.createOrGetRoom(
                                  currentUser.uid, ownerUid);

                              // Retrieve owner's display name from users collection
                              final snap = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(ownerUid)
                                  .get();
                              final ownerName = snap.data()?['name'] ?? 'User';

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Chat(
                                      chatRoomId: roomId,
                                      otherUserName: ownerName),
                                ),
                              );
                            },
                            child: const Icon(Icons.message_rounded),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const Divider(thickness: 1.5, color: Color(0xffE7E7E7)),
              const Text(
                "Location",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff25262B),
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: const Color(0xff25262B).withOpacity(0.7),
                  ),
                  Expanded(
                    child: Text(property.address.toString(),
                        style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xff25262B).withOpacity(0.7))),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: const Color(0xffE7E7E7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 48,
                        color: Color(0xff25262B),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Map view coming soon",
                        style: TextStyle(
                          color: Color(0xff25262B),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Description",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(children: [
                ExpandableText(
                  property.description.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff25262B).withOpacity(0.7)),
                  expandText: 'Read more',
                  collapseText: 'Read less',
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // void onMapCreated(YandexMapController controller) {
  //   _completer.complete(controller);
  //   controller.getScreenPoint(Point(
  //       longitude: getLatitude("85, E block, Thomas Ave, Brooklyn"),
  //       latitude: getLongitude("85, E block, Thomas Ave, Brooklyn")));
  // }

  // getLatitude(String address) async {
  //   Coordinates coordinates = await geoCode.forwardGeocoding(address: address);
  //   return coordinates.latitude;
  // }

  // getLongitude(String address) async {
  //   Coordinates coordinates = await geoCode.forwardGeocoding(address: address);
  //   return coordinates.longitude;
  // }
}
