import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetaker/Widgets/BottomNavigationBar.dart';
import 'package:notetaker/controllers/authController.dart';
import 'package:notetaker/screens/signup.dart';

class Login extends GetWidget<AuthController> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log in"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: "Email"),
                controller: emailController,
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
                decoration: InputDecoration(hintText: "Password"),
                obscureText: true,
                controller: passwordController,
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                ),
                cursorColor: Colors.orangeAccent[700],
              ),
              TextButton(
                child: Text("Log in"),
                onPressed: () {
                  controller.loginUser(
                      emailController.text, passwordController.text);
                  //Get.to(() => BottomNavigationBarWidget());
                },
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
