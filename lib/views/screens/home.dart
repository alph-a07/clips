import 'package:flutter/material.dart';

import '../../values.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: backgroundColor,
        selectedItemColor: buttonColor,
        unselectedItemColor: Colors.white,
        currentIndex: pageIdx,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 28,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 28,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
              size: 28,
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 28,
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: pages[pageIdx],
    );
  }
}
