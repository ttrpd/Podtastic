import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';

class Podcast
{
  Future<http.Response> resp;
  Future<http.Response> feed;
  dynamic json;
  String id;
  String title;
  bool played = false;
  Image art;
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
    String link = i.findElements('enclosure').first.attributes.first.value;
    String name = i.findElements('title').first.text;
    String description = (i.findElements('description').isNotEmpty)?i.findElements('description').first.text:'';
    String subtitle = (i.findElements('itunes:subtitle').isNotEmpty)?i.findElements('itunes:subtitle').first.text:'';
    int number = int.parse((i.findElements('itunes:episode').isNotEmpty)?i.findElements('itunes:episode').first.text:'0');
    String dur = (i.findElements('itunes:duration').isNotEmpty)?i.findElements('itunes:duration').first.text:'00';
    Duration duration;
    if(dur.isNotEmpty)
    {
      duration = Duration(
        seconds: int.parse(dur.split(':').reversed.elementAt(0)),
        minutes: (dur.split(':').length>1)?int.parse(dur.split(':').reversed.elementAt(1)):0,
        hours: (dur.split(':').length>2)?int.parse(dur.split(':').reversed.elementAt(2)):0,
      );
    }
    else
    {
      duration = Duration.zero;
    }
    String released = i.findElements('pubDate').first.text;
    released = released.substring(0,(released.contains('+'))?released.indexOf('+'):0).trim();
    episodes.add( Episode(link, name, description, subtitle, number, duration, released) );
    // }

  }

  Podcast(this.id, this.title, this.link, this.description, this.played, this.artLink)
  {
    art = Image.network(artLink);
    resp = http.get(
      link
    ).then((r){
      print('received');
      json = jsonDecode(r.body)['results'][0];
      feed = http.get(json['feedUrl']);
      feed.then((rss){
        var rssFeed = xml.parse(rss.body);
        rssFeed.findAllElements('item').forEach((i)=>addEpisode(i));
      });
    });
  }

  Podcast.fromId(this.id)
  {
    link = 'https://itunes.apple.com/search?term='+Uri.encodeFull(id)+'&media=podcast';
    resp = http.get(
      link
    ).then((r){
      print('received');
      json = jsonDecode(r.body)['results'][0];
      title = json['collectionName'];
      artLink = json['artworkUrl600'];
      art = Image.network(artLink);
      feed = http.get(json['feedUrl']);
      feed.then((rss){
        var rssFeed = xml.parse(rss.body);
        description = rssFeed.findAllElements('description').first.text;
        rssFeed.findAllElements('item').forEach((i)=>addEpisode(i));
      });
      
    });
  }
  

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