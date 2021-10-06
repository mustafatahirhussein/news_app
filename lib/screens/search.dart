import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/model_class/news_model.dart';
import 'package:http/http.dart' as http;

class SearchNews extends StatefulWidget {
  const SearchNews({Key key}) : super(key: key);

  @override
  _SearchNewsState createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
  var searchCnt = TextEditingController();

  List<News> news = List<News>();
  List<News> searchNews = List<News>();

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
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getTopStories().then((value) {
      setState(() {
        print("data val" + value.articles.length.toString());
        for (int i = 0; i < value.articles.length; i++) {
          news.add(value);
          searchNews = news;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            backgroundColor: AppTheme.color,
            title: TextFormField(
              controller: searchCnt,
              onChanged: (val) {
                val = val.toLowerCase();
                setState(() {
                  print("working");

                  searchNews = news.where((element) {

                    for(int i=0;i<element.articles.length;i++)

                      return element.articles.elementAt(i).title
                          .toLowerCase()
                          .contains(val.toLowerCase());
                  }).toList();
                });
              },
              style: TextStyle(fontSize: 15, color: AppTheme.color),
              decoration: InputDecoration(
                focusColor: AppTheme.color,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Color(0xffffffff),
                hintText: "Search",
                suffixIcon: InkWell(
                  child: Icon(Icons.search),
                  onTap: () {},
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
                    child: ListTile(
                      title: Text(news[i].articles[i].title),
                    ),
                  );
                },
              )
            : ListView.builder(
                itemCount: searchNews.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      title: Text(searchNews[i].articles[i].title),
                    ),
                  );
                },
              ));
  }
}
