//@dart=2.9
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/random.dart';
import 'package:news_app_jawan_pakistan/screens/favourite.dart';
import 'package:news_app_jawan_pakistan/screens/homepage.dart';
import 'package:news_app_jawan_pakistan/screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'about.dart';

class MainSection extends StatefulWidget {
  const MainSection({Key key}) : super(key: key);

  @override
  _MainSectionState createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
  int index = 0;
  SharedPreferences sharedPreferences;

  var tabList = [
    const HomePage(),
    const Favourites(),
    const Profile(),
    const AboutApp(),
  ];

  userSignedIn() async {
    sharedPreferences = await SharedPreferences.getInstance();

    String userStatus = sharedPreferences.get('uid') ?? "null";

    if (userStatus != "null") {
      return Badge(
        badgeColor: AppTheme.color,
        stackFit: StackFit.loose,
        badgeContent: Text(
          favCount.toString(),
          style: const TextStyle(color: Color(0xffffffff)),
        ),
        child: const Icon(Icons.favorite),
      );
    }
    if (userStatus == "null") {
      return const Icon(Icons.favorite);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (index != 0) {
          setState(() {
            index = 0;
          });
        } else {
          Future.value(false);
        }
        return null;
      },
      child: Scaffold(
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
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FutureBuilder(
                future: userSignedIn(),
                builder: (context, s) {
                  if (s.data != null) {
                    return s.data;
                  } else {
                    return Container();
                  }
                },
              ),
              label: 'Favourites',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: 'Profile',
            ),
            const BottomNavigationBarItem(
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
      ),
    );
  }
}
