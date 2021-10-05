//@dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_jawan_pakistan/model_class/news_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getNews() async {
    try {
      http.Response response = await http.get(Uri.parse(
          "https://newsapi.org/v2/everything?q=Artificial Intelligence&from=2021-10-05&sortBy=popularity&apiKey=51bd3998ac014735ba523e957b32e3c1"));

      if (200 == response.statusCode) {
        return newsFromJson(response.body);
      } else {
        return News();
      }
    }
    catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: getNews(),
        builder: (context,s) {
          if(s.connectionState == ConnectionState.done){

            var data = s.data.articles;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context,i) {

                final now = DateTime.now();

                return Card(
                  child: ListTile(
                    leading: Image.network(data[i].urlToImage,height: 100,width: 100,),
                    title: Text(data[i].title),
                    subtitle: Column(
                      children: [
                        Text(data[i].description),
                        Text((-data[i].publishedAt.difference(now).inHours).toString()+" hrs ago"),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}
