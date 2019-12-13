import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:podtastic/podcast.dart';

class PodcastSliver extends StatefulWidget {
  const PodcastSliver({
    Key key,
    @required this.selectedPodcast,
    @required this.onTap,
  }) : super(key: key);

  final Podcast selectedPodcast;
  final Function onTap;

  @override
  _PodcastSliverState createState() => _PodcastSliverState();
}

class _PodcastSliverState extends State<PodcastSliver> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Theme.of(context).primaryColorDark,
      onTap: widget.onTap,
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
                          image: NetworkImage(widget.selectedPodcast.thumbnailLink),
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
                    text: widget.selectedPodcast.title,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}