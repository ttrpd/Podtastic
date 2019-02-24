import 'package:flutter/material.dart';
import 'package:podtastic/WebPodcasts/itunes_podcast.dart';
import 'package:podtastic/WebPodcasts/itunes_podcasts.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  ItunesPodcasts itunesPodcasts = ItunesPodcasts();
  @override
  Widget build(BuildContext context) {
    SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    return MaterialApp(
      title: 'Podtastic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Podtastic'),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          color: Colors.white,
          // child: ListView.builder(
          //   itemCount: ,
          // ),
          child: IconButton(
            icon: Icon(Icons.playlist_add, color: Colors.black,),
            onPressed: ItunesPodcast('https://itunes.apple.com/us/podcast/99-invisible/id394775318?mt=2').update,
          ),
        ),
      ),
    );
  }

  void storeTest() async
  {
    print('store');
    var dbPath = await getDatabasesPath();
    String path = dbPath + 'podcasts.db';
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Podcasts (id INTEGER PRIMARY KEY, name TEXT)');
      },
    );

    db.transaction((trns) async {
      trns.rawInsert('INSERT INTO Podcasts(id, name) VALUES(1, "pod1")');
      trns.rawInsert('INSERT INTO Podcasts(id, name) VALUES(2, "pod2")');
      trns.rawInsert('INSERT INTO Podcasts(id, name) VALUES(3, "pod3")');
    });

  }

  void retrieveTest() async
  {
    print('retrieve');
    var dbPath = await getDatabasesPath();
    String path = dbPath + 'podcasts.db';
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Podcasts (id INTEGER PRIMARY KEY, name TEXT)');
      },
    );

    List<Map> recs = await db.rawQuery('SELECT * FROM Podcasts');
    print(recs);
    

  }
}

