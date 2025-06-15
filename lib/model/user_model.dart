class UserModel {
  String? email;
  String? name;
  String? uid;
  String? profileImage;

  UserModel({this.email, this.name, this.uid, this.profileImage});

  factory UserModel.fromMap(map) {
    return UserModel(
        email: map['email'],
        name: map['name'],
        uid: map['uid'],
        profileImage: map['profileImage']);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'uid': uid,
      'profileImage': profileImage
    };
  }
}
