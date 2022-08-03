import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_tracker/presentations/views/home.dart';
import 'package:fit_tracker/presentations/views/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {

  static const String routeName = "/login";

  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signInWithEmailAndPassword() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', true);

    try {
      UserCredential users = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text
      );
      prefs.setBool('isLogin', true);
      prefs.setString("id", users.user!.uid);
      prefs.setString("email", users.user!.email!);
      prefs.setString("name", users.user!.email!);

      insertData(users.user!.uid, _emailController.text);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
              (route) => false
      );
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void insertData(userId, email) async {
    DocumentReference reference = FirebaseFirestore.instance.collection("users").doc(userId);
    reference.set({
      "height": 0,
      "name": "",
      "email": email,
      "birth_date": DateTime.now(),
      "gender": "Male"
    }).then((value) => const SnackBar(content: Text("Success")));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fit Tracker App"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: const Text(
                'Sign In to Fit Tracker',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    enabled: true,
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    labelText: 'Email'
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    enabled: true,
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.vpn_key),
                    border: OutlineInputBorder(),
                    labelText: 'Password'
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _signInWithEmailAndPassword();
                  }
                },
                child: const Text('Login'),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text('Don\'t have account ? ',
                style: TextStyle(color: Colors.red),
              ),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, Register.routeName, (r) => false);
                  },
                  child: const Text("Register Here")
              ),
            )
          ],
        )
      ),
    );
  }

}