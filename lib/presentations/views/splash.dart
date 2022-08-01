import 'package:fit_tracker/presentations/views/home.dart';
import 'package:fit_tracker/presentations/views/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {

  static const String routeName = "/splash";

  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogin') != null) {
      if (prefs.getBool('isLogin') == true) {
        Navigator.pushNamedAndRemoveUntil(context, Home.routeName, (r) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, Login.routeName, (r) => false);
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(context, Login.routeName, (r) => false);
    }
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: const <Widget>[
            Text('Loading ...'),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

}