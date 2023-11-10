
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/random.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/route_and_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'news_detail.dart';

class Favourites extends StatefulWidget {
  final VoidCallback? onP1Badge;

  const Favourites({Key? key, this.onP1Badge}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  late SharedPreferences sharedPreferences;

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
                textAlign: TextAlign.center,
                style: AppTheme.splashStyle.copyWith(fontSize: 24),
              ),
            )
          : ListView.builder(
              itemCount: favList.toSet().toList().length,
              itemBuilder: (context, i) {
                var data = favList.toSet().toList();

                if (favList.isEmpty) {
                  return Center(
                    child: Text(
                      "You have not added any favorites!!",
                      textAlign: TextAlign.center,
                      style: AppTheme.splashStyle.copyWith(fontSize: 24),
                    ),
                  );
                }

                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Card(
                    color: Colors.red[400],
                    elevation: 4,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: FaIcon(
                          FontAwesomeIcons.trashAlt,
                          color: Color(0Xffffffff),
                        ),
                      ),
                    ),
                  ),
                  key: UniqueKey(),
                  onDismissed: (_) {
                    setState(() {
                      favList.removeAt(i);
                      favCount--;
                    });
                  },
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: data[i].urlToImage,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, _) =>
                            AppTheme.loader(const Color(0xffffffff)),
                      ),
                      title: Column(
                        children: [
                          Text(
                            data[i].title,
                            style: style,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              (-data[i]
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
                                  article: data[i],
                                )));
                      },
                    ),
                  ),
                );
              },
            );
    }
    if (userID == "null") {
      return RouteMsg.routeAndMessage(context,
          "You must Sign up or Login to add News in your Favorites feed!!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.color,
        centerTitle: true,
        title: Text(
          "Your Favorites",
          style: AppTheme.appBarStyle,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/back.jpg"),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: getFavorites(),
              builder: (context, s) {
                if (s.data != null) {
                  return s.data as Widget;
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
