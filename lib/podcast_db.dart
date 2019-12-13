import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podtastic/podcast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class PodcastDB extends InheritedWidget
{
  Future<Database> _db;

  PodcastDB({Key key, Widget child}) : super(key: key, child: child)
  {
    if(child != null)
      _db = initDB();

    _db = openDatabase(
      "TestDB.db",
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute("PRAGMA foreign_keys = ON");
        await db.execute(
          "CREATE TABLE Podcasts ("
          "id INTEGER PRIMARY KEY,"
          "externalID INTEGER,"
          "title TEXT,"
          "artLink TEXT,"
          "art TEXT,"
          "thumbnailLink TEXT,"
          "feedLink TEXT,"
          "artistName TEXT,"
          "description TEXT"
          ")"
        );
        await db.execute(
          "CREATE TABLE Episodes ("
          "id INTEGER PRIMARY KEY,"
          "podcastId INTEGER,"
          "link TEXT,"
          "name TEXT,"
          "epDesc TEXT,"
          "subtitle TEXT,"
          "number INTEGER,"
          "played BIT,"
          "duration INTEGER,"
          "released TEXT,"
          "FOREIGN KEY(podcastId) REFERENCES Podcasts(id)"
          ")"
        );
      }
    );
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static PodcastDB of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PodcastDB) as PodcastDB);
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "PodcastDB.db";
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute("PRAGMA foreign_keys = ON");
        await db.execute(
          "CREATE TABLE Podcasts ("
          "id INTEGER PRIMARY KEY,"
          "externalID INTEGER,"
          "title TEXT,"
          "artLink TEXT,"
          "art TEXT,"
          "thumbnailLink TEXT,"
          "feedLink TEXT,"
          "artistName TEXT,"
          "description TEXT"
          ")"
        );
        await db.execute(
          "CREATE TABLE Episodes ("
          "id INTEGER PRIMARY KEY,"
          "podcastId INTEGER,"
          "link TEXT,"
          "name TEXT,"
          "epDesc TEXT,"
          "subtitle TEXT,"
          "number INTEGER,"
          "played BIT,"
          "duration INTEGER,"
          "released TEXT,"
          "FOREIGN KEY(podcastId) REFERENCES Podcasts(id)"
          ")"
        );
      }
    );
  }

  insertPodcast(Podcast podcast) async
  {
    Database db = await _db;
    List<Map<String, dynamic>> podcastMatches = await db.transaction((txn) async {
      return txn.rawQuery("SELECT id FROM Podcasts WHERE Podcasts.title = "+sqlSanitize(podcast.title));
    });

    String artStr = base64Encode((await http.get(podcast.artLink)).bodyBytes);

    if(podcastMatches.isEmpty)
    {
      int podcastId = -1;
      podcastId = await db.transaction((txn) async {
        return txn.rawInsert(
          "INSERT INTO Podcasts ("
          "title,"
          "artLink,"
          "art,"
          "thumbnailLink,"
          "feedLink,"
          "artistName,"
          "description"
          ") VALUES ("
          +sqlSanitize(podcast.title, delimiter: ",")
          +sqlSanitize(podcast.artLink, delimiter: ",")
          +sqlSanitize(artStr, delimiter: ",")
          +sqlSanitize(podcast.thumbnailLink, delimiter: ",")
          +sqlSanitize(podcast.feedLink, delimiter: ",")
          +sqlSanitize(podcast.artistName, delimiter: ",")
          +sqlSanitize(podcast.description)+")"
        );
      });
      db.transaction((txn) async {
        for(Episode ep in podcast.episodes)
        {
          txn.execute(
            "INSERT INTO Episodes ("
            "podcastId,"
            "link,"
            "name,"
            "epDesc,"
            "subtitle,"
            "number,"
            "played,"
            "duration,"
            "released"
            ") VALUES ("
            +sqlSanitize(podcastId.toString(), delimiter: ",")
            +sqlSanitize(ep.link, delimiter: ",")
            +sqlSanitize(ep.name, delimiter: ",")
            +sqlSanitize(ep.description, delimiter: ",")
            +sqlSanitize(ep.subtitle, delimiter: ",")
            +sqlSanitize(ep.number.toString(), delimiter: ",")
            +((ep.played)?"1":"0")+((ep!=null)?",":"")
            +sqlSanitize(ep.duration.inMilliseconds.toString(), delimiter: ",")
            +sqlSanitize(ep.released)+")"
          );
        }
      });
    }
    print("inserted "+podcast.title);
  }

  deletePodcast(String title) async
  {
    Database db = await _db;
    List<Map<String, dynamic>> podcastMatches = await db.transaction((txn) async {
      return txn.rawQuery("SELECT id FROM Podcasts WHERE Podcasts.title = "+sqlSanitize(title));
    });
    if(podcastMatches.isNotEmpty)
    {
      db.transaction((txn) async {
        return txn.rawDelete(
          "DELETE FROM Episodes WHERE podcastId = "
          +sqlSanitize(podcastMatches.first['id'].toString())
        );
      });
      db.transaction((txn) async {
        return txn.rawDelete(
          "DELETE FROM Podcasts WHERE id = "
          +sqlSanitize(podcastMatches.first['id'].toString())
        );
      });
    }
  }

  Future<Podcast> getPodcast(String title) async
  {
    Database db = await _db;
    List<Map<String, Object>> eps = await db.transaction((txn) async {
      return txn.rawQuery(
        "SELECT * FROM Podcasts "
        "WHERE title = "+sqlSanitize(title)
      );
    });

    List<Podcast> pods = new List<Podcast>();

    for(Map<String, Object> row in eps)
    {
      pods.add(
        Podcast(
          row["title"]??'',
          row["feedLink"]??'',
          row["artistName"]??'',
          row["description"]??'',
          row["artLink"]??'',
          row["thumbnailLink"]??''
        )
      );
    }
    return pods.first;
  }

  Future<ImageProvider> getPodcastArt(String title) async
  {
    Database db = await _db;
    List<Map<String, Object>> eps = await db.transaction((txn) async {
      return txn.rawQuery(
        "SELECT * FROM Podcasts "
        "WHERE title = "+sqlSanitize(title)
      );
    });

    List<ImageProvider> art = new List<ImageProvider>();

    for(Map<String, Object> row in eps)
    {
      art.add(
        Image.memory(base64Decode(row["art"] ?? "")).image
      );
    }
    return art.first;
  }

  Future<List<Podcast>> getPodcasts(String title) async
  {
    Database db = await _db;
    List<Map<String, Object>> eps = await db.transaction((txn) async {
      return txn.rawQuery(
        "SELECT * FROM Podcasts "
        "WHERE title = "+sqlSanitize(title)
      );
    });

    List<Podcast> pods = new List<Podcast>();

    for(Map<String, Object> row in eps)
    {
      pods.add(
        Podcast(
          row["title"]??'',
          row["feedLink"]??'',
          row["artistName"]??'',
          row["description"]??'',
          row["artLink"]??'',
          row["thumbnailLink"]??''
        )
      );
    }
    return pods;
  }

  Future<List<Podcast>> getAllPodcasts() async
  {
    Database db = await _db;
    List<Map<String, Object>> eps = await db.transaction((txn) async {
      return txn.rawQuery("SELECT * FROM Podcasts");
    });

    List<Podcast> pods = new List<Podcast>();

    for(Map<String, Object> row in eps)
    {
      pods.add(
        Podcast(
          row["title"]??'',
          row["feedLink"]??'',
          row["artistName"]??'',
          row["description"]??'',
          row["artLink"]??'',
          row["thumbnailLink"]??'',
          await getEpisodes(row["title"??''])
        )
      );
    }
    return pods;
  }

  Future<List<Episode>> getEpisodes(String title) async
  {
    Database db = await _db;
    List<Map<String, Object>> eps = await db.transaction((txn) async {
      return txn.rawQuery(
        "SELECT * FROM "
        "Episodes INNER JOIN Podcasts ON "
        "Episodes.podcastId = Podcasts.id "
        "WHERE title = "+sqlSanitize(title)
      );
    });

    List<Episode> episodes = new List<Episode>();

    for(Map<String, Object> row in eps)
    {
      episodes.add(
        Episode(
          row["link"],
          row["name"],
          row["epDesc"],
          row["subtitle"],
          row["number"],
          false,
          Duration(milliseconds: row["duration"]),
          row["released"]
        )
      );
    }

    return episodes;
  }

  String sqlSanitize(String s, {String delimiter})
  {
    if(s==null || s.isEmpty)
      return "\"\""+delimiter;

    String out = "\""+s.replaceAll("\"", '')
      .replaceAll("\'", '')
      .replaceAll("(", "\(")
      .replaceAll(")", "\)")
      .replaceAll("\\", "\\\\")+"\"";
    return ((s == null || s.isEmpty)?"":out+(delimiter??''));
  }

}