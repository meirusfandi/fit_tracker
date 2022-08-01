import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/user_entity.dart';
import 'home.dart';

class Profile extends StatefulWidget {

  static const String routeName = "/profile";

  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late UserEntity userEntity = UserEntity(
      id: _auth.currentUser!.uid,
      firstName: _auth.currentUser!.displayName!,
      lastName: _auth.currentUser!.displayName!,
      email: _auth.currentUser!.email!,
      imageUrl: _auth.currentUser!.photoURL!,
      gender: "Male",
      dateOfBirth: "11-05-1996",
      height: '168'
  );

  void fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      User? users = _auth.currentUser;
      userEntity = UserEntity(
          id: users!.uid,
          firstName: prefs.getString("name") ?? "",
          lastName: prefs.getString("name") ?? "",
          email: prefs.getString("email") ?? "",
          imageUrl: prefs.getString("imageUrl") ?? "",
          gender: prefs.getString("gender") ??"Male",
          dateOfBirth: prefs.getString("dateOfBirth") ??"11-05-1996",
          height: prefs.getString("imageUrl") ??'168'
      );
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  void initState() {
    userEntity = UserEntity.empty();
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Container(
        child: Column(
          children: [
            Text(userEntity.id),
            Text(userEntity.email),
            Text(userEntity.firstName),
            Text(userEntity.lastName),
            Text(userEntity.imageUrl),
            Text(userEntity.gender),
            Text(userEntity.dateOfBirth),
            Text(userEntity.height),
          ],
        ),
      ),
    );
  }

}