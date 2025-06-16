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
import 'package:provider/provider.dart';
import 'package:houseskape/notifiers/property_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Step2Screen extends StatefulWidget {
  final Property property;
  const Step2Screen({super.key, required this.property});
  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  final _formKey = GlobalKey<FormState>();

  User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController adTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController rentController = TextEditingController();

  String? url;

  UserModel loggedInUser = UserModel();

  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
    });
    // Pre-fill fields if editing
    if (widget.property.adTitle != null) {
      adTitleController.text = widget.property.adTitle ?? '';
    }
    if (widget.property.description != null) {
      descriptionController.text = widget.property.description ?? '';
    }
    if (widget.property.monthlyRent != null) {
      rentController.text = widget.property.monthlyRent.toString();
    }
    // Add listeners to update button state
    adTitleController.addListener(() => setState(() {}));
    descriptionController.addListener(() => setState(() {}));
    rentController.addListener(() => setState(() {}));
    // Note: image is not pre-filled for local file, but can show network image if needed
  }

  Future<void> _getLocalImage() async {
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
    // Step progress bar
    final progressBar = Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFabb0c9),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 120,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF1B3359),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          const SizedBox(width: 16),
          const Text('Step 2 of 2',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );

    // Ad title field with helper text
    final adTitleField = TextFormField(
      controller: adTitleController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Ad Title cannot be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Ad Title',
        hintText: 'e.g., Modern 2BHK Apartment',
        helperText: 'Enter a catchy title for your property',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF1B3359), width: 2),
        ),
        errorStyle:
            const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );

    // Description field with helper text
    final descriptionField = TextFormField(
      controller: descriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Description cannot be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'e.g., Spacious and well-lit apartment...',
        helperText: 'Describe your property and its features',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF1B3359), width: 2),
        ),
        errorStyle:
            const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );

    // Rent field with helper text
    final rentField = TextFormField(
      controller: rentController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Rent cannot be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Rent (₹)',
        hintText: 'e.g., 12000',
        helperText: 'Enter the monthly rent in INR',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF1B3359), width: 2),
        ),
        errorStyle:
            const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );

    // Large, tappable image area
    Widget imageArea = GestureDetector(
      onTap: _getLocalImage,
      child: Container(
        width: double.infinity,
        height: 220,
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey[300]!, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: _imageFile != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      _imageFile!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: GestureDetector(
                      onTap: () => setState(() => _imageFile = null),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: _getLocalImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.edit,
                            color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ],
              )
            : (widget.property.image != null &&
                    widget.property.image!.isNotEmpty)
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: widget.property.image!,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.image_not_supported, size: 100),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: _getLocalImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(Icons.edit,
                                color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo,
                            size: 48, color: Color(0xFF1B3359)),
                        SizedBox(height: 12),
                        Text('Add Photo',
                            style: TextStyle(
                                fontSize: 18, color: Color(0xFF1B3359))),
                      ],
                    ),
                  ),
      ),
    );

    // Post button state
    bool isFormValid = adTitleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        rentController.text.isNotEmpty &&
        (_imageFile != null ||
            (widget.property.image != null &&
                widget.property.image!.isNotEmpty));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        leading: Icons.arrow_back_ios_new_rounded,
        title: 'Step 2',
        widget: const SizedBox.shrink(),
        elevation: 0,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    progressBar,
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: adTitleField,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: descriptionField,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: rentField,
                          ),
                          imageArea,
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFormValid
                              ? const Color(0xFF1B3359)
                              : Colors.grey[400],
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: isFormValid ? 4 : 0,
                        ),
                        onPressed: isFormValid && !_isLoading
                            ? () => postPropertyToFirestore()
                            : null,
                        child: Text(
                          widget.property.id != null ? 'Update Ad' : 'Post Ad',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> postPropertyToFirestore() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fill all fields correctly.");
      return;
    }
    if (_imageFile == null && widget.property.image == null) {
      Fluttertoast.showToast(msg: "Please select an image.");
      return;
    }
    setState(() => _isLoading = true);
    try {
      // Upload image if a new one is selected, else use existing
      String? imageUrl = widget.property.image;
      if (_imageFile != null) {
        var fileExtension = path.extension(_imageFile!.path);
        var uuid = const Uuid().v4();
        final firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('properties/images/$uuid$fileExtension');
        final uploadTask = firebaseStorageRef.putFile(_imageFile!);
        final snapshot = await uploadTask.whenComplete(() => null);
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      // Build property object
      Property newProperty = Property(
        id: widget.property.id,
        date: widget.property.date ?? DateTime.now(),
        location: widget.property.location,
        address: widget.property.address,
        type: widget.property.type,
        bedrooms: widget.property.bedrooms,
        bathrooms: widget.property.bathrooms,
        area: widget.property.area,
        adTitle: adTitleController.text,
        description: descriptionController.text,
        image: imageUrl,
        monthlyRent: num.parse(rentController.text),
        owner: loggedInUser.name,
        ownerId: user?.uid,
        ownerName: loggedInUser.name,
        geo: widget.property.geo,
      );

      if (widget.property.id != null) {
        // Update existing property
        await FirebaseFirestore.instance
            .collection("properties")
            .doc(widget.property.id)
            .update(newProperty.toMap());
      } else {
        // Add new property
        final docRef = await FirebaseFirestore.instance
            .collection("properties")
            .add(newProperty.toMap());
        newProperty.id = docRef.id;
      }

      // Add to PropertyNotifier for instant UI update
      if (mounted) {
        final propertyNotifier =
            Provider.of<PropertyNotifier>(context, listen: false);
        if (widget.property.id != null) {
          propertyNotifier.updateProperty(newProperty);
        } else {
          propertyNotifier.addProperty(newProperty);
        }
      }

      // Show confirmation modal
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title:
                const Icon(Icons.check_circle, color: Colors.green, size: 60),
            content: Text(
              widget.property.id != null
                  ? 'Your property has been updated!'
                  : 'Your property has been listed!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B3359),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.popUntil(
                        context, ModalRoute.withName('/dashboard'));
                  },
                  child: const Text('Go to Dashboard',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error: $error");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    adTitleController.dispose();
    descriptionController.dispose();
    rentController.dispose();
    super.dispose();
  }
}
