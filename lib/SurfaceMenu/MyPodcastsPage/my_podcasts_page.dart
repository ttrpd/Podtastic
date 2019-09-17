import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:http/http.dart';
import 'package:podtastic/podcast.dart';
import 'package:http/http.dart' as http;
import 'package:podtastic/podcast_db.dart';
import 'package:webfeed/webfeed.dart';

class MyPodcastsPage extends StatefulWidget {
  const MyPodcastsPage({
    Key key,
  }) : super(key: key);

  @override
  _MyPodcastsPageState createState() => _MyPodcastsPageState();
}

class _MyPodcastsPageState extends State<MyPodcastsPage> with TickerProviderStateMixin {
  
  List<Podcast> myPodcasts = new List<Podcast>();

  @override
  Widget build(BuildContext context) {
    Future<List<Podcast>> allPodcastsQuery = PodcastDB.of(context).getAllPodcasts();
    allPodcastsQuery.then(( pods ) => myPodcasts = pods);
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
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
                      onTap: () async {// open podcast
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
    );
  }
}