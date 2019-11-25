import 'package:flutter/material.dart';
import 'package:podtastic/podcast_provider.dart';

class NowPlayingControls extends StatefulWidget {
  const NowPlayingControls({
    Key key,
  }) : super(key: key);

  @override
  _NowPlayingControlsState createState() => _NowPlayingControlsState();
}

class _NowPlayingControlsState extends State<NowPlayingControls> {

  double iconSize = 30.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Container(
            height: (MediaQuery.of(context).size.height*0.5),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(child: buildPlayerControls(context)),
                buildMetaControls(context, iconSize),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlayerControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(child: Container(),),
        IconButton(
          icon: Material(
            borderRadius: BorderRadius.circular(30.0),
            child: Icon(Icons.replay_30),
            elevation: 30.0,
            color: Colors.transparent,
          ),
          color: Theme.of(context).primaryColor,
          iconSize: MediaQuery.of(context).size.width / 6.5,
          onPressed: () {
            setState(() async {
              PodcastProvider.of(context).skip(Duration(seconds: -30));
            });
          },
        ),
        Expanded(child: Container(),),
        IconButton(
          icon: Material(
            borderRadius: BorderRadius.circular(30.0),
            child: Icon(
              (PodcastProvider.of(context).playing)?
              Icons.pause_circle_filled :
              Icons.play_circle_filled
            ),
            elevation: 30.0,
            color: Colors.transparent,
          ),
          color: Theme.of(context).primaryColor,
          iconSize: MediaQuery.of(context).size.width / 6,
          onPressed: () {
            setState(() {
              PodcastProvider.of(context).playPause();
            });
          },
        ),
        Expanded(child: Container(),),
        IconButton(
          icon: Material(
            borderRadius: BorderRadius.circular(30.0),
            child: Icon(Icons.forward_30),
            elevation: 30.0,
            color: Colors.transparent,
          ),
          color: Theme.of(context).primaryColor,
          iconSize: MediaQuery.of(context).size.width / 6.5,
          onPressed: () {
            setState(() {
              PodcastProvider.of(context).skip(Duration(seconds: 30));
            });
          },
        ),
        Expanded(child: Container(),),
      ],
    );
  }
}
  Widget buildMetaControls(BuildContext context, double iconSize) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: iconSize * 3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: IconButton(
              icon: Icon(Icons.star_border),
              color: Theme.of(context).primaryColor,
              iconSize: iconSize,
              onPressed: (){},
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.launch),
              color: Theme.of(context).primaryColor,
              iconSize: iconSize,
              onPressed: (){},
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.menu),
              color: Theme.of(context).primaryColor,
              iconSize: iconSize,
              onPressed: (){},
            ),
          ),
        ],
      ),
    );
  }