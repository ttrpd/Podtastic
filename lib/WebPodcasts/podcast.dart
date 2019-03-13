import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Podcast
{
  Future<http.Response> resp;
  http.Response resp1;
  Future<http.Response> feed;
  http.Response feed1;
  Future<Podcast> pod;
  // dynamic json;
  String id;
  String title;
  bool played = false;
  // Image art;
  String artLink;
  String link;
  String description;
  Set<Episode> episodes = Set<Episode>();

  operator ==(Object podcast)
  {
    return ( podcast is Podcast
      && this.title == podcast.title
      && this.id == podcast.id
    );
  }

  addEpisode(XmlElement i)
  {

    // if(episodes.contains())
    // {
    String link = (i.findElements('enclosure').isNotEmpty)?i.findElements('enclosure').first.attributes.first.value:'';
    String name = (i.findElements('title').isNotEmpty)?i.findElements('title').first.text:'';
    String description = (i.findElements('description').isNotEmpty)?i.findElements('description').first.text:'';
    String subtitle = (i.findElements('itunes:subtitle').isNotEmpty)?i.findElements('itunes:subtitle').first.text:'';
    int number = int.parse((i.findElements('itunes:episode').isNotEmpty)?i.findElements('itunes:episode').first.text:'0');
    String dur = (i.findElements('itunes:duration').isNotEmpty)?i.findElements('itunes:duration').first.text:'00';
    Duration duration;
    if(dur.isNotEmpty)
    {
      int seconds = 0;
      for(int j = 0; j < dur.split(':').reversed.length; j++)
      {
        seconds += pow(int.parse(dur.split(':').reversed.elementAt(j)),j);
      }
      duration = Duration(seconds: seconds);
    }
    else
    {
      duration = Duration.zero;
    }

    String released = '';
    if(i.findAllElements('pubDate')!=null)
      released = i.findElements('pubDate').first.text;

    released = released.substring(0,(released.contains('+'))?released.indexOf('+'):0).trim();
    episodes.add( Episode(link, name, description, subtitle, number, duration, released) );
    // }

  }

  Podcast(this.id, this.title, this.link, this.description, this.played, this.artLink)
  {
    // art = Image.network(artLink);
    // pod = complete();
  }

  Podcast.fromId(this.id)
  {
    // pod = complete();
    // link = 'https://itunes.apple.com/search?term='+Uri.encodeFull(id)+'&media=podcast';
    // played = false;
    // pod = Future((){
    //   resp = http.get(
    //     link
    //   ).then((r){
    //     print('received');
    //     var json = jsonDecode(r.body)['results'][0];
    //     // print(jsonDecode(r.body));
    //     title = json['collectionName'];
    //     artLink = json['artworkUrl100'];
    //     // art = Image.network(artLink);
    //     feed = http.get(json['feedUrl']);
    //     feed.then((rss){
    //       var rssFeed = xml.parse(rss.body);
    //       description = rssFeed.findAllElements('description').first.text;
    //       rssFeed.findAllElements('item').forEach((i)=>addEpisode(i));
    //     });  
    //   });
    // });
  }

  Future<Podcast> complete() async
  {
    if(episodes.isNotEmpty)

    if(link==null)
      link = 'https://itunes.apple.com/search?term='+Uri.encodeFull(id)+'&media=podcast';

    http.Response r = await http.get(link);
    Map<String, dynamic> json = jsonDecode(r.body)['results'][0];
    artLink = json['artworkUrl100'];
    if(title==null)
      title = json['collectionName'];
    
    http.Response f = await http.get(json['feedUrl']);
    var rssFeed = xml.parse(f.body);
    description = rssFeed.findAllElements('description').first.text;
    played = false;
    rssFeed.findAllElements('item').forEach((i)=>addEpisode(i));
    return this;
  }
  
  // Future<Image> getArt() async
  // {
  //   if(artLink!=null)
  //     return Future(()=>Image.network(artLink));
    
  //   return Future(() async {
  //     resp1 = await http.get(link);
  //     json = jsonDecode(r.body)['results'][0];
  //   });
  // }

}

class Episode
{
  String link;
  String name;
  String description;
  String subtitle;
  int number;
  Duration duration;
  String released;

  Episode(
    this.link,
    this.name,
    this.description,
    this.subtitle,
    this.number,
    this.duration,
    this.released,
  );

  operator ==(Object episode)
  {
    return ( episode is Episode
      && this.name == episode.name
      && this.link == episode.link
    );
  }

}