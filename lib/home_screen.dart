// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:houseskape/home_icons.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leading: HomeIcons.menu,
        // actions: InkWell(child: Icon(Icons.search)),
        widget: Icon(Icons.search),
        elevation: 0,
        onPressed: (){
          Navigator.pushNamed(context, '/search');
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Find your \n',
                  style:
                      // Theme.of(context).textTheme.headline2,
                      TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF636363),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'best property',
                      style:
                          // Theme.of(context).textTheme.headline1,
                          TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 10, bottom: 10, right: 20.0),
                      child: Material(
                        color: Color(0xfffcf9f4),
                        borderRadius: BorderRadius.circular(20),
                        elevation: 5,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.450,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Image.asset(
                                  "assets/images/house1.png",
                                  height: 150,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  "Permount small family home",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700, fontSize: 15),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Wrap(children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 22,
                                    color: Color(0xff949494),
                                  ),
                                  Text(
                                    "E 88th, St.Evelyn, Bloomfield",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff949494),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Wrap(children: [
                                      Icon(
                                        Icons.currency_rupee,
                                      ),
                                      Text("10,000/month",
                                          style: TextStyle(fontSize: 16))
                                    ]),
                                  )
                                ]),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Featured property",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text(
                          "See all",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 160,
                child: Card(
                  color: Color(0xfffcf9f4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/images/house2.png",
                            height: 100,
                            width: 140,
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
                              child: Text("Necent Studio Apartment",
                                  style:
                                      // Theme.of(context).textTheme.bodyText2,
                                      TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(children: [
                                Icon(Icons.location_on_outlined,
                                    color: Color(0xff949494), size: 20),
                                Text("E 85th, Thomas Ave, Brooklyn",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xff949494))
                                    // Theme.of(context).textTheme.bodyText1,
                                    ),
                              ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  Wrap(children: [
                                Icon(
                                  Icons.bed,
                                  // HomeIcons.bed,
                                  size: 22,
                                  color: Color(0xff6f6f6f),
                                ),
                                SizedBox(width: 10),
                                Text("2 bedrooms",
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xff949494))
                                    // Theme.of(context).textTheme.bodyText1,
                                    )
                              ]),
                              SizedBox(width: 4,),
                              Wrap(children: [
                                Icon(Icons.bathtub,
                                    // HomeIcons.bathtub,
                                    size: 18,
                                    color: Color(0xff6f6f6f)),
                                SizedBox(width: 10),
                                Text(
                                  "2 bathrooms",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff949494),
                                      overflow: TextOverflow.ellipsis),
                                  // style: Theme.of(context).textTheme.bodyText1,
                                )
                              ]),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Wrap(children: [
                              Icon(Icons.currency_rupee),
                              Text("20000/month", style: TextStyle(fontSize: 17))
                            ])
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
