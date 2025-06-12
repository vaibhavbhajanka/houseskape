import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:houseskape/model/property_model.dart';
import 'package:houseskape/step2_screen.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';
import 'package:houseskape/text_theme_extensions.dart';

class Step1Screen extends StatefulWidget {
  final Property? property;
  const Step1Screen({Key? key, this.property}) : super(key: key);
  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  List<String> items = ['Gangtok', 'Majitar', 'Rangpo', 'Singtam'];
  String? selecteditem = 'Gangtok';

  List<int> numbers = [for (var i = 0; i <= 10; i++) i];
  int? selectedBedroomNumber = 1;
  int? selectedBathroomNumber = 1;

  final _formKey = GlobalKey<FormState>();

  int _indexSelected = 0;
  String? selectedType = '';

  final TextEditingController addressController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController areaController = TextEditingController();

  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    if (widget.property != null) {
      // Pre-fill fields for editing
      selecteditem = widget.property!.location ?? 'Gangtok';
      addressController.text = widget.property!.address ?? '';
      selectedType = widget.property!.type ?? '';
      areaController.text = widget.property!.area ?? '';
      selectedBedroomNumber = widget.property!.bedrooms ?? 1;
      selectedBathroomNumber = widget.property!.bathrooms ?? 1;
      // Set property type chip index
      switch (selectedType) {
        case 'Studio':
          _indexSelected = 0;
          break;
        case 'Convertible Studio':
          _indexSelected = 1;
          break;
        case 'Garden Apartment':
          _indexSelected = 2;
          break;
        case 'Duplex':
          _indexSelected = 3;
          break;
        default:
          _indexSelected = -1;
      }
    }
    addressController.addListener(_updateFormValid);
    areaController.addListener(_updateFormValid);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(_updateFormValid));
  }

  void _updateFormValid() {
    final valid =
        selecteditem != null &&
        items.contains(selecteditem) &&
        selectedType != null &&
        selectedType!.isNotEmpty &&
        selectedBedroomNumber != null && selectedBedroomNumber != 0 &&
        selectedBathroomNumber != null && selectedBathroomNumber != 0 &&
        areaController.text.isNotEmpty &&
        addressController.text.isNotEmpty;
    if (isFormValid != valid) {
      setState(() {
        isFormValid = valid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final newProperty = Property(
      id: widget.property?.id,
      date: widget.property?.date,
      location: null,
      address: null,
      type: null,
      bedrooms: null,
      bathrooms: null,
      area: null,
      adTitle: null,
      description: null,
      monthlyRent: null,
      image: null,
      owner: null,
    );

    // Step progress bar
    final progressBar = Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF1B3359),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFabb0c9),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          const SizedBox(width: 16),
          const Text('Step 1 of 2', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );

    // Address field with helper text
    final addressField = TextFormField(
      controller: addressController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Address cannot be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Street Address',
        hintText: 'e.g., 123 Main St, Near Park',
        helperText: 'Enter the full address of the property',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF1B3359), width: 2),
        ),
        errorStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );

    // Area field with helper text
    final areaField = TextFormField(
      controller: areaController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Area cannot be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Area (sq.ft)',
        hintText: 'e.g., 1200',
        helperText: 'Enter the area in square feet',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF1B3359), width: 2),
        ),
        errorStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );

    // Sliders for bedrooms and bathrooms
    final bedroomSlider = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 4.0),
          child: Text('Bedrooms', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Row(
          children: [
            Text(
              selectedBedroomNumber != null && selectedBedroomNumber! > 0
                  ? selectedBedroomNumber.toString()
                  : '-',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Slider(
                value: (selectedBedroomNumber ?? 1).toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: selectedBedroomNumber?.toString() ?? '1',
                onChanged: (value) {
                  setState(() => selectedBedroomNumber = value.round());
                  _updateFormValid();
                },
                activeColor: const Color(0xFF1B3359),
                inactiveColor: Colors.grey[300],
              ),
            ),
          ],
        ),
        if (selectedBedroomNumber == null || selectedBedroomNumber == 0)
          const Padding(
            padding: EdgeInsets.only(left: 4.0, top: 4.0),
            child: Text('Select number of bedrooms', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
      ],
    );

    final bathroomSlider = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 4.0),
          child: Text('Bathrooms', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Row(
          children: [
            Text(
              selectedBathroomNumber != null && selectedBathroomNumber! > 0
                  ? selectedBathroomNumber.toString()
                  : '-',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Slider(
                value: (selectedBathroomNumber ?? 1).toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: selectedBathroomNumber?.toString() ?? '1',
                onChanged: (value) {
                  setState(() => selectedBathroomNumber = value.round());
                  _updateFormValid();
                },
                activeColor: const Color(0xFF1B3359),
                inactiveColor: Colors.grey[300],
              ),
            ),
          ],
        ),
        if (selectedBathroomNumber == null || selectedBathroomNumber == 0)
          const Padding(
            padding: EdgeInsets.only(left: 4.0, top: 4.0),
            child: Text('Select number of bathrooms', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
      ],
    );

    // Continue button state
    // bool isFormValid = _formKey.currentState?.validate() == true &&
    //     selecteditem != null &&
    //     items.contains(selecteditem) &&
    //     selectedType != null &&
    //     selectedType!.isNotEmpty &&
    //     selectedBedroomNumber != null && selectedBedroomNumber != 0 &&
    //     selectedBathroomNumber != null && selectedBathroomNumber != 0 &&
    //     areaController.text.isNotEmpty &&
    //     addressController.text.isNotEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Step 1'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
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
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Color(0xFF1B3359), width: 2),
                          ),
                          errorStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        value: selecteditem,
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        onChanged: (item) {
                          setState(() {
                            selecteditem = item;
                          });
                          _updateFormValid();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: addressField,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Property Type',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Center(
                            child: Wrap(
                              spacing: 15,
                              children: [
                                ChoiceChip(
                                  label: const Text('Studio'),
                                  selected: _indexSelected == 0,
                                  onSelected: (value) {
                                    setState(() {
                                      _indexSelected = value ? 0 : -1;
                                      selectedType = 'Studio';
                                    });
                                    _updateFormValid();
                                  },
                                  selectedColor: const Color(0xFF1B3359),
                                  labelStyle: TextStyle(
                                    color: _indexSelected == 0 ? Colors.white : Colors.black,
                                  ),
                                  backgroundColor: Colors.grey[200],
                                ),
                                ChoiceChip(
                                  label: const Text('Convertible Studio'),
                                  selected: _indexSelected == 1,
                                  onSelected: (value) {
                                    setState(() {
                                      _indexSelected = value ? 1 : -1;
                                      selectedType = 'Convertible Studio';
                                    });
                                    _updateFormValid();
                                  },
                                  selectedColor: const Color(0xFF1B3359),
                                  labelStyle: TextStyle(
                                    color: _indexSelected == 1 ? Colors.white : Colors.black,
                                  ),
                                  backgroundColor: Colors.grey[200],
                                ),
                                ChoiceChip(
                                  label: const Text('Garden Apartment'),
                                  selected: _indexSelected == 2,
                                  onSelected: (value) {
                                    setState(() {
                                      _indexSelected = value ? 2 : -1;
                                      selectedType = 'Garden Apartment';
                                    });
                                    _updateFormValid();
                                  },
                                  selectedColor: const Color(0xFF1B3359),
                                  labelStyle: TextStyle(
                                    color: _indexSelected == 2 ? Colors.white : Colors.black,
                                  ),
                                  backgroundColor: Colors.grey[200],
                                ),
                                ChoiceChip(
                                  label: const Text('Duplex'),
                                  selected: _indexSelected == 3,
                                  onSelected: (value) {
                                    setState(() {
                                      _indexSelected = value ? 3 : -1;
                                      selectedType = 'Duplex';
                                    });
                                    _updateFormValid();
                                  },
                                  selectedColor: const Color(0xFF1B3359),
                                  labelStyle: TextStyle(
                                    color: _indexSelected == 3 ? Colors.white : Colors.black,
                                  ),
                                  backgroundColor: Colors.grey[200],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: bedroomSlider,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: bathroomSlider,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: areaField,
                    ),
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
                    backgroundColor: isFormValid ? const Color(0xFF1B3359) : Colors.grey[400],
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: isFormValid ? 4 : 0,
                  ),
                  onPressed: isFormValid
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            if (selecteditem == null ||
                                !items.contains(selecteditem) ||
                                selectedType == null ||
                                selectedType!.isEmpty ||
                                selectedBedroomNumber == null || selectedBedroomNumber == 0 ||
                                selectedBathroomNumber == null || selectedBathroomNumber == 0 ||
                                areaController.text.isEmpty ||
                                addressController.text.isEmpty) {
                              Fluttertoast.showToast(msg: "Please fill all fields and select valid options.");
                              return;
                            }
                            try {
                              // Merge edited fields with original property (if editing)
                              final mergedProperty = Property(
                                id: widget.property?.id,
                                date: widget.property?.date,
                                location: selecteditem,
                                address: addressController.text,
                                type: selectedType,
                                bedrooms: selectedBedroomNumber,
                                bathrooms: selectedBathroomNumber,
                                area: areaController.text,
                                adTitle: widget.property?.adTitle,
                                description: widget.property?.description,
                                monthlyRent: widget.property?.monthlyRent,
                                image: widget.property?.image,
                                owner: widget.property?.owner,
                                ownerId: widget.property?.ownerId,
                                ownerName: widget.property?.ownerName,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Step2Screen(property: mergedProperty),
                                ),
                              );
                            } catch (error) {
                              Fluttertoast.showToast(msg: error.toString());
                            }
                          } else {
                            Fluttertoast.showToast(msg: "Please fill all fields correctly.");
                          }
                        }
                      : null,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
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

  @override
  void dispose() {
    addressController.dispose();
    rentController.dispose();
    areaController.dispose();
    super.dispose();
  }
}
