import 'package:firebase_auth/firebase_auth.dart';
import 'package:houseskape/model/property_model.dart';
import 'package:houseskape/notifiers/property_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

Future<QuerySnapshot<Map<String, dynamic>>> searchByName(String searchField) {
  return FirebaseFirestore.instance
      .collection("users")
      .where('name', isEqualTo: searchField)
      .get();
}

Future<void> addChatRoom(
    Map<String, dynamic> chatRoom, String chatRoomId) async {
  try {
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom);
  } catch (e, stack) {
    debugPrint('addChatRoom error: $e');
    debugPrintStack(stackTrace: stack);
  }
}

Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getChats(
    String chatRoomId) async {
  return FirebaseFirestore.instance
      .collection("chatRoom")
      .doc(chatRoomId)
      .collection("chats")
      .orderBy('time')
      .snapshots();
}

Future<void> addMessage2(
    String chatRoomId, Map<String, dynamic> chatMessageData) async {
  try {
    await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData);
  } catch (e, stack) {
    debugPrint('addMessage2 error: $e');
    debugPrintStack(stackTrace: stack);
  }
}

Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getUserChats(
    String itIsMyName) async {
  return FirebaseFirestore.instance
      .collection("chatRoom")
      .where('users', arrayContains: itIsMyName)
      .snapshots();
}

Future<void> getProperties(PropertyNotifier propertyNotifier) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('properties')
      .where('ownerId', isEqualTo: user.uid)
      .get();
  List<Property> propertyList = [];
  for (var document in snapshot.docs) {
    Property property = Property.fromMap(document.data(), id: document.id);
    propertyList.add(property);
  }
  propertyNotifier.propertyList = propertyList;
}

Future<void> getAllProperties(
    PropertyNotifier propertyNotifier, String location) async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
      .instance
      .collection('properties')
      .where('location', isEqualTo: location)
      .get();

  List<Property> allPropertyList = [];
  for (var document in snapshot.docs) {
    Property property = Property.fromMap(document.data(), id: document.id);
    allPropertyList.add(property);
  }
  propertyNotifier.allPropertyList = allPropertyList;
}

