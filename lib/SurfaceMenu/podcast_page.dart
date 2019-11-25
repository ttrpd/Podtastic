import 'package:flutter/material.dart';
import 'package:podtastic/podcast.dart';
import 'package:podtastic/podcast_provider.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({
    Key key,
    @required this.podcastPageOpen,
    @required this.fp,
    @required this.selectedPodcast,
    @required this.onBackButtonPress,
  }) : super(key: key);

  final bool podcastPageOpen;
  final Future<Podcast> fp;
  final Podcast selectedPodcast;
  final Function onBackButtonPress;

  @override
  _PodcastPageState createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.maxFinite,
      height: double.maxFinite,
      duration: Duration(milliseconds: 300),
      transform: Matrix4.translationValues(widget.podcastPageOpen?0:MediaQuery.of(context).size.width, 0, 0),
      child: Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(20.0),
        child: FutureBuilder(
          future: widget.fp,
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
                          onPressed: widget.onBackButtonPress,
                        ),
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: widget.selectedPodcast.title,
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
                                  text: widget.selectedPodcast.description,
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
                                    image: NetworkImage(widget.selectedPodcast.artLink)??'   ',
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
                        itemCount: widget.selectedPodcast.episodes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                PodcastProvider.of(context).setEpisode(
                                  widget.selectedPodcast.episodes.elementAt(index)
                                );
                              });
                            },
                            child: Container(
                              width: double.maxFinite,
                              height: 100.0,
                              child: RichText(
                                text: TextSpan(
                                  text: widget.selectedPodcast.episodes.elementAt(index).name,
                                  style: TextStyle(
                                    color: Colors.black
                                  )
                                ),
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