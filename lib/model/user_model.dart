class UserModel{
  String? email;
  String? name;
  String? uid;

  UserModel({this.email,this.name,this.uid});

  factory UserModel.fromMap(map){
    return UserModel(
      email:map['email'],
      name:map['name'],
      uid:map['uid']
    );
  }

  Map<String,dynamic> toMap(){
    return{
      'email':email,
      'name':name,
      'uid':uid,
    };
  }
}