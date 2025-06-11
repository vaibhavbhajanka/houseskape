import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:houseskape/model/property_model.dart';
import 'package:houseskape/model/user_model.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class Step2Screen extends StatefulWidget {
  const Step2Screen({Key? key, required this.property}) : super(key: key);
  final Property property;
  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController adTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController rentController = TextEditingController();

  String? url;

  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      // setState(() {});
    });
  } 

  File? _imageFile;
  _showImage() {
    if (_imageFile == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Center(
          child: OutlinedButton(
            // style: ButtonStyle(
            //   side:
            // ),

            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add),
                  Text(
                    'Add Image',
                  )
                ],
              ),
            ),
            onPressed: () {
              _getLocalImage();
            },
          ),
        ),
      );
    } else if (_imageFile != null) {
      // print('showing image from local file');

      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                _imageFile!,
                fit: BoxFit.cover,
                height: 250,
              ),
            ),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.all(8)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black54),
              ),
              child: const Text(
                'Change Image',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
              onPressed: () => _getLocalImage(),
            )
          ],
        ),
      );
    }
  }

  _getLocalImage() async {
    final imageFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final newProperty = widget.property;
    final adTitleField = TextFormField(
      autofocus: false,
      controller: adTitleController,
      keyboardType: TextInputType.text,
      validator: (value) {
        // RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Ad Title cannot be Empty");
        }
        // if (!regex.hasMatch(value)) {
        //   return ("Enter Valid name(Min. 3 Character)");
        // }
        return null;
      },
      onSaved: (value) {
        adTitleController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.bodyText2,
        labelText: ' Ad Title ',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
    final descriptionField = TextFormField(
      autofocus: false,
      controller: descriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (value) {
        // RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Description cannot be Empty");
        }
        // if (!regex.hasMatch(value)) {
        //   return ("Enter Valid name(Min. 3 Character)");
        // }
        return null;
      },
      onSaved: (value) {
        descriptionController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.bodyText2,
        labelText: ' Description ',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
    final rentField = TextFormField(
      autofocus: false,
      controller: rentController,
      keyboardType: TextInputType.number,
      validator: (value) {
        // RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Rent cannot be Empty");
        }
        // if (!regex.hasMatch(value)) {
        //   return ("Enter Valid name(Min. 3 Character)");
        // }
        return null;
      },
      onSaved: (value) {
        rentController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.bodyText2,
        labelText: ' Rent(\u{20B9}) ',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'Step 2',
        widget: const Icon(
          Icons.abc,
          color: Color(0xfffcf9f4),
        ),
        onPressed: () {},
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: adTitleField,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: descriptionField,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: rentField,
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ListTile(
                      title: const Text(
                        'Property Image',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: _showImage()),
                ),
                // Text(url.toString()),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF1B3359),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        left: 80, right: 80, top: 20, bottom: 20),
                    child: Text(
                      'Post Ad',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    // newProperty.adTitle=adTitleController.text;
                    // newProperty.description=descriptionController.text;
                    uploadImage();
                    postPropertyToFirestore();
                    Navigator.popUntil(
                        context, ModalRoute.withName('/dashboard'));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  uploadImage() async {
    if ((_imageFile) != null) {
      // print("uploading image");

      var fileExtension = path.extension(_imageFile!.path);
      // print(fileExtension);

      var uuid = const Uuid().v4();

      UploadTask? uploadTask;
      // String? url;
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('properties/images/$uuid$fileExtension');

      uploadTask = firebaseStorageRef.putFile(_imageFile!);
      final snapshot = await uploadTask.whenComplete(() => null);

      final urlDownload = await snapshot.ref.getDownloadURL();
      // await firebaseStorageRef.putFile(_imageFile!).whenComplete(() async {
      //   await firebaseStorageRef.getDownloadURL().then((value)async {
      //     print(value);
      //     url=value;
      //     // postPropertyToFirestore(value);
      //   });
      // });
      //     .catchError((onError) {
      //   print(onError);
      //   return false;
      // });
      setState(() async{
        url=urlDownload;
      });

      print("download url: $urlDownload");
      // print(url);
      // postPropertyToFirestore();
      // return url;
      // _uploadFood(food, isUpdating, foodUploaded, imageUrl: url);
    } else {
      print('...skipping image upload');
      // return null;
      // _uploadFood(food, isUpdating, foodUploaded);
    }
  }

  postPropertyToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    Property newProperty = Property();

    if (_formKey.currentState!.validate()) {
      try {
        newProperty.date = DateTime.now();
        newProperty.location = widget.property.location;
        newProperty.address = widget.property.address;
        newProperty.type = widget.property.type;
        newProperty.bedrooms = widget.property.bedrooms;
        newProperty.bathrooms = widget.property.bathrooms;
        newProperty.area = widget.property.area;
        newProperty.adTitle = adTitleController.text;
        newProperty.description = descriptionController.text;
        newProperty.image = url;
        newProperty.monthlyRent = num.parse(rentController.text);
        newProperty.owner = loggedInUser.name;

        print('image:${newProperty.image}');

        await firebaseFirestore
            .collection("listings")
            .doc(user?.uid)
            .collection("properties")
            .add(newProperty.toMap());
        Fluttertoast.showToast(msg: "Property added successfully");
      } catch (error) {
        Fluttertoast.showToast(msg: error.toString());
      }
    }
    // Navigator.restorablePushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
  }
}
