import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:podtastic/WebPodcasts/podcast.dart';

class ItunesPodcasts
{

  dom.Document doc;
  Future<http.Response> genreResp = http.get('https://itunes.apple.com/WebObjects/MZStoreServices.woa/ws/genres?id=26');
  Map<int, String> genres = Map<int, String>();
  
  Future<http.Response> resp = http.get(
      'https://itunes.apple.com/us/genre/podcasts/id26?'
  );

  ItunesPodcasts()
  {
    getGenres().then((g)=>genres = g);
  }

  Future<Map<int, String>> getGenres() async
  {
    // if(doc==null)
    //   return null;
    // return doc.getElementsByClassName('top-level-genre');
    http.Response r = await genreResp;
    Map<int, String> g = Map<int, String>();
    Map<String, dynamic> json = jsonDecode(r.body)['26']['subgenres'];
    for(var entry in json.entries) {
      g.addAll({
        int.parse(entry.key):entry.value['name']
      });
    }
    return g;
  }

  // List<dom.Element> getSubGenres()
  // {
  //   if(doc==null)
  //     return null;
  //   return doc.getElementsByClassName('list top-level-subgenres');
  // }

  Future<Map<int, String>> getSubGenresFromGenre(int id) async
  {
    // if(doc==null)
    //   return null;
    // return this.getGenres().firstWhere((a)=>a.text==genre)
    //   .parent.getElementsByClassName('list top-level-subgenres');
    http.Response r = await genreResp;
    Map<int, String> genres = Map<int, String>();
    Map<String, dynamic> json = jsonDecode(r.body)['26']['subgenres'][id.toString()]['subgenres'];
    if(json!=null)
      for(var entry in json.entries)
      {
        genres.addAll({
          int.parse(entry.key):entry.value['name']
        });
      }
    return genres;
  }

  Future<List<Podcast>> getTopPodcastsFromGenre(int id) async
  {
    http.Response r = await http.get('https://itunes.apple.com/search?term=podcast&genreId=1402&limit=25');
    List<Podcast> pods = List<Podcast>();
    List<dynamic> json = jsonDecode(r.body)['results'];
    for(var entry in json)
    {
      pods.add(
        Podcast.fromId(entry['collectionName'])
      );
    }
    return pods;
  }
}

// class PodcastsList
// {
//   String link;
//   dom.Document doc;
//   Future<http.Response> resp;
//   Map<String, String> podcasts = Map<String, String>();


//   PodcastsList(this.link)
//   {
//     this.resp = http.get(link);
//     resp.then((r){
//       doc = parse(r.body);
//       doc.getElementById('selectedcontent').getElementsByTagName('li').forEach((li){
//         podcasts.addAll({ li.children.first.text : li.children.first.attributes['href'] });
//       });
//     });
//   }
// }