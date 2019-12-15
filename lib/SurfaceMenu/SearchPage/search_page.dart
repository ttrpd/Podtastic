import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:podtastic/SurfaceMenu/podcast_page.dart';
import 'package:podtastic/SurfaceMenu/MyPodcastsPage/podcast_sliver.dart';
import 'package:podtastic/podcast.dart';
import 'package:http/http.dart' as http;
import 'package:podtastic/podcast_db.dart';
import 'package:webfeed/webfeed.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key key,
    @required this.onNowPlayTap,
  }) : super(key: key);

  final Function() onNowPlayTap;

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

    print(resp.body);

    List<Episode> episodes = List<Episode>();
    if(podXML.items.isNotEmpty)
    {
      for(RssItem item in podXML.items)
      {
        print(item.dc.description);
        episodes.add(
          Episode(
            item?.enclosure?.url ?? item.link,
            item.title,
            item.description,
            item.comments ?? "",
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
    print(selectedPodcast.episodes.first.description);
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
                    return PodcastSliver(
                      selectedPodcast: podcastList.elementAt(index),
                      onTap: () async {// open podcast
                        FocusScope.of(context).requestFocus(FocusNode());
                        fp = getPodcastData(podcastList.elementAt(index));
                        fp.then((p) async {
                          await PodcastDB.of(context).insertPodcast(p);
                          await PodcastDB.of(context).getPodcast(p.title);
                        });
                        setState(() {
                          podcastPageOpen = true;
                        });
                      },
                    );
                  },

                ),
              ),
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