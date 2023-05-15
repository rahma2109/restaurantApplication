import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restaurantapplication/screens/signup_screen.dart';

import '../helper/firebase_auth.dart';
import '../helper/header_widget.dart';
import '../helper/theme_helper.dart';
import '../helper/validator.dart';
import 'home.dart';
import 'home_screen.dart';
import 'main_screen.dart';

// ignore: use_key_in_widget_constructors
class LoginScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  String? errormsg;
  bool? error, showprogress;
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainScreen(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  double _headerHeight = 250;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: const EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      const Text(
                        'Connectez-vous à votre compte',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Container(
                        child: error == true ? errmsg(errormsg!) : Container(),
                      ),
                      const SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                // ignore: sort_child_properties_last
                                child: TextFormField(
                                  textDirection: TextDirection.ltr,
                                  controller: _emailTextController,
                                  focusNode: _focusEmail,
                                  validator: (value) => Validator.validateEmail(
                                    email: value,
                                  ),
                                  decoration: ThemeHelper().textInputDecoration(
                                      "Email", "Entrez votre email"),
                                ),

                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              const SizedBox(height: 30.0),
                              Container(
                                // ignore: sort_child_properties_last
                                child: TextFormField(
                                  controller: _passwordTextController,
                                  focusNode: _focusPassword,
                                  obscureText: true,
                                  validator: (value) =>
                                      Validator.validatePassword(
                                    password: value,
                                  ),
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Tapez votre mot de passe'),
                                ),

                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              const SizedBox(height: 15.0),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    "Mot de passe oublié?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(top: 20),
                                child: SizedBox(
                                  height: 60,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      _focusEmail.unfocus();
                                      _focusPassword.unfocus();

                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isProcessing = true;
                                        });

                                        User? user = await FirebaseAuthHelper
                                            .signInUsingEmailPassword(
                                          email: _emailTextController.text,
                                          password:
                                              _passwordTextController.text,
                                        );

                                        setState(() {
                                          _isProcessing = false;
                                        });

                                        if (user != null) {
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainScreen(user: user)),
                                          );
                                        } else {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: const Text(
                                                        'Informations incorrectes'),
                                                    content: const Text(
                                                        'les informations que vous avez fournies ne sont pas correctes,vérifier à nouveau. '),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () => {
                                                          _emailTextController
                                                              .clear(),
                                                          _passwordTextController
                                                              .clear(),
                                                          Navigator.pop(context,
                                                              'Cancel'),
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, 'OK'),
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  ));
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color.fromARGB(
                                                  211, 224, 67, 28)),
                                    ),
                                    child: const Text(
                                      'Se connecter',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              const Text(
                                "Ou connectez vous à votre  compte en utilisant les médias sociaux",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 11),
                                textAlign: TextAlign.center,
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
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(TextSpan(children: [
                                  const TextSpan(
                                      text: "Vous n'avez pas de compte ? "),
                                  TextSpan(
                                    text: 'Créer',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationPage()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade700),
                                  ),
                                ])),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget errmsg(String text) {
    //error message widget.
    return Container(
      // padding: EdgeInsets.all(15.00),
      margin: const EdgeInsets.only(bottom: 10.00),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.red,
        //  border: Border.all(Colors.red[300], width:2)
      ),
      child: Row(children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 6.00),
          child: const Icon(Icons.info, color: Colors.white),
        ), // icon for error message

        Text(text, style: const TextStyle(color: Colors.white, fontSize: 9)),
        //show error message text
      ]),
    );
  }
}
