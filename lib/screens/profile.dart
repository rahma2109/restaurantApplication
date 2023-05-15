import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapplication/providers/app_provider.dart';
import 'package:restaurantapplication/screens/login_screen.dart';
import 'package:restaurantapplication/screens/splash.dart';
import 'package:restaurantapplication/util/const.dart';

class Profile extends StatefulWidget {
  final User? user;
  const Profile({Key? key, this.user}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Image.asset(
                    "assets/cm4.jpeg",
                    fit: BoxFit.cover,
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                Expanded(
                  // ignore: sort_child_properties_last
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Nom: ${_currentUser.displayName}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Email :${_currentUser.email}",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  flex: 3,
                ),
              ],
            ),
            const Divider(),
            Container(height: 15.0),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Account Information".toUpperCase(),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: const Text(
                "Full Name",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "${_currentUser.displayName}",
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.edit,
                  size: 20.0,
                ),
                onPressed: () {},
                tooltip: "Edit",
              ),
            ),
            ListTile(
              title: const Text(
                "Email",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "${_currentUser.email}",
              ),
            ),
            const ListTile(
              title: Text(
                "Phone",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "+1 816-926-6241",
              ),
            ),
            const ListTile(
              title: Text(
                "Address",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "1278 Loving Acres RoadKansas City, MO 64110",
              ),
            ),
            const ListTile(
              title: Text(
                "Gender",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "Female",
              ),
            ),
            const ListTile(
              title: Text(
                "Date of Birth",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                "April 9, 1995",
              ),
            ),
            // MediaQuery.of(context).platformBrightness == Brightness.dark
            //     ? const SizedBox()
            //     : ListTile(
            //         title: const Text(
            //           "Dark Theme",
            //           style: TextStyle(
            //             fontSize: 17,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //         trailing: Switch(
            //           value: Provider.of<AppProvider>(context).theme ==
            //                   Constants.lightTheme
            //               ? false
            //               : true,
            //           onChanged: (v) async {
            //             if (v) {
            //               Provider.of<AppProvider>(context, listen: false)
            //                   .setTheme(Constants.darkTheme, "dark");
            //             } else {
            //               Provider.of<AppProvider>(context, listen: false)
            //                   .setTheme(Constants.lightTheme, "light");
            //             }
            //           },
            //           activeColor: Theme.of(context).accentColor,
            // ),
            // ),
          ],
        ),
      ),
    );
  }
}
