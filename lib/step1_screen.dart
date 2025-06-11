import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:houseskape/model/property_model.dart';
import 'package:houseskape/step2_screen.dart';
import 'package:houseskape/widgets/custom_app_bar.dart';

class Step1Screen extends StatefulWidget {
  const Step1Screen({Key? key}) : super(key: key);
  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  List<String> items = ['Gangtok', 'Majitar', 'Rangpo', 'Singtam'];
  String? selecteditem = 'Gangtok';

  List<int> numbers = [for (var i = 0; i <= 10; i++) i];
  int? selectedBedroomNumber = 0;
  int? selectedBathroomNumber = 0;

  final _formKey = GlobalKey<FormState>();

  int _indexSelected = 0;
  String? selectedType = '';

  final TextEditingController addressController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController areaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final newProperty = Property(
        date: null,
        location: null,
        address: null,
        type: null,
        bedrooms: null,
        bathrooms:null,
        area:null,
        adTitle: null,
        description: null,
        monthlyRent: null,
        image: null,
        owner: null);

    // final newProperty = PropertyModel(
    //     date: widget.property.date,
    //     location: widget.property.location,
    //     address: widget.property.address,
    //     type: widget.property.,
    //     monthlyRent: null,
    //     adTitle: null,
    //     description: null);
    final addressField = TextFormField(
      autofocus: false,
      controller: addressController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      validator: (value) {
        // RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Address cannot be Empty");
        }
        // if (!regex.hasMatch(value)) {
        //   return ("Enter Valid name(Min. 3 Character)");
        // }
        return null;
      },
      onSaved: (value) {
        addressController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.bodyText2,
        labelText: ' Street Address ',
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
    final areaField = TextFormField(
      autofocus: false,
      controller: areaController,
      keyboardType: TextInputType.text,
      validator: (value) {
        // RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Area cannot be Empty");
        }
        // if (!regex.hasMatch(value)) {
        //   return ("Enter Valid name(Min. 3 Character)");
        // }
        return null;
      },
      onSaved: (value) {
        areaController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelStyle: Theme.of(context).textTheme.bodyText2,
        labelText: ' Area(sq.ft) ',
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
        title: 'Step 1',
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
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelStyle: Theme.of(context).textTheme.bodyText2,
                      labelText: ' Location ',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    value: selecteditem,
                    items: items
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(),
                    onChanged: (item) => setState(() => selecteditem = item),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: addressField,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    title: const Text(
                      'Property Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: Wrap(
                          children: [
                            ChoiceChip(
                              label: const Text('Studio'),
                              selected: _indexSelected == 0,
                              onSelected: (value) {
                                setState(() {
                                  _indexSelected = value ? 0 : -1;
                                  selectedType = 'Studio';
                                });
                              },
                            ),
                            const SizedBox(width: 15),
                            ChoiceChip(
                              label: const Text('Convertible Studio'),
                              selected: _indexSelected == 1,
                              onSelected: (value) {
                                setState(() {
                                  _indexSelected = value ? 1 : -1;
                                  selectedType = 'Convertible Studio';
                                });
                              },
                            ),
                            const SizedBox(width: 15),
                            ChoiceChip(
                              label: const Text('Garden Apartment'),
                              selected: _indexSelected == 2,
                              onSelected: (value) {
                                setState(() {
                                  _indexSelected = value ? 2 : -1;
                                  selectedType = 'Garden Apartment';
                                });
                              },
                            ),
                            const SizedBox(width: 15),
                            ChoiceChip(
                              label: const Text('Duplex'),
                              selected: _indexSelected == 3,
                              onSelected: (value) {
                                setState(() {
                                  _indexSelected = value ? 3 : -1;
                                  selectedType = 'Duplex';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelStyle: Theme.of(context).textTheme.bodyText2,
                            labelText: ' Bedroom ',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1),
                            ),
                          ),
                          value: selectedBedroomNumber.toString(),
                          items: numbers
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item.toString(),
                                  child: Text(item.toString()),
                                ),
                              )
                              .toList(),
                          onChanged: (item) =>
                              setState(() => selectedBedroomNumber = int.parse(item.toString()),
                        ),
                      ),
                    ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelStyle: Theme.of(context).textTheme.bodyText2,
                            labelText: ' Bathroom ',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1),
                            ),
                          ),
                          value: selectedBathroomNumber.toString(),
                          items: numbers
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item.toString(),
                                  child: Text(item.toString()),
                                ),
                              )
                              .toList(),
                          onChanged: (item) =>
                              setState(() => selectedBathroomNumber = int.parse(item.toString())),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: areaField,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF1B3359),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 80, right: 80, top: 20, bottom: 20),
              child: Wrap(
                children: const [
                  Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.arrow_forward)
                ],
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                try {
                  newProperty.location = selecteditem;
                  newProperty.address = addressController.text;
                  newProperty.type = selectedType;
                  newProperty.bedrooms = selectedBedroomNumber;
                  newProperty.bathrooms = selectedBathroomNumber;
                  newProperty.area = areaController.text;
                  // newProperty.monthlyRent = num.parse(rentController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Step2Screen(property: newProperty),
                    ),
                  );
                } catch (error) {
                  Fluttertoast.showToast(msg: error.toString());
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
