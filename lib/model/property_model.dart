import 'package:cloud_firestore/cloud_firestore.dart';

class Property{
  String? id; // Firestore document ID
  DateTime? date;
  String? location;
  String? address;
  String? type;
  int? bedrooms;
  int? bathrooms;
  String? area; 
  String? adTitle;
  String? description;
  num? monthlyRent;
  String? image;
  String? owner;
  String? ownerId; // UID of the owner
  String? ownerName; // Display name of the owner

  Property({
    this.id,
    this.date,
    this.location,
    this.address,
    this.type,
    this.bedrooms,
    this.bathrooms,
    this.area,
    this.adTitle,
    this.description,
    this.monthlyRent,
    this.image,
    this.owner,
    this.ownerId,
    this.ownerName,
  });

  factory Property.fromMap(Map<String, dynamic> map, {String? id}){
    return Property(
      id: id,
      date:(map['date'] as Timestamp).toDate(),
      location: map['location'],
      address: map['address'],
      type: map['type'],
      bedrooms: map['bedrooms'],
      bathrooms: map['bathrooms'],
      area: map['area'],
      adTitle: map['adTitle'],
      description: map['description'],
      monthlyRent: map['monthlyRent'],
      image: map['image'],
      owner: map['owner'],
      ownerId: map['ownerId'],
      ownerName: map['ownerName'],
    );
  }

  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'date':date,
      'location':location,
      'address':address,
      'type':type,
      'bedrooms':bedrooms,
      'bathrooms':bathrooms,
      'area':area,
      'adTitle':adTitle,
      'description':description,
      'monthlyRent':monthlyRent,
      'image':image,
      'owner':owner,
      'ownerId':ownerId,
      'ownerName':ownerName,
    };
  }
}
