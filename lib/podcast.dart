import 'dart:math';
import 'package:xml/xml.dart';

class Podcast
{
  // dynamic json;
  String id = '';
  String title = '';
  // Image art;
  String artLink = '';
  String thumbnailLink = '';
  String feedLink = '';
  String artistName = '';
  String description = '';
  List<Episode> episodes = List<Episode>();

  Podcast([this.title, this.feedLink, this.artistName, this.description, this.artLink, this.thumbnailLink, this.episodes]){}

  operator ==(Object podcast)
  {
    return ( podcast is Podcast
      && this.title == podcast.title
      && this.artLink == podcast.artLink
      && this.thumbnailLink == podcast.thumbnailLink
      && this.feedLink == podcast.feedLink
      && this.artistName == podcast.artistName
      && this.description == podcast.description
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
    episodes.add( Episode(link, name, description, subtitle, number, false, duration, released) );
    // }

  }


}

class Episode
{
  String link;
  String name;
  String description;
  String subtitle;
  int number;
  bool played = false;
  String released;
  Duration duration;

  Episode(
    this.link,
    this.name,
    this.description,
    this.subtitle,
    this.number,
    this.played,
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