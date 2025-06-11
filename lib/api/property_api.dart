// import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:houseskape/model/user_model.dart';
import 'package:houseskape/model/property_model.dart';
import 'package:houseskape/notifiers/property_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart' as path;
// import 'package:uuid/uuid.dart';

// login(User user, AuthNotifier authNotifier) async {
//   AuthResult authResult = await FirebaseAuth.instance
//       .signInWithEmailAndPassword(email: user.email, password: user.password)
//       .catchError((error) => print(error.code));

//   if (authResult != null) {
//     FirebaseUser firebaseUser = authResult.user;

//     if (firebaseUser != null) {
//       print("Log In: $firebaseUser");
//       authNotifier.setUser(firebaseUser);
//     }
//   }
// }

// signup(User user, AuthNotifier authNotifier) async {
//   AuthResult authResult = await FirebaseAuth.instance
//       .createUserWithEmailAndPassword(email: user.email, password: user.password)
//       .catchError((error) => print(error.code));

//   if (authResult != null) {
//     UserUpdateInfo updateInfo = UserUpdateInfo();
//     updateInfo.displayName = user.displayName;

//     FirebaseUser firebaseUser = authResult.user;

//     if (firebaseUser != null) {
//       await firebaseUser.updateProfile(updateInfo);

//       await firebaseUser.reload();

//       print("Sign up: $firebaseUser");

//       FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
//       authNotifier.setUser(currentUser);
//     }
//   }
// }

// signout(AuthNotifier authNotifier) async {
//   await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));

//   authNotifier.setUser(null);
// }

// initializeCurrentUser(AuthNotifier authNotifier) async {
//   FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

//   if (firebaseUser != null) {
//     print(firebaseUser);
//     authNotifier.setUser(firebaseUser);
//   }
// }

searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('name', isEqualTo: searchField)
        .get();
}

addChatRoom(chatRoom, chatRoomId) async {
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

getChats(String chatRoomId) async{
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }


  addMessage2(String chatRoomId, chatMessageData)async{

    await FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
          print(e.toString());
    });
  }

  getUserChats(String itIsMyName)async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
getProperties(PropertyNotifier propertyNotifier) async {
  User? user = FirebaseAuth.instance.currentUser;
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('listings')
      .doc(user!.uid)
      .collection('properties')
      // .orderBy("date", descending: true)
      .get();

  List<Property> _propertyList = [];

  for (var document in snapshot.docs) {
    // print(document.data())
    Property property = Property.fromMap(document.data());
    _propertyList.add(property);
  }

  propertyNotifier.propertyList = _propertyList;
}

getAllProperties(PropertyNotifier propertyNotifier, String location) async {
  // User? user = FirebaseAuth.instance.currentUser;
  List userList = await FirebaseFirestore.instance
      .collection("users")
      .get()
      .then((val) =>val.docs );
    // print(list_of_users);
    // for(var document in list_of_users){
    //   print(document.id);
    // }

  // print('Users:${list_of_users}');

  List<Property> _allPropertyList = [];

  for (int i = 0; i < userList.length; i++) {
  //   // FirebaseFirestore.instance.collection("masters").doc(
  //   //      list_of_users[i].documentID.toString()).collection("courses").snapshots().listen(CreateListofCourses);
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('listings')
        .doc(userList[i].id.toString())
        .collection('properties')
        .where("location",isEqualTo: location)
        // .orderBy("date", descending: true)
        .get();

    for (var document in snapshot.docs) {
      // print(document.data())
      Property property = Property.fromMap(document.data());
      _allPropertyList.add(property);
    }
  }
  propertyNotifier.allPropertyList = _allPropertyList;
}

// uploadFoodAndImage(Property food, bool isUpdating, File localFile, Function foodUploaded) async {
//   if (localFile != null) {
//     print("uploading image");

//     var fileExtension = path.extension(localFile.path);
//     print(fileExtension);

//     var uuid = Uuid().v4();

//     final StorageReference firebaseStorageRef =
//         FirebaseStorage.instance.ref().child('foods/images/$uuid$fileExtension');

//     await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
//       print(onError);
//       return false;
//     });

//     String url = await firebaseStorageRef.getDownloadURL();
//     print("download url: $url");
//     _uploadFood(food, isUpdating, foodUploaded, imageUrl: url);
//   } else {
//     print('...skipping image upload');
//     _uploadFood(food, isUpdating, foodUploaded);
//   }
// }

// _uploadFood(Food food, bool isUpdating, Function foodUploaded, {String imageUrl}) async {
//   CollectionReference foodRef = Firestore.instance.collection('Foods');

//   if (imageUrl != null) {
//     food.image = imageUrl;
//   }

//   if (isUpdating) {
//     food.updatedAt = Timestamp.now();

//     await foodRef.document(food.id).updateData(food.toMap());

//     foodUploaded(food);
//     print('updated food with id: ${food.id}');
//   } else {
//     food.createdAt = Timestamp.now();

//     DocumentReference documentRef = await foodRef.add(food.toMap());

//     food.id = documentRef.documentID;

//     print('uploaded food successfully: ${food.toString()}');

//     await documentRef.setData(food.toMap(), merge: true);

//     foodUploaded(food);
//   }
// }

// deleteFood(Food food, Function foodDeleted) async {
//   if (food.image != null) {
//     StorageReference storageReference =
//         await FirebaseStorage.instance.getReferenceFromUrl(food.image);

//     print(storageReference.path);

//     await storageReference.delete();

//     print('image deleted');
//   }

//   await Firestore.instance.collection('Foods').document(food.id).delete();
//   foodDeleted(food);
// }