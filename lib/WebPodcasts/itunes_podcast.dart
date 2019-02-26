import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class ItunesPodcast
{
  Future<http.Response> resp;
  Future<http.Response> artResp;
  dom.Document doc;
  dom.Document artDoc;
  String location;
  String artLocation;
  String title;
  Image art;
  String description;
  Set<Episode> episodes = Set<Episode>();

  addEpisode(dom.Element e)
  {
    String name = e.attributes['preview-title'];

    if(episodes.where((ep)=>ep.name==name).length==0)
    {
      String link = e.attributes['audio-preview-url'];
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
  }

  ItunesPodcast(this.location)
  {
    artLocation = "https://overcast.fm/itunes" + 
      location.substring(location.indexOf('/id')+3, location.lastIndexOf('?')) + '/' +
      location.substring(location.indexOf('podcast/')+8,location.lastIndexOf('/'));

    artResp = http.get(artLocation).then((r){
      artDoc = parse(r.body);
      art = Image.network(
        artDoc.getElementsByClassName('art fullart').first.attributes['src']
      );
    });
    resp = http.get(location).then((r){
      print('received');
      doc = parse(r.body);
      title = doc.getElementById('title').getElementsByTagName('h1').first.text;
      
      print(
        doc.getElementsByClassName('lockup product podcast').first
        .getElementsByClassName('artwork').first
        .getElementsByTagName('img').first
        .outerHtml.split(' ')[7].replaceAll("\"", "").replaceFirst("src-swap=", "").replaceAll(">", "")
      );
      print('howdy');
      description = doc.getElementsByClassName('product-review').first.getElementsByTagName('p').first.text;
      doc.getElementsByClassName('podcast-episode').forEach(addEpisode);
    });
  }

  void update()
  {
    description = doc.getElementsByClassName('product-review').first.getElementsByTagName('p').first.text;
    doc.getElementsByClassName('podcast-episode').forEach(addEpisode);
    print(doc.getElementsByClassName('lockup product podcast'));
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