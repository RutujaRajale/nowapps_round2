import 'package:flutter/material.dart';
import 'package:nowapps_round2/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  TextEditingController phoneFieldController = TextEditingController();
  TextEditingController otpFieldController = TextEditingController();
  bool isPhoneEntered = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "LOGIN PAGE",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Form(
        key: _loginFormKey,
        child: ListView(children: <Widget>[
          TextFormField(
            controller: phoneFieldController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter phone number',
            ),
            validator: (value) {
              if (value!.length != 10) {
                return 'Please enter a valid 10 digit phone number';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                isPhoneEntered = false;
              });
            },
          ),
          if (!isPhoneEntered)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: const Text('Send OTP'),
                    onPressed: () {
                      if (_loginFormKey.currentState!.validate()) {
                        if (!isPhoneEntered) {
                          setState(() {
                            FocusScope.of(context).unfocus();
                            isPhoneEntered = true;
                          });
                        }
                      }
                    },
                  )),
            ),
          if (isPhoneEntered)
            TextFormField(
              controller: otpFieldController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter otp',
              ),
              validator: (value) {
                if (value!.length != 4) {
                  return 'Please enter a valid 4 digit otp';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {});
              },
            ),
          if (isPhoneEntered)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: const Text('Login'),
                    onPressed: () async {
                      if (_loginFormKey.currentState!.validate()) {
                        await saveLoginState();
                        setState(() {
                          FocusScope.of(context).unfocus();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        });
                      }
                    },
                  )),
            )
        ]),
      ),
    );
  }

  saveLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
  }
}
