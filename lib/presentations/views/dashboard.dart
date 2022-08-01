import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_tracker/data/model/tracker.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Dashboard extends StatefulWidget {

  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _actionToLogout() async {
    try {
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, Login.routeName, (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Stream<List<Tracker>> _fetchTracker() => FirebaseFirestore.instance
      .collection("tracker")
      .snapshots()
      .map((snapshot) => snapshot.docs.map((e) => Tracker.fromJson(e.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            onPressed: () {
              _actionToLogout();
            },
              icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: StreamBuilder<List<Tracker>>(
        stream: _fetchTracker(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tracker = snapshot.data;
            return ListView(
              children: tracker!.map(buildTracker).toList(),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
  
  Widget buildTracker(Tracker tracker) => Container(
    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
    padding: const EdgeInsets.all(8.0),
    decoration: const BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.black12)
      ],
      color: Colors.white
    ),
    child: ListTile(
      leading: CircleAvatar(child: Text(tracker.date),),
      title: Text(tracker.date),
      subtitle: Text(tracker.weight),
    ),
  );
}