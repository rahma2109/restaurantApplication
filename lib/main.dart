import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapplication/providers/app_provider.dart';
import 'package:restaurantapplication/screens/splash.dart';
import 'package:restaurantapplication/util/const.dart';
import 'package:restaurantapplication/providers/app_provider.dart';

import 'util/const.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget? child) {
        return MaterialApp(
          key: appProvider.key,
          debugShowCheckedModeBanner: false,
          navigatorKey: appProvider.navigatorKey,
          title: Constants.appName,
          theme: appProvider.theme,
          darkTheme: Constants.darkTheme,
          home: SplashScreen(),
        );
      },
    );
  }
}
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:restaurantapplication/screens/register.dart';

// import 'screens/login_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firebase',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         brightness: Brightness.light,
//         primarySwatch: Colors.orange,
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             textStyle: const TextStyle(
//               fontSize: 24.0,
//             ),
//             padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
//           ),
//         ),
//         textTheme: TextTheme(
//           headline1: TextStyle(
//             fontSize: 46.0,
//             color: Colors.blue.shade700,
//             fontWeight: FontWeight.w500,
//           ),
//           bodyText1: const TextStyle(fontSize: 18.0),
//         ),
//       ),
//       home: RegisterScreen(),
//     );
//   }
// }
