import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurantapplication/screens/main_screen.dart';
import 'dart:convert';
// import 'profile_page.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/firebase_auth.dart';
import '../helper/header_widget.dart';
import '../helper/theme_helper.dart';
import '../helper/validator.dart';
import 'home_screen.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _registerFormKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  bool verifyButton = false;

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;
  bool? error;
  String? verifylink;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: const HeaderWidget(
                  150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _registerFormKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    const BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade300,
                                  size: 80.0,
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(80, 80, 0, 0),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey.shade700,
                                  size: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        // ignore: avoid_unnecessary_containers
                        Container(
                          child: TextFormField(
                            controller: _nameTextController,
                            decoration: ThemeHelper().textInputDecoration(
                              'Nom et Prénom',
                            ),
                            validator: (value) => Validator.validateName(
                              name: value,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: _emailTextController,
                            decoration: ThemeHelper().textInputDecoration(
                                'é-mail*', 'Entrez votre é-mail'),
                            validator: (value) => Validator.validateEmail(
                              email: value,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: _passwordTextController,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Mot de passe*", "Tapez votre mot de passe"),
                            validator: (value) => Validator.validatePassword(
                              password: value,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValue = value!;
                                            state.didChange(value);
                                          });
                                        }),
                                    const Text(
                                      "J'accepte tous les termes et conditions.",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'Vous devez accepter les termes et conditions';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            onPressed: () async {
                              setState(() {
                                _isProcessing = true;
                              });

                              if (_registerFormKey.currentState!.validate()) {
                                User? user = await FirebaseAuthHelper
                                    .registerUsingEmailPassword(
                                  name: _nameTextController.text,
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text,
                                );

                                setState(() {
                                  _isProcessing = false;
                                });

                                if (user != null) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MainScreen(user: user),
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
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "S'inscrire".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30.0),
                        const Text(
                          "Ou créez un compte en utilisant les médias sociaux",
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        const SizedBox(height: 25.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: FaIcon(
                                FontAwesomeIcons.googlePlus,
                                size: 35,
                                color: HexColor("#EC2D2F"),
                              ),
                              onTap: () {},
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            GestureDetector(
                              child: FaIcon(
                                FontAwesomeIcons.facebook,
                                size: 35,
                                color: HexColor("#3E529C"),
                              ),
                              onTap: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ThemeHelper().alartDialog(
                                          "Facebook",
                                          "You tap on Facebook social icon.",
                                          context);
                                    },
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                        // _buildBody(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
