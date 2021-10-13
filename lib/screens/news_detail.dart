//@dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/model_class/news_model.dart';

class NewsInfo extends StatelessWidget {
  final Article article;
  final int index;

  const NewsInfo({Key key, this.article, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.color,
        centerTitle: true,
        title: Text(index == 0 ? "Top Stories" : "News"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: article.urlToImage ??
                  "https://www.wpclipart.com/people/faces/anonymous/photo_not_available_BW.png",
              width: double.infinity,
              height: 270,
              fit: BoxFit.cover,
              placeholder: (context, _) =>
                  AppTheme.loader(const Color(0xff260666)),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                article.description,
                style: style.copyWith(fontSize: 13),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                article.title,
                style: style.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(2.5),
                child: Text(
                  article.author == null ? '' : "By " + article.author,
                  style: style.copyWith(fontSize: 12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Text(
                    (-article.publishedAt.difference(DateTime.now()).inHours)
                            .toString() +
                        " hrs ago",
                    style: style.copyWith(fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 20,
                      width: 2,
                      color: const Color(0xff000000),
                    ),
                  ),
                  Text(article.source.name),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(article.content ?? ''),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Copyright 2021 News App",
                style:
                    style.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
