import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
// import 'package:geocode/geocode.dart';
import 'package:houseskape/home_icons.dart';
import 'package:houseskape/notifiers/property_notifier.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
// import 'package:yandex_mapkit/yandex_mapkit.dart';

bool bookmarked = false;
// Completer<YandexMapController> _completer = Completer();
// GeoCode geoCode = GeoCode();

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({Key? key}) : super(key: key);
  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    PropertyNotifier propertyNotifier = Provider.of<PropertyNotifier>(context);
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: CustomAppBar(
        onPressed: () {
          Navigator.pop(context);
        },
        title: 'Details',
        widget: const Icon(
          Icons.more_vert,
          color: Color(0xfffcf9f4),
        ),
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
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.currency_rupee),
                Text(
                  "${propertyNotifier.currentProperty.monthlyRent}/month",
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
                child: Image.asset(
                  "assets/images/house2.png",
                  width: 200,
                ),
              ),
              const SizedBox(height: 15),
               Text(
                propertyNotifier.currentProperty.adTitle.toString(),
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
                      Text("${propertyNotifier.currentProperty.bedrooms} bedrooms",
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
                      Text("${propertyNotifier.currentProperty.bathrooms} bathrooms",
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
                      Text("${propertyNotifier.currentProperty.area} sq.ft",
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
                    CircleAvatar(
                      minRadius: 20,
                      child: Image.asset("assets/images/person2.png"),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(
                          "${propertyNotifier.currentProperty.owner}",
                          style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              color:Color(0xff1B3359)),
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
                            elevation: 5,
                            child: InkWell(
                                onTap: () {},
                                child: const Icon(Icons.message_rounded))),
                        const SizedBox(width: 10),
                        Material(
                            elevation: 5,
                            child: InkWell(
                                onTap: () {},
                                child: const Icon(Icons.phone_outlined)))
                      ],
                    )
                  ],
                ),
              ),
              const Divider(thickness: 1.5, color: Color(0xffE7E7E7)),
              const Text(
                "Where you'll be",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff25262B),
                    fontWeight: FontWeight.w700),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: const Color(0xff25262B).withOpacity(0.7),
                  ),
                  Expanded(
                    child: Text(propertyNotifier.currentProperty.address.toString(),
                        style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xff25262B).withOpacity(0.7))),
                  )
                ],
              ),
              // SizedBox(
              //   height: 160,
              //   child: YandexMap(
              //     onMapCreated: onMapCreated,
              //   ),
              // ),
              const Text("Properties Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              Wrap(children: [
                ExpandableText(
                  propertyNotifier.currentProperty.description.toString(),
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
