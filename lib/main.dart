import 'package:flutter/material.dart';
import 'package:podtastic/WebPodcasts/podcast.dart';
import 'package:podtastic/WebPodcasts/itunes_podcasts.dart';
import 'package:podtastic/my_podcasts_page.dart';
import 'package:podtastic/my_podcasts_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    return MyPodcastsProvider(
      child: MaterialApp(
        title: 'Podtastic',
        theme: ThemeData(
          primaryColor: Colors.blue,
          backgroundColor: Colors.white,
          primaryTextTheme: TextTheme(
            body1: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
            ),
            body2: TextStyle(
              color: Colors.grey,
              fontSize: 10.0,
            )
          ),
        ),
        home: MyPodcastsPage()
      ),
    );
  }

}

