import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class ItunesPodcasts
{

  dom.Document doc;
  
  Future<http.Response> resp = http.get(
      'https://itunes.apple.com/us/genre/podcasts/id26?'
  );

  ItunesPodcasts()
  {
    resp.then((r)=>doc=parse(r.body));
  }

  List<dom.Element> getGenres()
  {
    if(doc==null)
      return null;
    return doc.getElementsByClassName('top-level-genre');
  }

  List<dom.Element> getSubGenres()
  {
    if(doc==null)
      return null;
    return doc.getElementsByClassName('list top-level-subgenres');
  }

  List<dom.Element> getSubGenresFromGenre(String genre)
  {
    if(doc==null)
      return null;
    return this.getGenres().firstWhere((a)=>a.text==genre)
      .parent.getElementsByClassName('list top-level-subgenres');
  }

  Map<dom.Element,List<dom.Element>> getGenreMap()
  {
    if(doc==null)
      return null;

    Map<dom.Element, List<dom.Element>> genreMap = Map<dom.Element, List<dom.Element>>();
    List<dom.Element> genres = doc.getElementsByClassName('top-level-genre');
    for(dom.Element element in genres)
    {
      genreMap.addAll({
        element : element.parent.getElementsByClassName('list top-level-subgenres')
      });
    }

    return genreMap;
  }
}

class PodcastsList
{
  String link;
  dom.Document doc;
  Future<http.Response> resp;
  Map<String, String> podcasts = Map<String, String>();


  PodcastsList(this.link)
  {
    this.resp = http.get(link);
    resp.then((r){
      doc = parse(r.body);
      doc.getElementById('selectedcontent').getElementsByTagName('li').forEach((li){
        podcasts.addAll({ li.children.first.text : li.children.first.attributes['href'] });
      });
    });
  }
}