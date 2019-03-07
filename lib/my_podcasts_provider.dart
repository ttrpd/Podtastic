


import 'package:flutter/widgets.dart';
import 'package:podtastic/WebPodcasts/podcast.dart';
import 'package:sqflite/sqflite.dart';

class MyPodcastsProvider extends InheritedWidget
{
  Set<Podcast> podcasts = Set<Podcast>();
  Database db;
  
  
  MyPodcastsProvider({Key key, Widget child,}) : super(key: key, child: child)
  {
    
  }

  Future<Set<Podcast>> getPodcastList() async
  {
    String path = await getDatabasesPath();
    path += 'podcasts.db';
    db = await openDatabase(
      path,
      version: 1,
      onConfigure: (Database db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: (Database db, int version) async {
        await db.execute("""CREATE TABLE Podcasts (
          id INTEGER PRIMARY KEY,
          title VARCHAR,
          link VARCHAR,
          description VARCHAR,
          played INTEGER,
          artLink VARCHAR
        )""");
        await db.execute(""" CREATE TABLE Episodes (
          episodeId INTEGER PRIMARY KEY AUTOINCREMENT,
          podcastId INTEGER,
          name VARCHAR,
          link VARCHAR,
          description VARCHAR,
          subtitle VARCHAR,
          number INTEGER,
          duration INTEGER,
          released VARCHAR,
          FOREIGN KEY(podcastId) REFERENCES Podcasts(id)
        )""");
      },
    );
    List<Map<String, dynamic>> dbEntries = await getAllPodcasts();
    for(Map<String, dynamic> pod in dbEntries)
    {
      podcasts.add(Podcast(
        pod['id'].toString(),
        pod['title'],
        pod['link'],
        pod['description'],
        pod['played'] > 0,
        pod['artLink'],
      ));
    }
    return podcasts;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static MyPodcastsProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(MyPodcastsProvider);
  }

  Future<List<Map<String, dynamic>>> getAllPodcasts()
  {
    return db.rawQuery("SELECT * FROM Podcasts");
  }

  Future<List<Map<String, dynamic>>> getPodcast(int id)
  {
    return db.rawQuery("SELECT * FROM Podcasts WHERE id="+id.toString());
  }

  void addPodcast(Podcast podcast)
  {
    getPodcast(int.parse(podcast.id)).then((v){
      if(v.isEmpty)
      {
        db.insert("Podcasts", {
          "id" : podcast.id,
          "title" : podcast.title,
          "link" : podcast.link,
          "description" : podcast.description,
          "played" : podcast.played?1:0,
          "artLink" : podcast.artLink
        });
        podcasts.add(podcast);
        print('Added podcast');
      }
      else{
        print('Already in podcasts');
      }
    });
  }

  void deletePodcast(Podcast podcast)
  {
    getPodcast(int.parse(podcast.id)).then((v){
      if(v.isNotEmpty)
      {
        db.delete("Podcasts", where: "id = ?", whereArgs: [podcast.id]);
        print('Deleted podcast');
      }
      else{
        print('Not found in podcasts');
      }
    });
  }

  Future<List<Map<String, dynamic>>> getEpisodesByPodcastId(int podcastId)
  {
    return db.rawQuery("SELECT * FROM Episodes WHERE podcastId="+podcastId.toString());
  }
  
  void addEpisode(int podcastId, Episode episode)
  {
    getPodcast(podcastId).then((v){
      if(v.isNotEmpty)
      {
        getEpisodesByPodcastId(podcastId).then((v){
          if(v.where(
            (e)=> e['name']==episode.name && e['number']==episode.number
          ).isEmpty)//if this episode isn't in Episodes
          {
            db.insert("Episodes", {
              "podcastId" : podcastId,
              "name" : episode.name,
              "link" : episode.link,
              "description" : episode.description,
              "subtitle" : episode.subtitle,
              "number" : episode.number,
              "duration" : episode.duration.inMilliseconds,
              "released" : episode.released
            });
            print('Added episode');
          }
          else{
            print('Already in episodes');
          }
        });
      }
    });
  }
  
  void deleteEpisode(int podcastId, Episode episode)
  {
    getPodcast(podcastId).then((v){
      if(v.isNotEmpty)
      {
        getEpisodesByPodcastId(podcastId).then((v){
          if(v.where(
            (e)=> e['name']==episode.name && e['number']==episode.number
          ).isNotEmpty)//if this episode isn't in Episodes
          {
            db.delete("Episodes", where: "podcastId = ? AND name = ? AND number = ?", 
              whereArgs: [podcastId, episode.name, episode.number]
            );
            print('Deleted episode');
          }
          else{
            print('Not found in episodes');
          }
        });
      }
    });
  }
}