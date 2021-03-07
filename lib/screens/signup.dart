import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notetaker/controllers/authController.dart';
import 'package:notetaker/screens/login.dart';

class SignUp extends GetWidget<AuthController> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: "Name"),
                controller: nameController,
                cursorColor: Colors.orangeAccent[700],
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(hintText: "Email"),
                cursorColor: Colors.orangeAccent[700],
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(hintText: "Password"),
                obscureText: true,
                cursorColor: Colors.orangeAccent[700],
              ),
              TextButton(
                child: Text("Sign Up"),
                onPressed: () {
                  controller.createUser(nameController.text,
                      emailController.text, passwordController.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
