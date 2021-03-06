import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetaker/controllers/authController.dart';
import 'package:notetaker/screens/login.dart';

class SignUp extends GetWidget<AuthController> {
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
                controller: emailController,
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
                controller: passwordController,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                decoration: InputDecoration(hintText: "Password"),
                obscureText: true,
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                ),
                cursorColor: Colors.orangeAccent[700],
              ),
              TextButton(
                child: Text("Sign Up"),
                onPressed: () {
                  controller.createUser(
                      emailController.text, passwordController.text);
                  //Get.to(() => Login());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
