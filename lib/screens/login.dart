import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetaker/controllers/authController.dart';
import 'package:notetaker/screens/signup.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthController _auth = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: "Email"),
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                ),
                cursorColor: Colors.orangeAccent[700],
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: "Password"),
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                ),
                cursorColor: Colors.orangeAccent[700],
              ),
              TextButton(
                child: Text("Log in"),
                onPressed: () {},
              ),
              TextButton(
                child: Text("Sign Up"),
                onPressed: () {
                  Get.to(() => SignUp());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
