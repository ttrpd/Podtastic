import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class ItunesPodcast
{
  Future<http.Response> resp;
  dom.Document doc;
  String location;
  Image art;
  String description;
  List<dom.Element> episodes;

  ItunesPodcast(String location)
  {
    location = location;
    resp = http.get(location).then((r){
      doc = parse(r.body);
      // art = Image.network(doc.getElementsByClassName('artwork').first.attributes['src']);
      description = doc.getElementsByClassName('product-review').first.getElementsByTagName('p').first.text;
      episodes = doc.getElementsByClassName('podcast-episode');
    });
  }

  void update()
  {
    description = doc.getElementsByClassName('product-review').first.getElementsByTagName('p').first.text;
    episodes = doc.getElementsByClassName('podcast-episode');
    print(description);
  }

}