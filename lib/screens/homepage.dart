
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/random.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/route_and_message.dart';
import 'package:news_app_jawan_pakistan/model_class/news_model.dart';
import 'package:news_app_jawan_pakistan/screens/drawer.dart';
import 'package:news_app_jawan_pakistan/screens/news_detail.dart';
import 'package:news_app_jawan_pakistan/screens/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future stories, news;

  getNews() async {
    try {
      http.Response response = await http.get(Uri.parse(
          "https://newsapi.org/v2/everything?q=Artificial Intelligence&from=2021-10-06&sortBy=popularity&apiKey=51bd3998ac014735ba523e957b32e3c1"));

      if (200 == response.statusCode) {
        return newsFromJson(response.body);
      } else {
        return News();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getTopStories() async {
    try {
      http.Response response = await http.get(Uri.parse(
          "https://newsapi.org/v2/top-headlines?country=us&apiKey=51bd3998ac014735ba523e957b32e3c1"));

      if (200 == response.statusCode) {
        return newsFromJson(response.body);
      } else {
        return News();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    stories = getTopStories();
    news = getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        drawer: DrawerContent(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            backgroundColor: AppTheme.color,
            centerTitle: true,
            title: Text(
              "News App",
              style: AppTheme.splashStyle.copyWith(fontSize: 24),
            ),
            actions: [
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.search,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchNews()));
                },
              ),
              PopupMenuButton<int>(
                icon: const FaIcon(
                  FontAwesomeIcons.ellipsisV,
                  size: 20,
                ),
                onSelected: (item) => handleClick(item),
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(value: 0, child: Text('Exit App')),
                ],
              ),
            ],
            bottom: TabBar(
              indicatorColor: const Color(0xffffffff),
              tabs: [
                Tab(
                  child: Text(
                    "Top Stories",
                    style: AppTheme.appBarStyle,
                  ),
                ),
                Tab(
                  child: Text(
                    "News",
                    style: AppTheme.appBarStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            //Top Stories
            FutureBuilder<dynamic>(
              future: stories,
              builder: (context, s) {
                if (s.connectionState == ConnectionState.done) {
                  var data = s.data.articles;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      final now = DateTime.now();

                      return Card(
                        elevation: 4,
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: data[i].urlToImage ??
                                "https://www.wpclipart.com/people/faces/anonymous/photo_not_available_BW.png",
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                            placeholder: (context, _) =>
                                AppTheme.loader(const Color(0xff260666)),
                          ),
                          title: Column(
                            children: [
                              Text(
                                data[i].title,
                                style: style,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      (-data[i]
                                                  .publishedAt
                                                  .difference(now)
                                                  .inHours)
                                              .toString() +
                                          " hrs ago",
                                      style: style.copyWith(fontSize: 9),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () {
                                        RouteMsg.userExistCheck().then((value) {
                                          if (value == "null") {
                                            RouteMsg.msg(
                                                "Sign up or Login to add this news in fav");
                                          }
                                          if (value != "null") {
                                            favList.add(data[i]);

                                            setState(() {
                                              favCount++;
                                            });
                                          }
                                        });
                                      },
                                      child: const FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        size: 20,
                                        color: AppTheme.color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NewsInfo(
                                      index: 0,
                                      article: s.data.articles[i],
                                    )));
                          },
                        ),
                      );
                    },
                  );
                }
                return AppTheme.loader(const Color(0xff260666));
              },
            ),

            //News
            FutureBuilder<dynamic>(
              future: news,
              builder: (context, s) {
                if (s.connectionState == ConnectionState.done) {
                  var data = s.data.articles;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      final now = DateTime.now();

                      return Card(
                        elevation: 4,
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: data[i].urlToImage ??
                                "https://www.wpclipart.com/people/faces/anonymous/photo_not_available_BW.png",
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                            placeholder: (context, _) =>
                                AppTheme.loader(const Color(0xff260666)),
                          ),
                          title: Column(
                            children: [
                              Text(
                                data[i].title,
                                style: style,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      (-data[i]
                                                  .publishedAt
                                                  .difference(now)
                                                  .inHours)
                                              .toString() +
                                          " hrs ago",
                                      style: style.copyWith(fontSize: 9),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () {
                                        RouteMsg.userExistCheck().then((value) {
                                          if (value == "null") {
                                            RouteMsg.msg(
                                                "Sign up or Login to add this news in fav");
                                          }
                                          if (value != "null") {
                                            favList.add(data[i]);

                                            setState(() {
                                              favCount++;
                                            });
                                          }
                                        });
                                      },
                                      child: const FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        size: 20,
                                        color: AppTheme.color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NewsInfo(
                                      index: 1,
                                      article: s.data.articles[i],
                                    )));
                          },
                        ),
                      );
                    },
                  );
                }
                return AppTheme.loader(const Color(0xff260666));
              },
            ),
          ],
        ),
      ),
    );
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        SystemNavigator.pop(animated: true);
        break;
    }
  }
}
