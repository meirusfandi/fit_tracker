import 'package:firebase_core/firebase_core.dart';
import 'package:fit_tracker/presentations/views/home.dart';
import 'package:fit_tracker/presentations/views/login.dart';
import 'package:fit_tracker/presentations/views/profile.dart';
import 'package:fit_tracker/presentations/views/register.dart';
import 'package:fit_tracker/presentations/views/splash.dart';
import 'package:fit_tracker/presentations/views/update_data.dart';
import 'package:fit_tracker/presentations/views/update_profile.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
      routes: <String, WidgetBuilder> {
        Splash.routeName: (BuildContext context) => const Splash(),
        Login.routeName: (BuildContext context) => const Login(),
        Home.routeName: (BuildContext context) => const Home(),
        Register.routeName: (BuildContext context) => const Register(),
        UpdateData.routeName: (BuildContext context) => const UpdateData(),
        UpdateProfile.routeName: (BuildContext context) => const UpdateProfile(),
        Profile.routeName: (BuildContext context) => const Profile(),
      },
    );
  }
}
