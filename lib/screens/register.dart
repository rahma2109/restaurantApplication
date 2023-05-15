import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurantapplication/screens/login_screen.dart';
import 'package:restaurantapplication/screens/register.dart';

import '../helper/firebase_auth.dart';
import '../helper/validator.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;

  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrangeAccent,
          title: const Text('Create Account'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _registerFormKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _nameTextController,
                            focusNode: _focusName,
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                            decoration: InputDecoration(
                              hintText: "Name",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          TextFormField(
                            controller: _emailTextController,
                            focusNode: _focusEmail,
                            validator: (value) => Validator.validateEmail(
                              email: value,
                            ),
                            decoration: InputDecoration(
                              hintText: "Email",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          TextFormField(
                            controller: _passwordTextController,
                            focusNode: _focusPassword,
                            obscureText: true,
                            validator: (value) => Validator.validatePassword(
                              password: value,
                            ),
                            decoration: InputDecoration(
                              hintText: "Password",
                              errorBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          _isProcessing
                              ? const CircularProgressIndicator()
                              : Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            _isProcessing = true;
                                          });

                                          if (_registerFormKey.currentState!
                                              .validate()) {
                                            User? user =
                                                await FirebaseAuthHelper
                                                    .registerUsingEmailPassword(
                                              name: _nameTextController.text,
                                              email: _emailTextController.text,
                                              password:
                                                  _passwordTextController.text,
                                            );

                                            setState(() {
                                              _isProcessing = false;
                                            });

                                            if (user != null) {
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen(user: user),
                                                ),
                                                ModalRoute.withName('/'),
                                              );
                                            }
                                          } else {
                                            setState(() {
                                              _isProcessing = false;
                                            });
                                          }
                                        },
                                        // ignore: sort_child_properties_last
                                        child: const Text(
                                          'Sign up',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.deepOrangeAccent),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "Do you  have an account?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 5.0),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  },
                                  child: const Text("Login Now",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
