//@dart=2.9
import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_btn.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/random.dart';
import 'package:news_app_jawan_pakistan/screens/login.dart';
import 'package:news_app_jawan_pakistan/screens/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'news_detail.dart';

class Favourites extends StatefulWidget {
  final VoidCallback onP1Badge;

  const Favourites({Key key, this.onP1Badge}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  SharedPreferences sharedPreferences;

  getFavorites() async {
    var style = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );

    sharedPreferences = await SharedPreferences.getInstance();

    String userID = sharedPreferences.getString("uid") ?? "null";

    debugPrint(userID);

    if (userID != "null") {
      return favList.isEmpty
          ? Center(
              child: Text(
                "You have not added any favorites!!",
                style: AppTheme.splashStyle
                    .copyWith(color: Colors.black, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favList.length,
              itemBuilder: (context, i) {
                return Card(
                  elevation: 4,
                  child: ListTile(
                    leading: Image.network(
                      favList[i].urlToImage,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    title: Column(
                      children: [
                        Text(
                          favList[i].title,
                          style: style,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            (-favList[i]
                                        .publishedAt
                                        .difference(DateTime.now())
                                        .inHours)
                                    .toString() +
                                " hrs ago",
                            style: style.copyWith(fontSize: 9),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NewsInfo(
                                index: 1,
                                article: favList[i],
                              )));
                    },
                  ),
                );
              },
            );
    }
    if (userID == "null") {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You have not registered!!\nSign up or Login",
              style: AppTheme.splashStyle
                  .copyWith(color: Colors.black, fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: AppButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                text: "Sign in",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: AppButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SignUp()));
                },
                text: "Sign Up",
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.color,
        centerTitle: true,
        title: const Text("Your Favorites"),
      ),
      body: FutureBuilder(
          future: getFavorites(),
          builder: (context, s) {
            if (s.data != null) {
              return s.data;
            }
            return Container();
          }),
    );
  }
}
