import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:podtastic/podcast.dart';

class PodcastProvider extends InheritedWidget
{
  PodcastProvider({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  AudioPlayer audioPlayer = AudioPlayer();
  Episode playingEpisode;
  bool playing = false;

  void setEpisode(Episode ep)
  {
    ep.link = ep.link.replaceRange(0, ep.link.indexOf(':'), "https");
    playingEpisode = ep;
    audioPlayer.setUrl(ep.link);
  }

  void playPause()
  {
    if(playing)
      audioPlayer.pause();
    else
      audioPlayer.resume();

    playing = !playing;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static PodcastProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PodcastProvider) as PodcastProvider);
  }
}