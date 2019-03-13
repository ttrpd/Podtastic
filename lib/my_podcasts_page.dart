import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:podtastic/WebPodcasts/podcast.dart';
import 'package:podtastic/WebPodcasts/itunes_podcasts.dart';
import 'package:podtastic/AddPodcast/add_podcast_genre_page.dart';
import 'package:podtastic/my_podcasts_provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:podtastic/podcast_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class MyPodcastsPage extends StatefulWidget {
  // This widget is the root of your application.


  @override
  _MyPodcastsPageState createState() => _MyPodcastsPageState();
}

class _MyPodcastsPageState extends State<MyPodcastsPage> {
  @override
  Widget build(BuildContext context) {
    // ItunesPodcast('https://itunes.apple.com/us/podcast/99-invisible/id394775318?mt=2').update();
    // SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    Podcast pod = Podcast.fromId('152249110');
    ItunesPodcasts itunesPodcasts = ItunesPodcasts();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Podtastic'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          itunesPodcasts.resp.then((r){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPodcastGenrePage(itunesPodcasts),
              ),
            );
          });
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
      primary: true,
      body: FutureBuilder(
        future: MyPodcastsProvider.of(context).loaded,
        builder: (BuildContext context, AsyncSnapshot<Set<Podcast>> snapshot) {
          if(MyPodcastsProvider.of(context).podcasts.length > 0)
          {
            return Container(
              child: ListView.builder(
                itemCount: MyPodcastsProvider.of(context).podcasts.length,
                padding: EdgeInsets.all(10.0),
                itemBuilder: (BuildContext context, int index) {
                  Podcast podcast = MyPodcastsProvider.of(context).podcasts.elementAt(index);
                  return buildPodcastSliver(context, podcast);
                },
              ),
            );
          }
          else
          {
            return Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: RichText(
                text:TextSpan(
                  text: "You aren't subscribed to any podcasts",
                  style: Theme.of(context).primaryTextTheme.body1,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildPodcastSliver(BuildContext context, Podcast podcast){
    double height = MediaQuery.of(context).size.height / 8;
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Material(
        elevation: 10.0,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PodcastPage(podcast: podcast,),
              ),
            );
          },
          child: FutureBuilder(
            future: podcast.complete(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              return Container(
                color: Theme.of(context).backgroundColor,
                height: height,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: Container(
                        height: height,
                        width: height,
                        child: CachedNetworkImage(
                          placeholder: (cntxt,str)=>CircularProgressIndicator(),
                          imageUrl: podcast.artLink,
                        ),
                      ),
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
                                  text: podcast.title,
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
                            child: Html(data: podcast.description),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              );
            },
          ),
        )
      ),
    );
  }
}