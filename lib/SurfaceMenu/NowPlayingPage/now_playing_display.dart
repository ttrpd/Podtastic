import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:podtastic/SurfaceMenu/NowPlayingPage/seek_bar.dart';
import 'package:podtastic/podcast_provider.dart';

class NowPlayingDisplay extends StatefulWidget {
  const NowPlayingDisplay({
    Key key,
    @required this.onBackArrowTap,
  }) : super(key: key);

  final void Function() onBackArrowTap;
  @override
  _NowPlayingDisplayState createState() => _NowPlayingDisplayState();
}

class _NowPlayingDisplayState extends State<NowPlayingDisplay> {

  String trimDurationString(Duration dur)
  {
    List<String> units = dur.toString().split('.');
    units.removeLast();
    return units.join('.');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height/2.6)),
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).backgroundColor,),
                          color: Colors.transparent,
                          onPressed: widget.onBackArrowTap,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.settings, color: Theme.of(context).backgroundColor,),
                          color: Colors.transparent,
                          onPressed: widget.onBackArrowTap,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: PageView(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, left: 16.0, bottom: 0.0, right: 16.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.maxFinite,
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: PodcastProvider.of(context).playingEpisode?.name ?? "",
                                        style: Theme.of(context).primaryTextTheme.title
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Theme.of(context).primaryTextTheme.title.color,
                                  indent: 100.0,
                                  endIndent: 100.0,
                                  height: max(25, MediaQuery.of(context).size.height / 22)
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 0.0, top: 0.0),
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: ((MediaQuery.of(context).size.height / 4)
                                        ~/ Theme.of(context).primaryTextTheme.body1.fontSize),
                                      text: TextSpan(
                                        text: PodcastProvider.of(context).playingEpisode?.description ?? "",
                                        style: Theme.of(context).primaryTextTheme.body1
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 1.5,
                                  height: MediaQuery.of(context).size.width / 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height/7.5,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: StreamBuilder(
                          stream: PodcastProvider.of(context).audioPlayer.onAudioPositionChanged,
                          builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: RichText(
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    text: TextSpan(
                                      text: trimDurationString(PodcastProvider.of(context).currentTime),
                                      style: Theme.of(context).primaryTextTheme.display1
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  child: SeekBar(
                                    barWidth: MediaQuery.of(context).size.width*0.6,
                                    trackProgressPercent: (snapshot.data?.inMilliseconds ?? 0)
                                      / PodcastProvider.of(context).endTime.inMilliseconds,
                                    onSeekRequested: (double seekPercent) {
                                      setState(() {
                                        final seekMils = (PodcastProvider.of(context).endTime.inMilliseconds.toDouble() * seekPercent).round();
                                        PodcastProvider.of(context).audioPlayer.seek(Duration(milliseconds: seekMils));
                                        PodcastProvider.of(context).trackProgressPercent = seekMils.toDouble() / PodcastProvider.of(context).endTime.inMilliseconds.toDouble();
                                        PodcastProvider.of(context).currentTime = Duration(milliseconds: seekMils);
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: RichText(
                                    overflow: TextOverflow.clip,
                                    maxLines: 1,
                                    text: TextSpan(
                                      text: trimDurationString(PodcastProvider.of(context).getTimeRemaining()),
                                      style: Theme.of(context).primaryTextTheme.display1
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}