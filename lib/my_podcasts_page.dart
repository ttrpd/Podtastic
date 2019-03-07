import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:podtastic/WebPodcasts/podcast.dart';
import 'package:podtastic/WebPodcasts/itunes_podcasts.dart';
import 'package:podtastic/my_podcasts_provider.dart';
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
    Podcast podcast = Podcast.fromId('367330921');
    PodcastsList podslist = PodcastsList('https://itunes.apple.com/us/genre/podcasts-arts/id1301?mt=2');
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Podtastic'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>setState(() {
         MyPodcastsProvider.of(context).addPodcast(podcast); 
        }),
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: MyPodcastsProvider.of(context).getPodcastList(),
        builder: (BuildContext context, AsyncSnapshot<Set<Podcast>> snapshot) {
          if(MyPodcastsProvider.of(context).podcasts.length > 0)
          {
            return Container(
              child: ListView.builder(
                itemCount: MyPodcastsProvider.of(context).podcasts.length,
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
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

  Widget buildPodcastSliver(BuildContext context, Podcast podcast) {
    double height = MediaQuery.of(context).size.height / 8;
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Material(
        elevation: 10.0,
        child: FutureBuilder(
          future: podcast.resp,
          builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
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
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: podcast.art.image,
                        ),
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
                                style: Theme.of(context).textTheme.body1
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: RichText(
                            text: TextSpan(
                              text: podcast.description,
                              style: Theme.of(context).textTheme.body2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            );
          },
        )
      ),
    );
  }
}