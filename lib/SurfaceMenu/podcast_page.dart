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
    @required this.onNowPlayTap,
  }) : super(key: key);

  final bool podcastPageOpen;
  final Future<Podcast> fp;
  final Podcast selectedPodcast;
  final Function onBackButtonPress;
  final Function() onNowPlayTap;

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
            if(snapshot == null || !snapshot.hasData || snapshot.data == null)
              return Container();

            return Container(
              color: Theme.of(context).primaryColor,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    elevation: 0.0,
                    centerTitle: true,
                    floating: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 50.0,
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back, color: Colors.grey, size: 30.0,),
                                onPressed: widget.onBackButtonPress,
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Container(
                                alignment: Alignment.center,
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: snapshot.data?.title ?? "",
                                    style: Theme.of(context).primaryTextTheme.title,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 50.0,
                              height: 50.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 150.0,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 160.0,
                              child: RichText(
                                maxLines: 10,
                                text: TextSpan(
                                  text: snapshot.data?.description ?? "",
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
                                    image: NetworkImage(snapshot.data?.artLink)??'   ',
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
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if(snapshot.data.episodes == null)
                          return Container();

                        return InkWell(
                          onTap: () {
                            widget.onNowPlayTap();
                            PodcastProvider.of(context).setEpisode(
                              snapshot.data.episodes.elementAt(index)
                            );
                            setState((){});
                          },
                          child: Container(
                            width: double.maxFinite,
                            alignment: Alignment.centerLeft,
                            height: 100.0,
                            child: RichText(
                              text: TextSpan(
                                text: snapshot.data.episodes.elementAt(index).name,
                                style: TextStyle(
                                  color: Colors.black
                                )
                              ),
                            ),
                          ),
                        );
                      }
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