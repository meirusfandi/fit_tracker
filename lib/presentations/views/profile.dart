import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_tracker/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/user_entity.dart';

class Profile extends StatefulWidget {
  static const String routeName = "/profile";

  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

enum Gender{
  Male, Female, Others
}

class _ProfileState extends State<Profile> {

  late SharedPreferences prefs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _userId = "";
  void fetchUser() async {
    prefs = await SharedPreferences.getInstance();
    try {
      User? users = _auth.currentUser;
      if (users != null) {
        _userId = users.uid;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Gender _gender = Gender.Male;

  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  late UserEntity _userEntity;
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerHeight = TextEditingController();
  final TextEditingController _controllerDateOfBirth = TextEditingController();
  final TextEditingController _controllerGender = TextEditingController();

  @override
  void dispose() {
    _controllerHeight.dispose();
    _controllerName.dispose();
    _controllerGender.dispose();
    _controllerDateOfBirth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference _userReferences = FirebaseFirestore.instance.collection("users");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _userReferences.doc(_auth.currentUser!.uid).get(),
        builder: (context, snapshot) {
          print(_auth.currentUser!.uid);
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went Error!"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          _userEntity = UserEntity(
              id: snapshot.data!.id,
              name: data['name'],
              email: data['email'],
              gender: data['gender'],
              dateOfBirth: data['birth_date'].toString(),
              height: data['height'].toString()
          );
          return SingleChildScrollView(
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              verticalDirection: VerticalDirection.down,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(Icons.person, size: 64.0,),
                    )
                ),
                Center(
                  child: Text(_userEntity.name, style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 8.0),
                Center(
                  child: Text(_userEntity.email, style: const TextStyle(fontSize: 14)),
                ),
                const SizedBox(height: 8.0),
                Center(
                  child: Text(_userEntity.gender, style: const TextStyle(fontSize: 14)),
                ),
                const SizedBox(height: 8.0),
                Center(
                  child: Text(getCustomFormattedDateTime(DateFormat('dd/MM/yyyy').parse(_userEntity.dateOfBirth).toString(), "dd MMMM yyyy"), style: const TextStyle(fontSize: 14)),
                ),
                const SizedBox(height: 20.0),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: const Text('Update User', style: TextStyle(fontSize: 20))
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    controller: _controllerName,
                    decoration: const InputDecoration(
                      labelText: "Enter Full Name",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    controller: _controllerHeight,
                    decoration: const InputDecoration(
                      labelText: "Enter Height",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const Text(
                    "Choose Gender"
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Radio(
                          value: Gender.Male,
                          groupValue: _gender,
                          activeColor: Colors.blue,
                          onChanged: (onChanged) {
                            setState(() {
                              _gender = Gender.Male;
                              _controllerGender.text = "Male";
                            });
                          }),
                      const Text("Male"),
                      Radio(
                          value: Gender.Female,
                          groupValue: _gender,
                          activeColor: Colors.blue,
                          onChanged: (onChanged) {
                            setState(() {
                              _gender = Gender.Female;
                              _controllerGender.text = "Female";
                            });
                          }),
                      const Text("Female"),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    controller: _controllerDateOfBirth,
                    decoration: const InputDecoration(
                      labelText: "Enter Date of Birth",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(height: 8.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      updateProfile(_userEntity.id);
                    },
                    child: const Text("Update Profile")
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void updateProfile(String userId) async{
    if (_controllerName.text.isNotEmpty && _controllerHeight.text.isNotEmpty &&  _controllerDateOfBirth.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection("users").doc(_userId).update(
          {
            "name": _controllerName.text,
            "height": _controllerHeight.text,
            "birth_date": _controllerDateOfBirth.text,
            "gender": _gender.name
          }
      ).then((value) => const SnackBar(content: Text("Success"))).catchError((onError) => SnackBar(content: Text(onError.toString())));
    }
  }
}
