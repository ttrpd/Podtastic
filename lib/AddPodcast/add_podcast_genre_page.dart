import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:podtastic/AddPodcast/add_podcast_subgenre_page.dart';
import 'package:podtastic/WebPodcasts/podcast.dart';
import 'package:podtastic/WebPodcasts/itunes_podcasts.dart';
import 'package:podtastic/my_podcasts_provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class AddPodcastGenrePage extends StatefulWidget {

  ItunesPodcasts itunesPodcasts;

  AddPodcastGenrePage(this.itunesPodcasts);

  @override
  _MyPodcastsPageState createState() => _MyPodcastsPageState();
}

class _MyPodcastsPageState extends State<AddPodcastGenrePage> {
  @override
  Widget build(BuildContext context) {
    // ItunesPodcast('https://itunes.apple.com/us/podcast/99-invisible/id394775318?mt=2').update();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Podcast'),
      ),
      extendBody: true,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(10.0),
              itemCount: widget.itunesPodcasts.genres.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: GestureDetector(
                    onTap: () async {
                      Map<int, String> sg = await widget.itunesPodcasts.getSubGenresFromGenre(
                        widget.itunesPodcasts.genres.entries.elementAt(index).key
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPodcastSubGenrePage(sg),
                        ),
                      );
                      print('pressed');
                      print(widget.itunesPodcasts.genres.entries.length);
                    },
                    child: Material(
                      elevation: 10.0,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: MediaQuery.of(context).size.height / 10,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            text: TextSpan(
                              text: widget.itunesPodcasts.genres.entries.elementAt(index).value,
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}