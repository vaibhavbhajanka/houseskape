import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({ Key? key }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // children: [
          
        // ],
      ),
    );
  }
}
// class MapScreen extends StatefulWidget {
//   static const kInitialPosition = LatLng(-33.8567844, 151.213108);
//   const MapScreen({ Key? key }) : super(key: key);

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   late PickResult selectedPlace;
//   @override
//   Widget build(BuildContext context) {
//     return PlacePicker(
//                           apiKey: '',
//                           initialPosition: kInitialPosition,
//                           useCurrentLocation: true,
//                           selectInitialPosition: true,

//                           //usePlaceDetailSearch: true,
//                           onPlacePicked: (result) {
//                             selectedPlace = result;
//                             Navigator.of(context).pop();
//                             setState(() {});
//                           },
//                           //forceSearchOnZoomChanged: true,
//                           //automaticallyImplyAppBarLeading: false,
//                           //autocompleteLanguage: "ko",
//                           //region: 'au',
//                           //selectInitialPosition: true,
//                           // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
//                           //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
//                           //   return isSearchBarFocused
//                           //       ? Container()
//                           //       : FloatingCard(
//                           //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
//                           //           leftPosition: 0.0,
//                           //           rightPosition: 0.0,
//                           //           width: 500,
//                           //           borderRadius: BorderRadius.circular(12.0),
//                           //           child: state == SearchingState.Searching
//                           //               ? Center(child: CircularProgressIndicator())
//                           //               : RaisedButton(
//                           //                   child: Text("Pick Here"),
//                           //                   onPressed: () {
//                           //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
//                           //                     //            this will override default 'Select here' Button.
//                           //                     print("do something with [selectedPlace] data");
//                           //                     Navigator.of(context).pop();
//                           //                   },
//                           //                 ),
//                           //         );
//                           // },
//                           // pinBuilder: (context, state) {
//                           //   if (state == PinState.Idle) {
//                           //     return Icon(Icons.favorite_border);
//                           //   } else {
//                           //     return Icon(Icons.favorite);
//                           //   }
//                           // },
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//               selectedPlace == null ? Container() : Text(selectedPlace.formattedAddress ?? ""),
//             ],
//           ),
//         ),
//       );
//   }
// }