import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:podtastic/SurfaceMenu/podcast_page.dart';
import 'package:podtastic/podcast.dart';
import 'package:podtastic/podcast_db.dart';

class MyPodcastsPage extends StatefulWidget {
  const MyPodcastsPage({
    Key key,
    @required this.onNowPlayTap,
  }) : super(key: key);

  final Function() onNowPlayTap;

  @override
  _MyPodcastsPageState createState() => _MyPodcastsPageState();
}

class _MyPodcastsPageState extends State<MyPodcastsPage> with TickerProviderStateMixin {

  bool podcastPageOpen = false;
  Future<Podcast> fp;
  Podcast selectedPodcast = Podcast();

  List<Podcast> myPodcasts = new List<Podcast>();

  @override
  Widget build(BuildContext context) {
    Future<List<Podcast>> allPodcastsQuery = PodcastDB.of(context).getAllPodcasts();
    allPodcastsQuery.then(( pods ) => myPodcasts = pods);
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: FutureBuilder(
                  future: allPodcastsQuery,
                  builder: (BuildContext context, AsyncSnapshot<List<Podcast>> snapshot)
                  {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: myPodcasts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          splashColor: Theme.of(context).primaryColorDark,
                          onTap: () async {// open podcast
                            setState(() {
                              fp = Future.value(myPodcasts.elementAt(index));
                              selectedPodcast = myPodcasts.elementAt(index);
                              podcastPageOpen = true;
                            });
                            print('opening podcast');
                            print(myPodcasts.elementAt(index).title);
                          },
                          child: Container(
                            width: double.maxFinite,
                            height: 90.0,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(myPodcasts.elementAt(index)?.thumbnailLink),
                                        )
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: Colors.black
                                        ),
                                        text: myPodcasts.elementAt(index)?.title,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
          PodcastPage(
            podcastPageOpen: podcastPageOpen,
            fp: fp,
            selectedPodcast: selectedPodcast,
            onBackButtonPress:() {
              setState(() {
                podcastPageOpen = false;
              });
            },
            onNowPlayTap: widget.onNowPlayTap,
          ),
        ],
      ),
    );
  }
}