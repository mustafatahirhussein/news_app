//@dart=2.9
import 'package:flutter/material.dart';

class Favourites extends StatefulWidget {
  final VoidCallback onP1Badge;

  const Favourites({Key key,this.onP1Badge}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Fav"),
      ),
    );
  }
}
