//@dart=2.9
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/random.dart';
import 'package:news_app_jawan_pakistan/screens/favourite.dart';
import 'package:news_app_jawan_pakistan/screens/homepage.dart';
import 'package:news_app_jawan_pakistan/screens/profile.dart';

import 'about.dart';

class MainSection extends StatefulWidget {
  const MainSection({Key key}) : super(key: key);

  @override
  _MainSectionState createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
  int index = 0;

  var tabList = [
    const HomePage(),
    const Favourites(),
    const Profile(),
    const AboutApp(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabList[index],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppTheme.color,
        unselectedItemColor: Colors.grey,
        iconSize: 26,
        currentIndex: index,
        unselectedLabelStyle: const TextStyle(
          color: Colors.grey,
        ),
        showUnselectedLabels: true,
        elevation: 5,
        enableFeedback: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              badgeColor: AppTheme.color,
              stackFit: StackFit.loose,
              badgeContent: Text(
                favCount.toString(),
                style: TextStyle(color: Color(0xffffffff)),
              ),
              child: Icon(Icons.favorite),
            ),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info,
            ),
            label: 'Info',
          ),
        ],
        onTap: (i) {
          if (mounted) {
            setState(() {
              index = i;
            });
          }
        },
      ),
    );
  }
}
