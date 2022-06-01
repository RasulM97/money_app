import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_app/constant.dart';
import 'package:money_app/screens/home_screen.dart';

import 'info_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  Widget body = const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        inactiveColor: Colors.black54,
        activeColor: kPurpleColor,
        splashColor: kPurpleColor,
        splashRadius: 100,
        splashSpeedInMilliseconds: 450,
        elevation: 15,
        icons: const [
          CupertinoIcons.house_fill,
          CupertinoIcons.info_circle_fill,
        ],
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        leftCornerRadius: 15,
        rightCornerRadius: 15,
        activeIndex: currentIndex,
        onTap: (index) {
          setState(() {
            switch (index) {
              case 0:
                {
                  body = const HomeScreen();
                }
                break;
              case 1:
                {body = const InfoScreen();}
                break;
            }
            currentIndex = index;
          });
        },
      ),
      body: body,
    );
  }
}
