import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_tracker/data/model/tracker.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';
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

  final formKey = GlobalKey<FormState>();
  final TextEditingController _controllerWeight = TextEditingController();
  final TextEditingController _controllerHeight = TextEditingController();

  final Stream<QuerySnapshot> _trackerStream = FirebaseFirestore.instance.collection("tracker").orderBy("date", descending: true).snapshots();
  late TrackerData _tracker;

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
      body: StreamBuilder<QuerySnapshot>(
        stream: _trackerStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong!"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
              _tracker = TrackerData(
                  id: doc.id,
                  weight: data['weight'],
                  date: data['date'],
                  height: data['height']
              );
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 8,
                    )
                  ],
                ),
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(child: Text(doc.id[0]),),
                  title: Text(getCustomFormattedDateTime(DateTime.fromMillisecondsSinceEpoch(_tracker.date.seconds * 1000).toString(), "dd MMMM yyyy")),
                  subtitle: Text("Weight : ${data['weight']} Kg"),
                  trailing: Text(getCustomFormattedDateTime(DateTime.fromMillisecondsSinceEpoch(_tracker.date.seconds * 1000).toString(), "HH:mm:ss")),
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext dialogContext) {
                        return dialog("Edit Data Tracking", true, _tracker);
                      },
                    );
                  },
                ),
              );
            }).toList()
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext dialogContext) {
              return dialog("Add New Data Tracking", false, _tracker);
            },
          );
        },
      ),
    );
  }

  Widget dialog(String pageTitle, bool isUpdate, TrackerData data) {
    if (isUpdate) {
      _controllerHeight.text = data.height.toString();
      _controllerWeight.text = data.weight.toString();
    } else {
      _controllerHeight.text = "";
      _controllerWeight.text = "";
    }
    return AlertDialog(
      title: Text(pageTitle),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _controllerWeight,
              decoration: const InputDecoration(
                labelText: "Enter Weight",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _controllerHeight,
              decoration: const InputDecoration(
                labelText: "Enter Height",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: actionButton(isUpdate, data.id),
    );
  }

  @override
  void dispose() {
    _controllerHeight.dispose();
    _controllerWeight.dispose();
    super.dispose();
  }

  List<Widget> actionButton(bool isUpdate, String docId) {
    if (isUpdate) {
      return [
        ElevatedButton(child: const Text("Update"), onPressed: (){ return updateData(docId); }),
        ElevatedButton(child: const Text("Delete"), onPressed: (){ return deleteData(docId); }),
        ElevatedButton(child: const Text("Back"), onPressed: cancel,)
      ];
    } else {
      return [
        ElevatedButton(child: const Text("Save"), onPressed: insertData),
        ElevatedButton(child: const Text("Back"), onPressed: cancel,)
      ];
    }
  }

  void insertData() async {
    if (_controllerWeight.text.isNotEmpty && _controllerHeight.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("tracker").add(
          {
            "id": getRandomString(10),
            "weight": _controllerWeight.text,
            "height": _controllerHeight.text,
            "date": Timestamp.now()
          }
      ).then((value) => const SnackBar(content: Text("Success")));
      Navigator.pop(context);
    }
  }

  void updateData(String docId) async {
    if (_controllerWeight.text.isNotEmpty && _controllerHeight.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection("tracker").doc(docId).update(
          {
            "weight": _controllerWeight.text,
            "height": _controllerHeight.text
          }
      ).then((value) => const SnackBar(content: Text("Success")))
      .catchError((onError) => SnackBar(content: Text(onError.toString())));
      Navigator.pop(context);
    }
  }

  void deleteData(String docId) async {
    await FirebaseFirestore.instance.collection("tracker").doc(docId).delete()
        .then((value) => const SnackBar(content: Text("Success")))
        .catchError((onError) => SnackBar(content: Text(onError.toString())));
    Navigator.pop(context);
  }

  void cancel() async {
    Navigator.pop(context);
  }
}