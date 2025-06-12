import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:houseskape/text_theme_extensions.dart';

class FillDetailsScreen extends StatefulWidget {
  const FillDetailsScreen({Key? key}) : super(key: key);

  @override
  State<FillDetailsScreen> createState() => _FillDetailsScreenState();
}

class _FillDetailsScreenState extends State<FillDetailsScreen> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: deviceHeight(context) * 0.08,
                left: deviceWidth(context) * 0.18,
                right: deviceWidth(context) * 0.18,
              ),
              child: Column(
                children: [
                  Text(
                    'Register',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    width: 20,
                    height: 17,
                  ),
                  Text(
                    'Fill in your Details',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(
                    width: 20,
                    height: 20,
                  ),
                  Text(
                    'Seems you are new here',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "Let's set up your profile",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          labelText: ' Full Name',
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
                        cursorColor: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          labelText: ' Gender',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1.0, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                const BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        cursorColor: Colors.black,
                        //keyboardType: TextInputType.,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          labelText: ' Mobile Number',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1.0, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1.0),
                          ),
                        ),
                        cursorColor: Colors.black,
                        keyboardType: const TextInputType.numberWithOptions(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: DateTimePicker(
                        decoration: InputDecoration(
                          labelText: " Date",
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          contentPadding: const EdgeInsets.only(left: 20),
                          suffixIcon: const Icon(
                            Icons.event,
                            color: Colors.black,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                width: 1.0, color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                const BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        type: DateTimePickerType.date,
                        dateMask: 'dd MMM, yyyy',
                        initialValue: DateTime.now().toString(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Date',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Wrap(
              children: [
                CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: TextButton(
                      onPressed: () {},
                      child: const Text(
                          "By creating an account, you agree to our Terms and Conditions.",
                          style: TextStyle(color: Colors.black)),
                    ),
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                    value: isChecked),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3359),
              ),
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                child: Text(
                  ' Continue ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  child: const Text(
                    " Login",
                    style: TextStyle(
                      color: Color(0xFF1B3359),
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
