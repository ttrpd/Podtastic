import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:podtastic/WebPodcasts/podcast.dart';
import 'package:podtastic/WebPodcasts/itunes_podcasts.dart';
import 'package:podtastic/my_podcasts_provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class PodcastPage extends StatefulWidget {
  Podcast podcast;
  PodcastPage({
    @required this.podcast,
  });

  @override
  _MyPodcastsPageState createState() => _MyPodcastsPageState();
}

class _MyPodcastsPageState extends State<PodcastPage> {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.podcast.title),
          centerTitle: true,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: 'Played'),
              Tab(text: 'Unplayed'),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 8,
              child: Row(
                children: <Widget>[
                  CachedNetworkImage(
                    placeholder: (cntxt,str)=>CircularProgressIndicator(),
                    imageUrl: widget.podcast.artLink,
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                text: widget.podcast.title,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.blue
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Html(data: widget.podcast.description),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: TabBarView(
                children: <Widget>[
                  buildEpisodeList(widget.podcast.episodes.where((v)=>v.number!=-1).toList()),//use played attribute when implemented
                  buildEpisodeList(widget.podcast.episodes.where((v)=>v.number!=-2).toList()),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget buildEpisodeList(List<Episode> episodes)
  {

    return ListView.builder(
      itemCount: episodes.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            text: episodes.elementAt(index).number.toString(),
                          ),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: RichText(
                          text: TextSpan(
                            text: episodes.elementAt(index).name,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: RichText(
                      text: TextSpan(
                        text: episodes.elementAt(index).description
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}