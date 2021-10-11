import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/model_class/news_model.dart';
import 'package:http/http.dart' as http;

import 'news_detail.dart';

class SearchNews extends StatefulWidget {
  const SearchNews({Key key}) : super(key: key);

  @override
  _SearchNewsState createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
  var searchCnt = TextEditingController();

  List<News> news = [];
  List<News> searchNews = [];

  bool _loaded = false;

  Future<News> getTopStories() async {
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
      return News();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getTopStories().then((value) {
      setState(() {
        debugPrint("data val" + value.articles.length.toString());
        for (int i = 0; i < value.articles.length; i++) {
          news.add(value);
          searchNews = news;
        }
        _loaded = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: AppTheme.color,
          centerTitle: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          )),
          title: TextFormField(
            controller: searchCnt,
            style: const TextStyle(fontSize: 15, color: AppTheme.color),
            decoration: InputDecoration(
              focusColor: AppTheme.color,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: const Color(0xffffffff),
              hintText: "You can search via News Title, Author & Source",
              suffixIcon: InkWell(
                child: const Icon(Icons.search),
                onTap: () {
                  setState(() {
                    debugPrint("working");

                    searchNews = news.where((u) {
                      for (int i = 0; i < u.articles.length; i++) {
                        return (u.articles
                                .elementAt(i)
                                .title
                                .toLowerCase()
                                .contains(searchCnt.text.toLowerCase())) ||
                            (u.articles
                                .elementAt(i)
                                .source
                                .name
                                .toLowerCase()
                                .contains(searchCnt.text.toLowerCase())) ||
                            (u.articles
                                .elementAt(i)
                                .author
                                .toLowerCase()
                                .contains(searchCnt.text.toLowerCase()));
                      }
                      return true;
                    }).toList();
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: searchNews.isNotEmpty
          ? ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, i) {
                return Card(
                  elevation: 4,
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: news[i].articles[i].urlToImage ??
                          "https://www.wpclipart.com/people/faces/anonymous/photo_not_available_BW.png",
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, _) =>
                          AppTheme.loader(const Color(0xff260666)),
                    ),
                    title: Column(
                      children: [
                        Text(
                          news[i].articles[i].title,
                          style: style,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            (-news[i]
                                        .articles[i]
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
                                index: 0,
                                article: news[i].articles[i],
                              )));
                    },
                  ),
                );
              },
            )
          : !_loaded
              ? AppTheme.loader(const Color(0xff260666))
              : ListView.builder(
                  itemCount: searchNews.length,
                  itemBuilder: (context, i) {
                    return Card(
                      elevation: 4,
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: searchNews[i].articles[i].urlToImage ??
                              "https://www.wpclipart.com/people/faces/anonymous/photo_not_available_BW.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, _) =>
                              AppTheme.loader(const Color(0xff260666)),
                        ),
                        title: Column(
                          children: [
                            Text(
                              searchNews[i].articles[i].title,
                              style: style,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                (-searchNews[i]
                                            .articles[i]
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
                                    index: 0,
                                    article: searchNews[i].articles[i],
                                  )));
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
