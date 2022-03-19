import 'package:flutter/material.dart';
import 'package:houseskape/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2c4b7d),
                  Color(0xFF1B3359),
                  Color(0xFFabb0c9),
                  Color(0xfffc68a8),
                  Color(0xFFFC1B5B),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: Card(
                  color: const Color.fromRGBO(255, 255, 255, 0.77),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 25.0),
                      ),
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        ' Register ',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Color(0xFF636363),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 140.0,
                        height: 3.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFC1B5B),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Form(
                        // key: _formKey,
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: ListTile(
                            leading: const Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            title: TextFormField(
                              // keyboardType: TextInputType.phone,
                              cursorColor: Colors.black,
                              // autovalidate: false,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter.digitsOnly
                              // ],
                              decoration: const InputDecoration(
                                hintText: 'Enter Email Id',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Form(
                        // key: _formKey,
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: ListTile(
                            leading: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            title: TextFormField(
                              // keyboardType: TextInputType.phone,
                              cursorColor: Colors.black,
                              // autovalidate: false,
                              // inputFormatters: [
                              //   WhitelistingTextInputFormatter.digitsOnly
                              // ],
                              decoration: const InputDecoration(
                                hintText: 'Enter Password',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 0.0),
                        child: const InkWell(
                          child: Text(
                            "Already have an account? Click here to login",
                            style: TextStyle(
                              color: Color(0xFFFC1B5B),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 45.0),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFFC1B5B),
                ),
                child: const Padding(
                  padding:
                      EdgeInsets.only(left: 80, right: 80, top: 20, bottom: 20),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
