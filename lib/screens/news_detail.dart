//@dart=2.9
import 'package:flutter/material.dart';
import 'package:news_app_jawan_pakistan/Theme%20&%20Stuff/app_theme.dart';
import 'package:news_app_jawan_pakistan/model_class/news_model.dart';

class NewsInfo extends StatelessWidget {

  final Article article;
  final int index;

  const NewsInfo({Key key,this.article,this.index}) : super(key: key);

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
            Image.network(article.urlToImage ?? "https://www.wpclipart.com/people/faces/anonymous/photo_not_available_BW.png",width: double.infinity,height: 270,fit: BoxFit.cover,),
            Text(article.description,style: style.copyWith(fontSize: 13),),


            Text(article.title,style: style.copyWith(fontWeight: FontWeight.bold),),

            Align(
              alignment: Alignment.topRight,
              child: Text(article.author== null ? '' : "By "+ article.author,style: style.copyWith(fontSize: 12),),
            ),



            Row(
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

            Text(article.content ?? ''),

            Align(
              alignment: Alignment.bottomCenter,
              child: Text("Copyright 2021 News App",style: style.copyWith(fontWeight: FontWeight.bold,fontSize: 15),),
            ),
          ],
        ),
      ),
    );
  }
}
