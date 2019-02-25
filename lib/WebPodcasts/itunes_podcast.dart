import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class ItunesPodcast
{
  Future<http.Response> resp;
  dom.Document doc;
  String location;
  String title;
  Image art;
  String description;
  List<Episode> episodes = List<Episode>();

  addEpisode(dom.Element e)
  {
    String link = e.attributes['audio-preview-url'];
    String name = e.attributes['preview-title'];

    String desc = e.getElementsByClassName('description flexible-col').first
      .getElementsByClassName('text').first.text;
    int nmbr = int.parse(
      e.getElementsByClassName('index ascending').first.getElementsByTagName('span').first.text
    );

    Duration dur = Duration( milliseconds:
      (e.attributes['preview-duration']==null)?0:int.parse(e.attributes['preview-duration'])
    );

    String rel = e.getElementsByClassName('release-date').first.getElementsByClassName('text').first.text;
    DateTime released = DateTime(
      int.parse(rel.split('/')[2]), // year
      int.parse(rel.split('/')[0]), // month
      int.parse(rel.split('/')[1]), // day
    );

    episodes.add( Episode(link, art, name, desc, nmbr, dur, released) );
  }

  ItunesPodcast(this.location)
  {
    resp = http.get(location).then((r){
      doc = parse(r.body);
      title = doc.getElementById('title').getElementsByTagName('h1').first.text;
      art = Image.network(doc.getElementsByClassName('artwork').first.getElementsByClassName('artwork').first.attributes['src']);
      description = doc.getElementsByClassName('product-review').first.getElementsByTagName('p').first.text;
      doc.getElementsByClassName('podcast-episode').forEach(addEpisode);
    });
  }

  void update()
  {
    description = doc.getElementsByClassName('product-review').first.getElementsByTagName('p').first.text;
    doc.getElementsByClassName('podcast-episode').forEach(addEpisode);
    print(title);
  }

}

class Episode
{
  String link;
  Image art;
  String name;
  String description;
  int number;
  Duration duration;
  DateTime released;

  Episode(
    this.link,
    this.art,
    this.name,
    this.description,
    this.number,
    this.duration,
    this.released,
  );
}