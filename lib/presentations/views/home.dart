import 'package:fit_tracker/presentations/views/profile.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';

class Home extends StatefulWidget {

  static const String routeName = "/home";
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static final List<Widget> _widgetOptions = <Widget> [
    const Dashboard(),
    const Profile()
  ];

  int _currentIndex = 0;

  void _onItemTap(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: _onItemTap,
        currentIndex: _currentIndex,
      ),
    );
  }

}