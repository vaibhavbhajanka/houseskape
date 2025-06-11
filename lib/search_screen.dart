import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseskape/api/property_api.dart';
import 'package:houseskape/model/property_model.dart';
import 'package:houseskape/notifiers/property_notifier.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // final auth = FirebaseAuth.instance;
  // final googleSignIn = GoogleSignIn();
  List<String> items = ["Gangtok", "Majitar", "Rangpo", "Singtam"];
  String? selecteditem = "Gangtok";

  User? user = FirebaseAuth.instance.currentUser;

  Property property = Property();

  @override
  void initState() {
    PropertyNotifier propertyNotifier =
        Provider.of<PropertyNotifier>(context, listen: false);
    getAllProperties(propertyNotifier, selecteditem.toString());
    // print(propertyNotifier.propertyList[0].adTitle);
    super.initState();
    // FirebaseFirestore.instance
    //     .collection('listings')
    //     .doc(user!.uid)
    //     .get()
    //     .then((value) {
    //   property = Property.fromMap(value.data());
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    PropertyNotifier propertyNotifier = Provider.of<PropertyNotifier>(context);
    Future<void> _refreshList() async {
      getAllProperties(propertyNotifier, selecteditem.toString());
    }

    return Scaffold(
      appBar: CustomAppBar(
        // leading: Icons.close,
        title: 'Search',
        widget: const Icon(
          Icons.abc,
          color: Color(0xfffcf9f4),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.bodyText2,
                  labelText: ' Location ',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                value: selecteditem,
                items: items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (item) => setState(() {
                  selecteditem = item;
                  getAllProperties(propertyNotifier, selecteditem.toString());
                }),
              ),
            ),
            RefreshIndicator(
              onRefresh: _refreshList,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: propertyNotifier.allPropertyList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                  // return const Divider(
                  // color: Colors.black,
                  // );
                },
                itemBuilder: (BuildContext context, int index) {
                  // return ListTile(
                  // leading: Image.network(
                  //   foodNotifier.foodList[index].image != null
                  //       ? foodNotifier.foodList[index].image
                  //       : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                  //   width: 120,
                  //   fit: BoxFit.fitWidth,
                  // ),
                  // title: Text(propertyNotifier.propertyList[index].adTitle.toString()),
                  // subtitle: Text(propertyNotifier.propertyList[index].location.toString().toUpperCase()),
                  // onTap: () {
                  //   foodNotifier.currentFood = foodNotifier.foodList[index];
                  //   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  //     return FoodDetail();
                  //   }));
                  // },
                  // );
                  return GestureDetector(
                    onTap: () {
                      propertyNotifier.currentProperty =
                          propertyNotifier.allPropertyList[index];
                      Navigator.pushNamed(context, '/property-details');
                    },
                    child: SizedBox(
                      height: 160,
                      child: Card(
                        color: const Color(0xfffcf9f4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    propertyNotifier
                                                .allPropertyList[index].image !=
                                            null
                                        ? propertyNotifier
                                            .allPropertyList[index].image
                                            .toString()
                                        : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                                    height: 100,
                                    width: 140,
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(width: 5),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                        propertyNotifier
                                            .allPropertyList[index].adTitle
                                            .toString(),
                                        style:
                                            // Theme.of(context).textTheme.bodyText2,
                                            const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                        propertyNotifier
                                            .allPropertyList[index].location
                                            .toString()
                                            .toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 17, color: Colors.black)
                                        // Theme.of(context).textTheme.bodyText1,
                                        ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Row(children: [
                                      const Icon(Icons.location_on_outlined,
                                          color: Color(0xff949494), size: 20),
                                      Expanded(
                                        child: Text(
                                            propertyNotifier
                                                .allPropertyList[index].address
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xff949494))
                                            // Theme.of(context).textTheme.bodyText1,
                                            ),
                                      ),
                                    ]),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(2.0),
                                  //   child: Row(
                                  //     children: [
                                  //       Wrap(children: const [
                                  //         Icon(
                                  //           Icons.bed,
                                  //           // HomeIcons.bed,
                                  //           size: 22,
                                  //           color: Color(0xff6f6f6f),
                                  //         ),
                                  //         SizedBox(width: 10),
                                  //         Text("2 bedrooms",
                                  //             style: TextStyle(
                                  //                 fontSize: 14, color: Color(0xff949494))
                                  //             // Theme.of(context).textTheme.bodyText1,
                                  //             )
                                  //       ]),
                                  //       const SizedBox(
                                  //         width: 4,
                                  //       ),
                                  //       Wrap(children: const [
                                  //         Icon(Icons.bathtub,
                                  //             // HomeIcons.bathtub,
                                  //             size: 18,
                                  //             color: Color(0xff6f6f6f)),
                                  //         SizedBox(width: 10),
                                  //         Text(
                                  //           "2 bathrooms",
                                  //           style: TextStyle(
                                  //               fontSize: 14,
                                  //               color: Color(0xff949494),
                                  //               overflow: TextOverflow.ellipsis),
                                  //           // style: Theme.of(context).textTheme.bodyText1,
                                  //         )
                                  //       ]),
                                  //     ],
                                  //   ),
                                  // ),
                                  const SizedBox(height: 10),
                                  Wrap(children: [
                                    const Icon(Icons.currency_rupee),
                                    Text(
                                        "${propertyNotifier.allPropertyList[index].monthlyRent?.toInt()}/month",
                                        style: const TextStyle(fontSize: 17))
                                  ])
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
