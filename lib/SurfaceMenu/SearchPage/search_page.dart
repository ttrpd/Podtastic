import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:http/http.dart';
import 'package:podtastic/podcast.dart';
import 'package:http/http.dart' as http;
import 'package:podtastic/podcast_db.dart';
import 'package:webfeed/webfeed.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key key,
  }) : super(key: key);


  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {

  bool podcastPageOpen = false;

  Podcast selectedPodcast = Podcast();

  List<Podcast> podcastList = List<Podcast>();
  TextEditingController searchController = TextEditingController();

  Future<Podcast> fp;

  Future<List<Podcast>> searchforPodcast(String term) async
  {
    http.Response r = await http.get('https://itunes.apple.com/search?term='+Uri.encodeFull(term)+'&media=podcast');
    List<Podcast> pods = List<Podcast>();
    List<dynamic> json = jsonDecode(r.body)['results'];
    for(var entry in json)
    {
      pods.add(
        Podcast(entry['collectionName'], entry['feedUrl'], entry['artistName'], '', entry['artworkUrl600'], entry['artworkUrl100'])
      );
    }
    setState(() {
      podcastList = pods;
    });
    return pods;
  }

  Future<Podcast> getPodcastData(Podcast pod) async
  {
    final client = http.Client();
    Response resp = await client.get(pod.feedLink);
    var podXML = RssFeed.parse(resp.body);

    print(podXML.items.first.enclosure.url);

    List<Episode> episodes = List<Episode>();
    if(podXML.items.isNotEmpty)
    {
      for(RssItem item in podXML.items)
      {
        episodes.add(
          Episode(
            item.enclosure.url,
            item.title,
            item.description,
            '',
            0,
            false,
            Duration(minutes: 10),
            item.pubDate,
          )
        );
      }
    }
    setState(() {
      selectedPodcast = Podcast(
        podXML.title,
        pod.feedLink,
        podXML.author,
        podXML.description,
        pod.artLink,
        pod.thumbnailLink,
        episodes
      );
    });
    print(selectedPodcast.title);
    return selectedPodcast;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 25.0, left: 20.0, right: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: Container(
                    height: 40.0,
                    width: double.maxFinite,
                    color: Theme.of(context).primaryColorDark,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: TextField(
                        controller: searchController,
                        cursorColor: Theme.of(context).backgroundColor,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          icon: Icon(Icons.search, color: Colors.grey,),
                          border: InputBorder.none
                        ),
                        onChanged: (s)=>searchforPodcast(s),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: podcastList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () async {// open podcast
                        fp = getPodcastData(podcastList.elementAt(index));
                        fp.then((p) async {
                          await PodcastDB.of(context).insertPodcast(p);
                          await PodcastDB.of(context).getPodcast(p.title);
                        });
                        setState(() {
                          podcastPageOpen = true;
                        });
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
                                child: FutureBuilder(
                                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
                                  {
                                    return Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(podcastList.elementAt(index).thumbnailLink),
                                        )
                                      ),
                                    );
                                  },
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
                                    text: podcastList.elementAt(index).title,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },

                ),
              ),
            ],
          ),
          buildSelectedPodcastPage(context),
        ],
      ),
    );
  }

  Widget buildSelectedPodcastPage(BuildContext context) {
    return AnimatedContainer(
        width: double.maxFinite,
        height: double.maxFinite,
        duration: Duration(milliseconds: 300),
        transform: Matrix4.translationValues(podcastPageOpen?0:MediaQuery.of(context).size.width, 0, 0),
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(20.0),
          child: FutureBuilder(
            future: fp,
            builder: (BuildContext context, AsyncSnapshot<Podcast> snapshot) {
              return Container(
                color: Theme.of(context).primaryColor,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.grey,
                              size: 30.0,
                            ),
                            onPressed: (){
                              setState(() {
                                podcastPageOpen = false;
                              });
                            },
                          ),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                text: selectedPodcast.title,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26.0
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
                      child: Container(
                        height: 160.0,
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 160.0,
                                child: RichText(
                                  maxLines: 10,
                                  text: TextSpan(
                                    text: selectedPodcast.description,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0
                                    )
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Container(
                                  width: 160.0,
                                  height: 160.0,
                                  decoration: (snapshot.hasData)?
                                  BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(selectedPodcast.artLink), 
                                    ),
                                  ):
                                  BoxDecoration(
                                    color: Colors.grey
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: snapshot.hasData?
                        ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: selectedPodcast.episodes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: double.maxFinite,
                              height: 100.0,
                              child: RichText(
                                text: TextSpan(
                                  text: selectedPodcast.episodes.elementAt(index).name,
                                  style: TextStyle(
                                    color: Colors.black
                                  )
                                ),
                              ),
                            );
                          },
                        ):
                        Container(),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ),
      );
  }
}