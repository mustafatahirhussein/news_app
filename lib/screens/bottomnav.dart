import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as b;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/random.dart';
import 'package:news_app_jawan_pakistan/screens/favourite.dart';
import 'package:news_app_jawan_pakistan/screens/homepage.dart';
import 'package:news_app_jawan_pakistan/screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'about.dart';

class MainSection extends StatefulWidget {
  const MainSection({Key? key}) : super(key: key);

  @override
  _MainSectionState createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
  int index = 0;
  late SharedPreferences sharedPreferences;

  var tabList = [
    const HomePage(),
    const Favourites(),
    const Profile(),
    const AboutApp(),
  ];

  userSignedIn() async {
    sharedPreferences = await SharedPreferences.getInstance();

    String userStatus = sharedPreferences.getString('uid') ?? "null";

    if (userStatus != "null") {
      return b.Badge(
        badgeColor: AppTheme.color,
        stackFit: StackFit.loose,
        badgeContent: Text(
          favCount.toString(),
          style: const TextStyle(color: Color(0xffffffff)),
        ),
        child: const FaIcon(FontAwesomeIcons.solidHeart),
      );
    }
    if (userStatus == "null") {
      return const FaIcon(FontAwesomeIcons.solidHeart);
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
        return Future.value(false);
      },
      child: Scaffold(
        body: tabList[index],
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          selectedItemColor: AppTheme.color,
          unselectedItemColor: Colors.grey,
          iconSize: 26,
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          unselectedLabelStyle:
              AppTheme.appBarStyle.copyWith(fontSize: 15, color: Colors.grey),
          selectedLabelStyle: AppTheme.appBarStyle
              .copyWith(fontSize: 15, color: AppTheme.color),
          showUnselectedLabels: false,
          elevation: 5,
          enableFeedback: true,
          items: [
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FutureBuilder(
                future: userSignedIn(),
                builder: (context, s) {
                  if (s.data != null) {
                    return s.data as Widget;
                  } else {
                    return Container();
                  }
                },
              ),
              label: 'Favourites',
            ),
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.userAlt),
              label: 'Profile',
            ),
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.infoCircle),
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
